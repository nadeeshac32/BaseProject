//
//  HTTPService.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
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
    private func genericRequest<T: BaseModel>(method: HTTPMethod,
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

        request.responseJSON { response in
            var exception                           : RestClientError?
            if let errorMessage = response.error?.localizedDescription {
                exception                           = RestClientError.AlamofireError(message: errorMessage)
            } else {
                if response.data != nil {
                    
                    // Status check for backend response
                    if (200..<300).contains((response.response?.statusCode)!) {
                        //  #if DEBUG
                        //  print("response.result.value        : \(String(describing: response.result.value))")
                        //  #endif
                        
                        // Convert to Auth object
                        if responseType == UserAuth.self,
                            let serverResponse      = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralAuthResponse>().map(JSON: serverResponse),
                            let authObject          = responseObject.data as? T {
                            completionHandler?(authObject)
                            return
                            
                        // Convert to Objects array
                        } else if let serverResponse  = response.value as? Dictionary<String, AnyObject>,
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
                            
                        // Return Error if response couldn't pass to any of the above
                        } else {
                            exception               = RestClientError.JsonParseError
                        }
                    // Status check fails and Back and returns error.
                    } else if let dataObject = response.value as? Dictionary<String, Any> {
                        // Initialize Backend error
                        exception                   = RestClientError.init(jsonResult: dataObject)
                    
                    // Generate Json pass error
                    } else {
                        exception                   = RestClientError.JsonParseError
                    }
                } else {
                    exception                       = RestClientError.EmptyDataError
                }
            }

            if let error = exception {
                #if DEBUG
                print("")
                print("status code                  : \(String(describing: response.response?.statusCode))")
                print("error                        : \(error)")
                print("baseUrl                      : \(self.baseUrl ?? "")")
                print("contextPath                  : \(contextPath)")
                print("parameters                   : \(String(describing: self.parameters))")
                print("response.result.value        : \(String(describing: response.value))")
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

extension HTTPService: FileAPIProtocol {
    func uploadImageRequest(image: UIImage,
                            imageName: String,
                            onError: ErrorCallback? = nil,
                            completionHandler: ((ImagePostData) -> Void)? = nil) {

        let urlString                               = "\(self.baseUrl!)/\(urls.imagePath)/images/upload"
        let parameters                              : [String : AnyObject]  = [
            "uploadName"                            : "\(imageName)" as AnyObject
        ]
        self.parameters?.update(other: parameters)

        var exception                           : RestClientError?
        image.resizedTo1MB(completionHandler: { [weak self] (resizedImage) in

            guard let resizedImage = resizedImage, let `self` = self else {
                exception                           = RestClientError.EmptyDataError
                onError?(exception!)
                return
            }
            self.headers?["X-API-Key"]              = AppConfig.si.x_API_Key
                        
            AF.upload(
                multipartFormData: { multipartFormData in
                    if let imageData = resizedImage.pngData() {
                        multipartFormData.append(imageData, withName: "image", fileName: "image", mimeType: "image/png")
                    }
                    if self.parameters != nil {
                        for (key, value) in self.parameters! {
                            if let valueData = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                                multipartFormData.append(valueData, withName: key)
                            }
                        }
                    }
                },
                to : urlString,
                method: .post,
                headers: self.headers
            ).responseJSON { (response) in
                var exception                           : RestClientError?
                if let errorMessage = response.error?.localizedDescription {
                    exception                           = RestClientError.AlamofireError(message: errorMessage)
                } else {
                    if response.data != nil {
                        if (200..<300).contains((response.response?.statusCode)!) {
                            //  print("response.result.value        : \(String(describing: response.result.value))")
                            if let serverResponse = response.value as? Dictionary<String, AnyObject>, let dict = serverResponse["data"] as? Dictionary<String, AnyObject>,
                                let responseObject      = Mapper<ImagePostData>().map(JSON: dict) {
                                completionHandler?(responseObject)
                                return
                            } else {
                                exception               = RestClientError.JsonParseError
                            }
                        } else if let dataObject = response.value as? Dictionary<String, Any> {
                            exception                   = RestClientError.init(jsonResult: dataObject)
                        } else {
                            exception                   = RestClientError.JsonParseError
                        }
                    } else {
                        exception                       = RestClientError.EmptyDataError
                    }
                }

                if let error = exception {
                    #if DEBUG
                    print("")
                    print("request                  : \(response.debugDescription)")
                    print("status code              : \(String(describing: response.response?.statusCode))")
                    print("error                    : \(error)")
                    print("baseUrl                  : \(self.baseUrl ?? "")")
                    print("urlString                : \(urlString)")
                    print("parameters               : \(String(describing: self.parameters))")
                    //  print("multipartForm Data       : \(encodingResult.)")
                    print("response.result.value    : \(String(describing: response.value))")
                    #endif
                    onError?(error)
                    return
                }
            }
        })
    }
    
    func downloadImage(imagePath: String, completion: ((UIImage?) -> Void)?) {
        if let url = URL(string: imagePath), imagePath.range(of:"https") != nil {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("load user image error : \(String(describing: error))")
                }
                if let data = data {
                    let imageFromData           = UIImage(data: data)
                    DispatchQueue.main.async(execute: {
                        if imagePath != "" && imageFromData != nil {
                            completion?(imageFromData!)
                        } else {
                            completion?(nil)
                        }
                    })
                }
            }).resume()
        }
    }

    func downloadFile(fileName: String,
                      subFolder: DocumentDirectorySubFolder?,
                      removeAllExisting: Bool = false,
                      displayFileName: String,
                      fileFormat: FileFormat,
                      onError: ErrorCallback? = nil,
                      completionHandler: ((URL) -> Void)? = nil) {

        let documentsURL                    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        let folderURL                       : URL
        if let subFolder = subFolder {
            folderURL                       = documentsURL.appendingPathComponent("\(subFolder.rawValue)")
        } else {
            folderURL                       = documentsURL
        }

        let destinationPath: DownloadRequest.Destination = { _, _ in
            let fileURL                     = folderURL.appendingPathComponent("\(displayFileName)\(fileFormat.rawValue)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        if removeAllExisting {
            do {
                let fileURLs                = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                                                              includingPropertiesForKeys: nil,
                                                                                              options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } catch  {
                print("contents of directory error: \(error)")
            }
        }

        let downloadUrl: String                 = "\(self.baseUrl!)/\(urls.imagePath)/files/download?fileName=\(fileName)"
        self.headers?["X-API-Key"]              = AppConfig.si.x_API_Key
        AF.download(downloadUrl, headers: self.headers, to: destinationPath)
            .response { (response) in
                if response.error != nil{
                    onError?(RestClientError.UndefinedError)
                } else if let filePath = response.fileURL {
                    completionHandler?(filePath)
                }
            }
    }
}

