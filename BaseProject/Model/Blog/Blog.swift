//
//  Blog.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/26/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class Blog: BaseModel {
    var blogId          : String?
    var owner           : Owner?
    var userId          : String?
    var title           : String?
    var desc            : String?
    var location        : String?
    var content         : [String]?
    var createdDate     : NCDate?
    var updatedDate     : NCDate?
    var totalLikes      : Int?
    var isLiked         : Bool? = false
    var totalComments   : Int?
    var totalShares     : Int?

    var _location       = BehaviorSubject<String>(value: "")
    var _title          = BehaviorSubject<String>(value: "")
    var _desc           = BehaviorSubject<String>(value: "")
    
    override init() {
        self.blogId                     = ""
        self.title                      = ""
        self.desc                       = ""
        self.location                   = ""
        self.owner                      = Owner(id: UserAuth.si.userId, name: User.si.fullName, imageUrl: User.si.imageUrl)
        self.userId                     = owner?.id
        super.init()
    }
    
    init(blogId: String?, owner: Owner?, title: String?, content: [String]?, desc: String?, location: String?) {
        self.blogId                     = blogId
        self.owner                      = owner
        self.userId                     = owner?.id
        self.title                      = title
        self.desc                       = desc
        self.location                   = location
        self.content                    = content
        
        _title                          = BehaviorSubject<String>(value: title ?? "")
        _desc                           = BehaviorSubject<String>(value: desc ?? "")
        _location                       = BehaviorSubject<String>(value: location ?? "")
        super.init(id: self.blogId!)
    }
    
    required init?(map: Map) {
        super.init(map: map)
        self.id                         = self.blogId
    }

    override func mapping(map: Map) {
        blogId                          <- map["blogId"]
        owner                           <- map["owner"]
        userId                          <- map["userId"]
        title                           <- map["title"]
        desc                            <- map["description"]
        location                        <- map["location"]
        content                         <- map["content"]
        createdDate                     <- map["createdDate"]
        updatedDate                     <- map["updatedDate"]
        totalLikes                      <- map["totalLikes"]
        isLiked                         <- map["isLiked"]
        totalComments                   <- map["totalComments"]
        totalShares                     <- map["totalShares"]
        
        _title                          = BehaviorSubject<String>(value: title ?? "")
        _desc                           = BehaviorSubject<String>(value: desc ?? "")
        _location                       = BehaviorSubject<String>(value: location ?? "")
        
        self.id         				= self.blogId
    }
    
    func updateSaved() {
        if let savedValue = editedValues() {
            self.title                  = savedValue.title
            self.desc                   = savedValue.desc
            self.location               = savedValue.location
        }
    }
    
    func resetData() {
        _title.onNext(title ?? "")
        _desc.onNext(desc ?? "")
        _location.onNext(location ?? "")
    }

    func clearData() {
        _title.onNext("")
        _desc.onNext("")
        _location.onNext("")
    }

    func hasEdited() -> Bool {
        if let edit = editedValues() {
            return edit.title != title || edit.desc != desc || edit.location != location
        } else {
            return false
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        if let edit = editedValues() {
            return Blog(blogId: blogId, owner: owner, title: edit.title, content: content, desc: edit.desc, location: edit.location)
        }
        return Blog(blogId: blogId, owner: owner, title: title, content: content, desc: desc, location: location)
    }
    
    func editedValues() -> (title: String?, desc: String?, location: String?, images: [UIImage]?)? {
        do {
            let titleString                 = try _title.value()
            let descString                  = try _desc.value()
            let location                    = try _location.value()
                   
            return (titleString, descString, location, nil)
        } catch let error {
            print("Fetal error: \(error)")
            return nil
        }
    }
    
    
    // TODO: This method will be deleted once the api integrated
    init(blogId: String, owner: Owner, content: [String]?, title: String?, description: String?, location: String?, createdDate: NCDate?, updatedDate: NCDate?, totalLikes: Int, isLiked: Bool, totalComments: Int, totalShares: Int) {
        self.blogId                     = blogId
        self.owner                      = owner
        self.content                    = content
        self.title                      = title
        self.desc                       = description
        self.location                   = location
        self.createdDate                = createdDate
        self.updatedDate                = updatedDate
        self.totalLikes                 = totalLikes
        self.isLiked                    = isLiked
        self.totalComments              = totalComments
        self.totalShares                = totalShares
        _title                          = BehaviorSubject<String>(value: title ?? "")
        _desc                           = BehaviorSubject<String>(value: desc ?? "")
        _location                       = BehaviorSubject<String>(value: location ?? "")
        super.init(id: self.blogId!)
    }

}
