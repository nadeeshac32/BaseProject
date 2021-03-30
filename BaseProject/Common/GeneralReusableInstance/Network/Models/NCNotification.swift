//
//  NCNotification.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 3/29/21.
//  Copyright © 2021 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper

class NCNotification: BaseModel {
    var title    : String?
    var body     : String?
    var imageUrl : String?
    var date     : NCDate?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        id       <- map["id"]
        title    <- map["title"]
        body     <- map["body"]
        imageUrl <- map["imageUrl"]
        date     <- map["date"]
    }
    
    override class var arrayKey : String {
        return "notifications"
    }

}
