//
//  UserPostData.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import ObjectMapper

class UserPostData: Mappable {
    var fullName            : String?
    var password            : String?
    var email               : String?
    var mobileNo            : MobileNumber?

    init(fullName: String, password: String, email: String?, mobileNo: MobileNumber?) {
        self.fullName       = fullName
        self.password       = password
        self.email          = email
        self.mobileNo       = mobileNo
    }
    
    required init?(map: Map) { }

    func mapping(map: Map) {
        fullName            <- map["fullName"]
        password            <- map["password"]
        email               <- map["email"]
        mobileNo            <- map["mobileNo"]
    }

}
