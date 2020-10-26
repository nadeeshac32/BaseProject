//
//  ProfileAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Alamofire

// Confiming to this protocol enables you to upload and download files
protocol ProfileAPIProtocol {
    
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
