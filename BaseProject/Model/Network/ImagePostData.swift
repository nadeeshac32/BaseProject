//
//  ImagePostData.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import ObjectMapper

class ImagePostData : Mappable {
    var imageUrl        : String?
    var contentType     : String?
    var imageByteSize   : Int?

    required init?(map: Map) { }

    func mapping(map: Map) {
        imageUrl        <- map["imageUrl"]
        contentType     <- map["contentType"]
        imageByteSize   <- map["imageByteSize"]
    }

}
