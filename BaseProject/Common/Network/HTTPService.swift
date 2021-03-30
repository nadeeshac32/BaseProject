//
//  HTTPService.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire
import ObjectMapper

struct urls {
    static let apiVersion = "api/v1"
    static var authUrl: String {
        return "cc-auth-service"
    }
    static var authPath: String {
        return "\(authUrl)/\(apiVersion)"
    }
    static var signInPath: String {
        return "\(authUrl)/oauth/token"
    }
    static var otpPath: String {
        return "cc-otp-service/\(apiVersion)"
    }
    static var imagePath: String {
        return "cc-image-uploader/\(apiVersion)"
    }
    static var filePath: String {
        return "cc-file-manager-service/\(apiVersion)"
    }
    static var blogPath: String {
        return "cc-blog-service/\(apiVersion)"
    }
}

class HTTPService: NSObject {
    
        var baseUrl                                     : String?
        var parameters                                  : Parameters? = [:]
        var headers                                     : HTTPHeaders? = [:]

        init(baseUrl: String! = AppConfig.si.baseUrl) { self.baseUrl = baseUrl }
        
        /// Generic method that actually do the network call
        /// - Parameters:
        ///   - method: Request method
        ///   - parameters: Request body `parameters`
        ///   - contextPath: Request `context path`
        ///   - responseType: The type that should passe the `response data` into
        ///   - arrayKey: If the response data is an array it will come under this key
        ///   - encoding: Parameter encoding type
        ///   - onError: On error call back
        ///   - completionHandler: Completion Handler for Single return object
        ///   - completionHandlerForArray: Completion Handler for Array of return objects
        ///   - completionHandlerForNull: Completion Handler for no return objects
        func genericRequest<T: BaseModel>(method: HTTPMethod,
                                                     parameters: Parameters?,
                                                     contextPath: String,
                                                     responseType: T.Type,
                                                     arrayKey: String? = nil,
                                                     encoding: ParameterEncoding? = JSONEncoding.default,
                                                     onError: ErrorCallback? = nil,
                                                     completionHandler: ((T) -> Void)? = nil,
                                                     completionHandlerForArray: ((ArrayDataType<T>) -> Void)? = nil,
                                                     completionHandlerForNull: (() -> Void)? = nil
                                                    ) {

            let urlString                               = "\(self.baseUrl!)/\(contextPath)"
            self.parameters?.update(other: parameters)
    //        #if DEBUG
    //        print("uslString: \(urlString)")
    //        print("self.parameters: \(String(describing: self.parameters))")
    //        print("headers: \(self.headers!)")
    //        #endif
            let request                                 : DataRequest!
            if let encoding = encoding {
                request                                 = AF.request(urlString,
                                                                     method: method,
                                                                     parameters: method == .get ? nil : self.parameters!,
                                                                     encoding: encoding,
                                                                     headers: self.headers!,
                                                                     interceptor: RequestInterceptor(storage: AccessTokenStorage()))
            } else {
                request                                 = AF.request(urlString,
                                                                     method: method,
                                                                     parameters: method == .get ? nil : self.parameters!,
                                                                     headers: self.headers!,
                                                                     interceptor: RequestInterceptor(storage: AccessTokenStorage()))
            }

            request
                .validate(statusCode: [(0..<401), (402..<1000)].joined())
                .responseJSON { response in
                    
                    var exception                       : RestClientError?
                    
                    switch response.result {
                    case .success:
                        if response.data != nil {
                            // Convert to Auth object
                            if responseType == UserAuth.self,
                                let serverResponse      = response.value as? Dictionary<String, AnyObject>,
                                let responseObject      = Mapper<GeneralAuthResponse>().map(JSON: serverResponse),
                                let authObject          = responseObject.data as? T {
                                completionHandler?(authObject)
                                return
                                
                            // Convert to Objects array
                            } else if let serverResponse  = response.value as? Dictionary<String, AnyObject>,
                                let data = serverResponse["data"] as? Dictionary<String, Any>,
                                let _ = data[T.arrayKey] as? [Dictionary<String, Any>],
                                let responseObject      = Mapper<GeneralArrayResponse<T>>().map(JSON: serverResponse),
                                let responseItemsArrayResponse  = responseObject.data {
                                completionHandlerForArray?(responseItemsArrayResponse)
                                return
                            
                            // Convert to Object
                            } else if let serverResponse = response.value as? Dictionary<String, AnyObject>,
                                let responseObject      = Mapper<GeneralObjectResponse<T>>().map(JSON: serverResponse),
                                let object              = responseObject.data {
                                completionHandler?(object)
                                return
                            
                            // Handle when there is empty backend response
                            } else if let serverResponse = response.value as? Dictionary<String, AnyObject>,
                                let responseObject      = Mapper<GeneralEmptyDataResponse>().map(JSON: serverResponse),
                                responseObject.status?.elementsEqual("SUCCESS") == true {
                                completionHandlerForNull?()
                                return

                            // Initialize Backend error
                            }  else if let dataObject = response.value as? Dictionary<String, Any> {
                                exception               = RestClientError.init(jsonResult: dataObject)

                            // Return Error if response couldn't pass to any of the above
                            } else {
                                exception               = RestClientError.JsonParseError
                            }
                        } else {
                            exception                   = RestClientError.EmptyDataError
                        }
                        break
                    case .failure(let error):
                        
                        if let statusCode = response.response?.statusCode, statusCode == 401,
                            let requestRetryFailed1 = error.asAFError, let restClientError = requestRetryFailed1.underlyingError as? RestClientError {
                            exception                   = restClientError
                            
                        // Generate Alamofire error
                        } else if let requestRetryFailed1 = error.asAFError,
                            let requestRetryFailed2     = requestRetryFailed1.underlyingError as? AFError,
                            let sessionTaskFailedError  = requestRetryFailed2.underlyingError as? AFError,
                            let urlError                = sessionTaskFailedError.underlyingError as? URLError, urlError.errorCode == -1009 {
                            exception                   = RestClientError.AlamofireError(message: urlError.localizedDescription)
                            
                        // Generate Undefined error
                        } else {
                            exception                   = RestClientError.UndefinedError
                        }
                        break
                    }
                    
                if let error = exception {
                    #if DEBUG
                    print("")
                    print("status code                  : \(String(describing: response.response?.statusCode))")
                    print("error                        : \(error)")
                    print("baseUrl                      : \(self.baseUrl ?? "")")
                    print("contextPath                  : \(contextPath)")
                    print("parameters                   : \(String(describing: self.parameters))")
                    print("response.value               : \(String(describing: response.value))")
                    print("request                      : \(request.cURLDescription())")
                    #endif
                    onError?(error)
                    return
                }

                
            }
        }
}

extension HTTPService {
    // This method won't be used
    func resizeImage(image: UIImage, size: CGSize, scalar: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scalar)
        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}








