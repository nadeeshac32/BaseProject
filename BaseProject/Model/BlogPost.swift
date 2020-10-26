//
//  BlogPost.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import RxSwift
import ObjectMapper

struct BlogUser {
    var username: String?
    var profileImage: UIImage?
}

class BlogPost : BaseModel {
    var createdBy                       : BlogUser?
    var postId                          : String?
    var timeAgo                         : String?
    var caption                         : String?
    var image                           : UIImage?
    var numberOfLikes                   : Int?
    var numberOfComments                : Int?
    var numberOfShares                  : Int?
    var _identity                       : Identity?
    
    override var identity               : Identity {
        get {
            return _identity != nil ? _identity! : id
        }
        set {}
    }
    
    required init?(map: Map) { super.init(map: map) }
    
    init(createdBy: BlogUser, postId: String, timeAgo: String, caption: String, image: UIImage, numberOfLikes: Int, numberOfComments: Int, numberOfShares: Int) {
        super.init()
        self.createdBy                  = createdBy
        self.postId                     = postId
        self.timeAgo                    = timeAgo
        self.caption                    = caption
        self.image                      = image
        self.numberOfLikes              = numberOfLikes
        self.numberOfComments           = numberOfComments
        self.numberOfShares             = numberOfShares
        self._identity                  = postId
    }

    static func fetchPosts() -> [BlogPost] {
        var posts                       = [BlogPost]()
        let user1                       = BlogUser(username: "Liam Neeson", profileImage: UIImage(named: "image_liam_neeson"))
        let post1                       = BlogPost(createdBy: user1, postId: "P0001", timeAgo: "1 hr ago", caption: "Death does not wait for you to be ready! Death is not considerate, or fair! And make no mistake—here, you face death.", image: UIImage(named: "image_liam_neeson_post1")!, numberOfLikes: 3400, numberOfComments: 230, numberOfShares: 189)
        
        let user2                       = BlogUser(username: "Will Smith", profileImage: UIImage(named: "image_will_smith"))
        let post2                       = BlogPost(createdBy: user2, postId: "P0002", timeAgo: "3 hrs ago", caption: "Fear is not real. It's a product of thoughts you create. Danger is very real. But fear is a choice", image: UIImage(named: "image_will_smith_post1")!, numberOfLikes: 53400, numberOfComments: 2330, numberOfShares: 3094)
        
        let user3                       = BlogUser(username: "Morgan Freeman", profileImage: UIImage(named: "image_morgan_freeman"))
        let post3                       = BlogPost(createdBy: user3, postId: "P0003", timeAgo: "12 hrs ago", caption: "One of the things you can always depend on – this is one of the truths of the universe, and you heard it first from here – whatever we decide we want to do is what we do.", image: UIImage(named: "image_morgan_freeman_post1")!, numberOfLikes: 83400, numberOfComments: 9330, numberOfShares: 12094)
        
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        return posts
    }
    
}
