//
//  GeneralArrayResponse.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/15/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class GeneralArrayResponse<DataType: BaseModel>: BaseModel {
    var status              : String?
    var message             : String?
    var data                : ArrayDataType<DataType>?
    var displayMessage      : String?
    var errorCode           : Int?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status              <- map["status"]
        message             <- map["message"]
        data                <- map["data"]
        displayMessage      <- map["displayMessage"]
        errorCode           <- map["errorCode"]
    }    
}
