//
//  Blog.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/26/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper

class Blog: BaseModel {
    var blogId          : String?
    var owner           : Owner?
    var content         : [String]?
    var title           : String?
    var description     : String?
    var location        : String?
    var createdDate     : SwivelDate?
    var updatedDate     : SwivelDate?
    var totalLikes      : Int?
    var totalComments   : Int?
    var totalShares     : Int?

    override init() {
        super.init()
    }
    required init?(map: Map) {
        super.init(map: map)
        self.id         = self.blogId
    }

    override func mapping(map: Map) {
        blogId          <- map["blogId"]
        owner           <- map["owner"]
        content         <- map["content"]
        title           <- map["title"]
        description     <- map["description"]
        location        <- map["location"]
        createdDate     <- map["createdDate"]
        updatedDate     <- map["updatedDate"]
        totalLikes      <- map["totalLikes"]
        totalComments   <- map["totalComments"]
        totalShares     <- map["totalShares"]
        self.id         = self.blogId
    }
    
    init(blogId: String, owner: Owner, content: [String]?, title: String, description: String?, location: String?, createdDate: SwivelDate?, updatedDate: SwivelDate?, totalLikes: Int, totalComments: Int, totalShares: Int) {
        self.blogId                 = blogId
        self.owner                  = owner
        self.content                = content
        self.title                  = title
        self.description            = description
        self.location               = location
        self.createdDate            = createdDate
        self.updatedDate            = updatedDate
        self.totalLikes             = totalLikes
        self.totalComments          = totalComments
        self.totalShares            = totalShares
        
        super.init(id: self.blogId!)
    }

}
