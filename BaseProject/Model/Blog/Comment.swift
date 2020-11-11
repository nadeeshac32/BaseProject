//
//  Comment.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class Comment: BaseModel {
    var parent                          : BlogChildComment?
    var children                        : [BlogChildComment] = []
    var isExpanded                      : Bool = false
    var _children                       : BehaviorSubject<[BlogChildComment]> = BehaviorSubject<[BlogChildComment]>(value: [])
    
    override init() {
        self.parent                     = nil
        self.children                   = []
        self._children                  = BehaviorSubject<[BlogChildComment]>(value: self.children)
        super.init()
    }
    
    init(parent: BlogChildComment?, children: [BlogChildComment]) {
        self.parent                     = parent
        self.children                   = children
        super.init(id: parent?.id ?? "")
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    

    override func mapping(map: Map) {
        super.mapping(map: map)
        parent                          <- map["parent"]
        children                        <- map["children"]
        self.id                         = self.parent?.id ?? ""
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
