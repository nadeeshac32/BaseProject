//
//  Owner.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/26/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner : BaseModel {
    var ownerId         : String?
    var name            : String?
    var imageUrl        : String?

    required init?(map: Map) {
        super.init(map: map)
        self.id         = self.ownerId
    }

    override func mapping(map: Map) {
        ownerId         <- map["id"]
        name            <- map["name"]
        imageUrl        <- map["imageUrl"]
        
        self.id         = ownerId
    }
    
    // temp method
    init(id: String, name: String?, imageUrl: String?) {
        self.ownerId    = id
        self.name       = name
        self.imageUrl   = imageUrl
        super.init(id: id)
    }

}
