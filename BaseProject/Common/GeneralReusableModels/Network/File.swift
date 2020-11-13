//
//  File.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/13/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import ObjectMapper

class File: BaseModel {
    var url             : String?
    var contentType     : String?
    var byteSize        : Int?
    var name            : String?
    var desc            : String?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        url             <- map["url"]
        contentType     <- map["contentType"]
        byteSize        <- map["byteSize"]
        name            <- map["name"]
        desc            <- map["description"]
        self.id         = url
    }

}