extension HTTPService: UserAPIProtocol {
    func generateOTP(method: HTTPMethod! = .post, email: String? = nil, mobile: MobileNumber? = nil, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath = "\(urls.otpPath)/otp/generate"
        var parameters                              : [String : AnyObject]  = [:]
        if email != nil {
            parameters["email"]                     = "\(email!)" as AnyObject
        }
        if mobile != nil {
            parameters["mobileNo"]                  = mobile!.toJSON() as AnyObject
        }
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }

    func verifyOTP(method: HTTPMethod! = .post, otp: String!, email: String? = nil, mobile: MobileNumber? = nil, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath = "\(urls.otpPath)/otp/verify"
        var parameters                              : [String : AnyObject]  = ["otp": "\(otp!)" as AnyObject]
        if email != nil {
            parameters["email"]                     = "\(email!)" as AnyObject
        }
        if mobile != nil {
            parameters["mobileNo"]                  = (mobile?.toJSON() ?? [:]) as AnyObject
        }
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func signup(method: HTTPMethod! = .post, userPostData: UserPostData!, onSuccess: ((_ user: UserAuth) -> Void)?, onError: ErrorCallback?) {
        let contextPath = "\(urls.authPath)/users"
//        self.headers?["Authorization"] = nil
        let parameters                              : [String: Any]  = userPostData.toJSON()
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandler: { (user) in
            UserAuth.si.setUserDetails(user: user)
            onSuccess?(user)
            return
        })
    }

