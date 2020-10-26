//
//  ArrayDataType.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/15/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import ObjectMapper

class ArrayDataType<DataType: BaseModel>: BaseModel {
    var items   : [DataType]?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        items   <- map[DataType.arrayKey]
    }
    
}
