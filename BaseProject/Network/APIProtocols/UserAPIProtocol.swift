//
//  UserAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
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
