//
//  FileAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire
import ObjectMapper

enum DocumentDirectorySubFolder: String {
    case SubfolderPDFFolder     = "Subfolder/PDF Files"
    case SubfolderCSVFolder     = "Subfolder/CSV Files"
    case Subfolder              = "Subfolder"
}

enum FileFormat: String {
    case PDF = ".pdf"
    case CSV = ".csv"
}

// Confiming to this protocol enables you to upload and download files
protocol FileAPIProtocol {
    
    func uploadImageRequest(image: UIImage,
                            imageName: String,
                            onError: ErrorCallback?,
                            completionHandler: ((ImagePostData) -> Void)?)
    
    func downloadImage(imagePath: String, completion: ((UIImage?) -> Void)?)
    
    func downloadFile(fileName: String,
                      subFolder: DocumentDirectorySubFolder?,
                      removeAllExisting: Bool,
                      displayFileName: String,
                      fileFormat: FileFormat,
                      onError: ErrorCallback?,
                      completionHandler: ((URL) -> Void)?)
    
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
                        
            AF.upload(multipartFormData: { multipartFormData in
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
    
    func uploadFilesRequest(files: [MultimediaPostData],
                            fileName: String = "Test",
                            onError: ErrorCallback? = nil,
                            progressHandler: ((CGFloat) -> Void)? = nil,
                            completionHandler: ((GeneralArrayResponse<File>) -> Void)? = nil) {
        
        let urlString                               = "\(self.baseUrl!)/\(urls.filePath)/files/upload"
        let parameters                              : [String : AnyObject]  = [
            "fileName"                              : "\(fileName)" as AnyObject
        ]
        self.parameters?.update(other: parameters)

        AF.upload(multipartFormData: { multipartFormData in
                    for file in files {
                        if let imageData = file.image?.pngData() {
                            multipartFormData.append(imageData, withName: "files", fileName: "files", mimeType: "image/png")
                        } else if let url = file.url, let mimeType = file.mimeType {
                            multipartFormData.append(url, withName: "files", fileName: "files", mimeType: mimeType)
                        }
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
                headers: self.headers,
                interceptor: RequestInterceptor(storage: AccessTokenStorage())
        ).uploadProgress { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseJSON { (response) in
            var exception                           : RestClientError?
            if let errorMessage = response.error?.localizedDescription {
                exception                           = RestClientError.AlamofireError(message: errorMessage)
            } else {
                if response.data != nil {
                    if (200..<300).contains((response.response?.statusCode)!) {
                        //  print("response.result.value        : \(String(describing: response.result.value))")
                        if let serverResponse  = response.value as? Dictionary<String, AnyObject>,
                            let responseObject      = Mapper<GeneralArrayResponse<File>>().map(JSON: serverResponse) {
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
    }
    
    func downloadImage(imagePath: String, completion: ((UIImage?) -> Void)?) {
        if imagePath.range(of:"file://") != nil, let image = UIImage(contentsOfFile: imagePath) {
            completion?(image)
        } else if let url = URL(string: imagePath), imagePath.range(of:"https") != nil {
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
                } else {
                    completion?(nil)
                }
            }).resume()
        } else {
            completion?(nil)
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
