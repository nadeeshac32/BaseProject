//
//  ProfileAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Alamofire

// Confiming to this protocol enables you to upload and download files
protocol ProfileAPIProtocol {
    
    func getUserById(method: HTTPMethod!,
                    userId: String,
                    onSuccess: ((_ user: User) -> Void)?,
                    onError: ErrorCallback?)
    
    func updateUser(method: HTTPMethod!,
                    user: User!,
                    onSuccess: ((_ user: User) -> Void)?,
                    onError: ErrorCallback?)
    
    func updatePassword(method: HTTPMethod!,
                        oldPassword: String!,
                        newPassword: String!,
                        onSuccess: SuccessEmptyDataCallback?,
                        onError: ErrorCallback?)
    
    func updateMobile(method: HTTPMethod!,
                      mobileNo: MobileNumber!,
                      onSuccess: ((_ user: User) -> Void)?,
                      onError: ErrorCallback?)
    
    func updateEmail(method: HTTPMethod!,
                     email: String!,
                     onSuccess: ((_ user: User) -> Void)?,
                     onError: ErrorCallback?)
    
    func updateResetPassword(method: HTTPMethod!,
                             mobileNo: MobileNumber!,
                             newPassword: String!,
                             onSuccess: SuccessEmptyDataCallback?,
                             onError: ErrorCallback?)
    
}

extension HTTPService: ProfileAPIProtocol {
    func getUserById(method: HTTPMethod! = .get, userId: String, onSuccess: ((_ user: User) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: User.self, onError: onError, completionHandler: { (user) in
            onSuccess?(user)
            return
        })
    }
    
    func updateUser(method: HTTPMethod! = .put, user: User!, onSuccess: ((_ user: User) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users"
        let parameters                  = user.toJSON()
        print("updateUser parameters: \(parameters)")
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: User.self, onError: onError, completionHandler: { (user) in
            onSuccess?(user)
            return
        })
    }
    
    func updatePassword(method: HTTPMethod! = .put, oldPassword: String!, newPassword: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.authPath)/users/password"
        let parameters: [String : AnyObject]  = [
            "password"                  : "\(oldPassword!)" as AnyObject,
            "newPassword"               : "\(newPassword!)" as AnyObject
        ]
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: User.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
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
