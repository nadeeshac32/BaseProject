//
//  BlogChildComment.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class BlogChildComment: BaseModel {
    var owner                           : Owner?
    var userId                          : String?
    var comment                         : String?
    var totalLikes                      : Int?
    var isLiked                         : Bool? = false
    var createdDate                     : SwivelDate?
    var updatedDate                     : SwivelDate?
    
    var _comment                        = BehaviorSubject<String>(value: "")
    
    override init() {
        super.init()
        self.comment                    = ""
        self.totalLikes                 = 0
        self.owner                      = Owner(id: UserAuth.si.userId, name: User.si.fullName, imageUrl: User.si.imageUrl)
        self.userId                     = owner?.id
        self.createdDate                = nil
        self.updatedDate                = nil
    }
    
    init(blogCommentId: String?, owner: Owner?, comment: String?, totalLikes: Int?, isLiked: Bool?, createdDate: SwivelDate?, updatedDate: SwivelDate?) {
        super.init(id: blogCommentId ?? "")
        self.id                         = blogCommentId
        self.owner                      = owner
        self.userId                     = owner?.id
        self.comment                    = comment
        self.totalLikes                 = totalLikes ?? 0
        self.isLiked                    = isLiked ?? false
        self.createdDate                = createdDate
        self.updatedDate                = updatedDate
        
        _comment                        = BehaviorSubject<String>(value: comment ?? "")
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        id                              <- map["id"]
        owner                           <- map["owner"]
        userId                          <- map["userId"]
        comment                         <- map["comment"]
        totalLikes                      <- map["totalLikes"]
        isLiked                         <- map["isLiked"]
        createdDate                     <- map["createdDate"]
        updatedDate                     <- map["updatedDate"]
        _comment                        = BehaviorSubject<String>(value: comment ?? "")
    }
    
//    func updateSaved() {
//        if let savedValue = editedValues() {
//            self.title                  = savedValue.title
//            self.desc                   = savedValue.desc
//            self.location               = savedValue.location
//        }
//    }
//
//    func resetData() {
//        _title.onNext(title ?? "")
//        _desc.onNext(desc ?? "")
//        _location.onNext(location ?? "")
//    }
//
//    func clearData() {
//        _title.onNext("")
//        _desc.onNext("")
//        _location.onNext("")
//    }
//
//    func hasEdited() -> Bool {
//        if let edit = editedValues() {
//            return edit.title != title || edit.desc != desc || edit.location != location
//        } else {
//            return false
//        }
//    }
//
//    func imageHasEdited() -> Bool {
//        return false
//    }
//
//    func copy(with zone: NSZone? = nil) -> Any {
//        if let edit = editedValues() {
//            return Blog(blogId: blogId, owner: owner, title: edit.title, content: content, desc: edit.desc, location: edit.location)
//        }
//        return Blog(blogId: blogId, owner: owner, title: title, content: content, desc: desc, location: location)
//    }
//
//    func editedValues() -> (title: String?, desc: String?, location: String?, images: [UIImage]?)? {
//        do {
//            let titleString                 = try _title.value()
//            let descString                  = try _desc.value()
//            let location                    = try _location.value()
//
//            return (titleString, descString, location, nil)
//        } catch let error {
//            print("Fetal error: \(error)")
//            return nil
//        }
//    }
    
    
//    // TODO: This method will be deleted once the api integrated
//    init(blogId: String, owner: Owner, content: [String]?, title: String?, description: String?, location: String?, createdDate: SwivelDate?, updatedDate: SwivelDate?, totalLikes: Int, isLiked: Bool, totalComments: Int, totalShares: Int) {
//        self.blogId                     = blogId
//        self.owner                      = owner
//        self.content                    = content
//        self.title                      = title
//        self.desc                       = description
//        self.location                   = location
//        self.createdDate                = createdDate
//        self.updatedDate                = updatedDate
//        self.totalLikes                 = totalLikes
//        self.isLiked                    = isLiked
//        self.totalComments              = totalComments
//        self.totalShares                = totalShares
//        _title                          = BehaviorSubject<String>(value: title ?? "")
//        _desc                           = BehaviorSubject<String>(value: desc ?? "")
//        _location                       = BehaviorSubject<String>(value: location ?? "")
//        super.init(id: self.blogId!)
//    }

}
