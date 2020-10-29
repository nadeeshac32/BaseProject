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
        
        let post1   = getPost(ownerName: "Liam Neeson",
                              ownerImageName: "image_liam_neeson",
                              blogId: "P0001",
                              displayTime: "1 hr ago",
                              title: "Death does not wait for you to be ready! Death is not considerate, or fair! And make no mistake—here, you face death.",
                              contentImages: [
                                "https://lincolnmartin.com/wp-content/uploads/2015/03/Blog-Lincoln-Martin-Strategic-Marketing-Harvard-Business-School-TAKEN-pricing-value-price-strategy-promotion-advertising-agency-branding-communications-marcomm.jpg",
                                "https://img.cinemablend.com/filter:scale/quill/b/a/a/d/8/1/baad812ca258ac42bdf65bb994d5bc5920aaf04e.jpg?fw=1200",
                                "https://www.irishtimes.com/polopoly_fs/1.1727586.1395008055!/image/image.jpg_gen/derivatives/box_620_330/image.jpg"
                                ],
                              likes: 3400,
                              isLiked: true,
                              comments: 230,
                              Shares: 189)
        
        let post2   = getPost(ownerName: "Will Smith",
                              ownerImageName: "image_will_smith",
                              blogId: "P0002",
                              displayTime: "3 hrs ago",
                              title: "Fear is not real. It's a product of thoughts you create. Danger is very real. But fear is a choice",
                              contentImages: [
                                "https://cdn.aarp.net/content/dam/aarp/entertainment/movies-for-grownups/2020/07/1140-will-smith.jpg",
                                "https://www.azquotes.com/vangogh-image-quotes/62/65/Quotation-Will-Smith-Fear-is-not-real-It-is-a-product-of-thoughts-62-65-84.jpg"
                                ],
                              likes: 53400,
                              isLiked: false,
                              comments: 2330,
                              Shares: 3094)
        
        let post3   = getPost(ownerName: "Morgan Freeman",
                              ownerImageName: "image_morgan_freeman",
                              blogId: "P0003",
                              displayTime: "12 hrs ago",
                              title: "One of the things you can always depend on – this is one of the truths of the universe, and you heard it first from here – whatever we decide we want to do is what we do.",
                              contentImages: [
                                "https://1zl13gzmcsu3l9yq032yyf51-wpengine.netdna-ssl.com/wp-content/uploads/2017/09/morgan-freeman-quote-whatever-we-decide-we-want-to-do-is-what-we-do-1068x561.jpg",
                                "https://www.azquotes.com/vangogh-image-quotes/62/28/Quotation-Morgan-Freeman-Challenge-yourself-it-s-the-only-path-which-leads-to-62-28-27.jpg"
                                ],
                              likes: 83400,
                              isLiked: true,
                              comments: 9330,
                              Shares: 12094)
        
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        
        return posts
    }
    
    static func getPost(ownerName: String, ownerImageName: String, blogId: String, displayTime: String, title: String, contentImages: [String]?, likes: Int, isLiked: Bool, comments: Int, Shares: Int) -> Blog {
        let owner = Owner(id: "", name: ownerName, imageUrl: ownerImageName)
        let createdDate = SwivelDate(displayText: displayTime)
        let updatedDate = SwivelDate(displayText: displayTime)
        let post = Blog(blogId: blogId, owner: owner, content: contentImages, title: title, description: nil, location: nil, createdDate: createdDate, updatedDate: updatedDate, totalLikes: likes, isLiked: isLiked, totalComments: comments, totalShares: Shares)
        return post
    }
    
}
