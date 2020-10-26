//
//  BlogRepository.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import RxSwift
import ObjectMapper

class BlogRepository {
    static func fetchPosts() -> [Blog] {
        var posts = [Blog]()
        
        let post1   = getPost(ownerName: "Liam Neeson", ownerImageName: "image_liam_neeson", blogId: "P0001", displayTime: "1 hr ago", title: "Death does not wait for you to be ready! Death is not considerate, or fair! And make no mistake—here, you face death.", contentImages: ["image_liam_neeson_post1"], likes: 3400, comments: 230, Shares: 189)
        
        let post2   = getPost(ownerName: "Will Smith", ownerImageName: "image_will_smith", blogId: "P0002", displayTime: "3 hrs ago", title: "Fear is not real. It's a product of thoughts you create. Danger is very real. But fear is a choice", contentImages: ["image_will_smith_post1"], likes: 53400, comments: 2330, Shares: 3094)
        
        let post3   = getPost(ownerName: "Morgan Freeman", ownerImageName: "image_morgan_freeman", blogId: "P0003", displayTime: "12 hrs ago", title: "One of the things you can always depend on – this is one of the truths of the universe, and you heard it first from here – whatever we decide we want to do is what we do.", contentImages: ["image_morgan_freeman_post1"], likes: 83400, comments: 9330, Shares: 12094)
        
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        
        return posts
    }
    
    static func getPost(ownerName: String, ownerImageName: String, blogId: String, displayTime: String, title: String, contentImages: [String]?, likes: Int, comments: Int, Shares: Int) -> Blog {
        let owner = Owner(id: "", name: ownerName, imageUrl: ownerImageName)
        let createdDate = SwivelDate(displayText: displayTime)
        let updatedDate = SwivelDate(displayText: displayTime)
        let post = Blog(blogId: blogId, owner: owner, content: contentImages, title: title, description: nil, location: nil, createdDate: createdDate, updatedDate: updatedDate, totalLikes: likes, totalComments: comments, totalShares: Shares)
        return post
    }
    
}
