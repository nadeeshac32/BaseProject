//
//  NCDate.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/26/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper

class NCDate : Mappable {
    var milliseconds    : Int?
    var displayDate     : String?
    var displayDateTime : String?
    var displayText     : String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        milliseconds    <- map["milliseconds"]
        displayDate     <- map["displayDate"]
        displayDateTime <- map["displayDateTime"]
        displayText     <- map["displayText"]
    }
    
    // Temp method
    init(displayText: String?) {
        self.displayText = displayText
    }

}
