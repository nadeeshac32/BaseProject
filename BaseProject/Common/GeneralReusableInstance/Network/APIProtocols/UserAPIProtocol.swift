//
//  UserAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire

// Confiming to this protocol enables you to create/authenticate user
protocol UserAPIProtocol {    
    func signup(method: HTTPMethod!,
                        userPostData: UserPostData!,
                        onSuccess: ((_ user: UserAuth) -> Void)?,
                        onError: ErrorCallback?)
    
    func signin(method: HTTPMethod!,
                        username: String!,
                        password: String!,
                        isRefreshCall: Bool,
                        onSuccess: SuccessEmptyDataCallback?,
                        onError: ErrorCallback?)
    
    func generateOTP(method: HTTPMethod!,
                        email: String?,
                        mobile: MobileNumber?,
                        onSuccess: SuccessEmptyDataCallback?,
                        onError: ErrorCallback?)
    
    func verifyOTP(method: HTTPMethod!,
                        otp: String!,
                        email: String?,
                        mobile: MobileNumber?,
                        onSuccess: SuccessEmptyDataCallback?,
                        onError: ErrorCallback?)
    
    func signupWithGoogle(method: HTTPMethod!,
                          idToken: String!,
                          onSuccess: SuccessEmptyDataCallback?,
                          onError: ErrorCallback?)
    
    func signinWithGoogle(method: HTTPMethod!,
                          idToken: String!,
                          onSuccess: SuccessEmptyDataCallback?,
                          onError: ErrorCallback?)
    
    func signupWithFacebook(method: HTTPMethod!,
                            accessToken: String!,
                            onSuccess: SuccessEmptyDataCallback?,
                            onError: ErrorCallback?)
    
    func signinWithFacebook(method: HTTPMethod!,
                            accessToken: String!,
                            onSuccess: SuccessEmptyDataCallback?,
                            onError: ErrorCallback?)
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
            if !isRefreshCall {
                user.username           = username
            } else {
                user.username           = UserAuth.si.username
            }
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
            case let .BackendError(code, _):
                print("*** ServerError code: \(code)")
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
            case let .BackendError(code, _):
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