    func signin(method: HTTPMethod! = .post, username: String! = "", password: String! = "", isRefreshCall: Bool = false, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.signInPath)"
//        self.headers?["Authorization"]  = "Basic \(AppConfig.si.loginToken!)"
//        self.headers?["Content-Type"]   = "application/x-www-form-urlencoded"
        let parameters                  : [String : AnyObject]
        if isRefreshCall {
            parameters                  = [
                "refresh_token"         : "\(UserAuth.si.refreshToken)" as AnyObject,
                "grant_type"            : "refresh_token" as AnyObject
            ]
        } else {
            parameters                  = [
                "username"              : "\(username!)" as AnyObject,
                "password"              : "\(password!)" as AnyObject,
                "grant_type"            : "password" as AnyObject
            ]
        }
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, encoding: nil, onError: onError, completionHandler: { (user) in
            user.signedIn               = true
            UserAuth.si.setUserDetails(user: user)
            UserAuth.si.printUser()
            onSuccess?()
            return
        })
    }
    
    func signupWithGoogle(method: HTTPMethod! = .post, idToken: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/google/signup"
        let parameters                  : [String : AnyObject] = [
            "idToken"                   : "\(idToken!)" as AnyObject
        ]
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandler: { (user) in
            user.signedIn               = true
            UserAuth.si.setUserDetails(user: user)
            onSuccess?()
            return
        })
    }
    
    func signinWithGoogle(method: HTTPMethod! = .post, idToken: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/google/sign-in"
        let parameters                  : [String : AnyObject] = [
            "idToken"                   : "\(idToken!)" as AnyObject
        ]
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: { [weak self] (error) in
            switch error {
            case let .ServerError(code, _):
                if code == 4004 {
                    self?.signupWithGoogle(idToken: idToken, onSuccess: { [weak self] in
                        self?.genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandler: { (user) in
                            user.signedIn               = true
                            UserAuth.si.setUserDetails(user: user)
                            UserAuth.si.printUser()
                            onSuccess?()
                            return
                        })
                        return
                    }, onError: onError)
                    return
                } else {
                    onError?(error)
                    return
                }
            default:
                onError?(error)
                return
            }
        }, completionHandler: { (user) in
            user.signedIn               = true
            UserAuth.si.setUserDetails(user: user)
            UserAuth.si.printUser()
            onSuccess?()
            return
        })
    }
    
    func signupWithFacebook(method: HTTPMethod! = .post, accessToken: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/facebook/signup"
        let parameters                  : [String : AnyObject] = [
            "accessToken"               : "\(accessToken!)" as AnyObject
        ]
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandler: { (user) in
            user.signedIn               = true
            UserAuth.si.setUserDetails(user: user)
            onSuccess?()
            return
        })
    }
    
    func signinWithFacebook(method: HTTPMethod! = .post, accessToken: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/facebook/sign-in"
        let parameters                  : [String : AnyObject] = [
            "accessToken"               : "\(accessToken!)" as AnyObject
        ]
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: { [weak self] (error) in
            switch error {
            case let .ServerError(code, _):
                if code == 4004 {
                    self?.signupWithFacebook(accessToken: accessToken, onSuccess: { [weak self] in
                        self?.genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: UserAuth.self, onError: onError, completionHandler: { (user) in
                            user.signedIn               = true
                            UserAuth.si.setUserDetails(user: user)
                            UserAuth.si.printUser()
                            onSuccess?()
                            return
                        })
                        return
                    }, onError: onError)
                    return
                } else {
                    onError?(error)
                    return
                }
            default:
                onError?(error)
                return
            }
        }, completionHandler: { (user) in
            user.signedIn               = true
            UserAuth.si.setUserDetails(user: user)
            UserAuth.si.printUser()
            onSuccess?()
            return
        })
    }
}

extension HTTPService: ProfileAPIProtocol {
    func updateMobile(method: HTTPMethod! = .put, mobileNo: MobileNumber!, onSuccess: ((_ user: User) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users/mobileNo"
        let parameters: [String : AnyObject]  = [
            "mobileNo"                  : mobileNo.toJSON() as AnyObject
        ]
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: User.self, onError: onError, completionHandler: { (user) in
            onSuccess?(user)
            return
        })
    }
    
    func updateEmail(method: HTTPMethod! = .put, email: String!, onSuccess: ((_ user: User) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users/email"
        let parameters: [String : AnyObject]  = [
            "email"                     : email as AnyObject
        ]
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: User.self, onError: onError, completionHandler: { (user) in
            onSuccess?(user)
            return
        })
    }
    
    func updateResetPassword(method: HTTPMethod! = .put, mobileNo: MobileNumber!, newPassword: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users/password/reset"
        let parameters: [String : AnyObject]  = [
            "mobileNo"                  : mobileNo.toJSON() as AnyObject,
            "password"                  : "\(newPassword!)" as AnyObject
        ]
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: User.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
}

extension HTTPService: BlogAPIProtocol {
    func getBlogFeed(method: HTTPMethod! = .get, page: Int, limit: Int, onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/summary/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            onSuccess?(arrayResponse.items ?? [], arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit)
            return
        })
    }
    
    func createBlog(method: HTTPMethod! = .post, blog: Blog!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog"
        let parameters                  = blog.toJSON()
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func updateBlog(method: HTTPMethod! = .put, blog: Blog!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog"
        let parameters                  = blog.toJSON()
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func likeBlog(blogId: String!, isLike: Bool, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/like/\(blogId!)"
        let method                      = isLike == true ? HTTPMethod.post : HTTPMethod.delete
        
        genericRequest(method: method, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func getBlogsByUser(method: HTTPMethod! = .get, user: User, page: Int, limit: Int, onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/user/summary/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            let owner                   = Owner(id: user.id, name: user.fullName ?? "", imageUrl: user.imageUrl)
            let updatedBlogs            = (arrayResponse.items ?? []).map { (blog) -> Blog in
                blog.owner              = owner
                return blog
            }
            onSuccess?(updatedBlogs, arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit)
            return
        })
    }
    
    func getBlogComments(method: HTTPMethod! = .get, blogId: String, page: Int, limit: Int, onSuccess: ((_ comments: [Comment], _ total: Int, _ page: Int, _ limit: Int, _ size: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/comment/\(blogId)/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Comment.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            onSuccess?(arrayResponse.items ?? [], arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit, arrayResponse.size ?? 0)
            return
        })
    }
    
    func deleteBlogWithId(method: HTTPMethod! = .delete, blogId: String, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/\(blogId)"
        genericRequest(method: method, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
}
