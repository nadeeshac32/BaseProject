//
//  RequestInterceptor.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/14/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//


import Alamofire
import ObjectMapper

/// The storage containing your access token, preferable a Keychain wrapper.
protocol RequestInterceptorStorage {
    var accessToken         : String? { get set }
    var loginToken          : String? { get set }
    var userId              : String? { get set }
    var otpAppKey           : String? { get set }
    var language            : String? { get set }
}

struct AccessTokenStorage: RequestInterceptorStorage {
    var accessToken         : String?
    var loginToken          : String?
    var userId              : String?
    var otpAppKey           : String?
    var language            : String?
    
    init() {
        self.accessToken    = UserAuth.si.token
        self.loginToken     = AppConfig.si.loginToken
        self.userId         = UserAuth.si.userId
        self.otpAppKey      = AppConfig.si.otpAppKey
        self.language       = Settings.si.appLanguage?.selectedValue?.stringValue
    }
    
}

final class RequestInterceptor: Alamofire.RequestInterceptor {

    private var storage: RequestInterceptorStorage

    init(storage: RequestInterceptorStorage) {
        self.storage = storage
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // If the request does not require authentication, we can directly return it as unmodified.
        guard urlRequest.url?.absoluteString.hasPrefix("\(AppConfig.si.baseUrl!)") == true else { return completion(.success(urlRequest)) }
        
        var urlRequest = urlRequest
        
        if (urlRequest.url?.absoluteString.contains(urls.authPath) == true
            || urlRequest.url?.absoluteString.contains(urls.blogPath) == true
            || urlRequest.url?.absoluteString.contains(urls.filePath) == true), let userId = storage.userId, let apiKey = AppConfig.si.x_API_Key {
            urlRequest.setValue(userId, forHTTPHeaderField: "x-user-id")
            urlRequest.setValue(TimeZone.current.identifier, forHTTPHeaderField: "X-Time-Zone")
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        }
    
        if urlRequest.url?.absoluteString.contains(urls.otpPath) == true, let otpAppKey = storage.otpAppKey {
            urlRequest.setValue(otpAppKey, forHTTPHeaderField: "app-key")
        }
        
        if let language = storage.language {
            urlRequest.setValue(language, forHTTPHeaderField: "Accept-Language")
        }
        
        if urlRequest.url?.absoluteString.contains(urls.signInPath) == true, let loginToken = storage.loginToken {
            urlRequest.setValue("Basic \(loginToken)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
        } else {
            if let token = storage.accessToken, token != "" {
                urlRequest.headers.add(.authorization(bearerToken: token))
            }
            
            if urlRequest.url?.absoluteString.contains(urls.filePath) == false {
                urlRequest.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            }
        }

        urlRequest.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Accept")
        if (urlRequest.url?.absoluteString.contains("\(urls.otpPath)/otp/generate") == true) {
            print("\(urls.otpPath)/otp/generate headers: \(urlRequest.headers)")
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry error: \(error)")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            //  The request did not fail due to a 401 Unauthorized response. Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        
        let httpService = HTTPService()
        httpService.signin(isRefreshCall: true, onSuccess: { [weak self] in
            self?.storage.accessToken = UserAuth.si.token
            completion(.retry)
        }) { (error) in
            completion(.doNotRetryWithError(error))
        }
    }
    

}
