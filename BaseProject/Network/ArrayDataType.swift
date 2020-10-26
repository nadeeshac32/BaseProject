//
//  ArrayDataType.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/15/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import ObjectMapper

class ArrayDataType<DataType: BaseModel>: BaseModel {
    var total               : Int?
    var totalPages          : Int?
    var page                : Int?
    var size                : Int?
    var displayLabel        : String?
    var items               : [DataType]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total               <- map["totalItems"]
        totalPages          <- map["totalPages"]
        page                <- map["page"]
        size                <- map["size"]
        displayLabel        <- map["displayLabel"]
        items               <- map[DataType.arrayKey]
    }
    
}
