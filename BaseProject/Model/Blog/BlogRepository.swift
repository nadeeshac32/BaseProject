//
//  BlogRepository.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import RxSwift
import ObjectMapper

class BlogRepository {
    static func fetchPosts() -> [Blog] {
        var posts = [Blog]()
        
        let post1   = getPost(ownerName: "Liam Neeson",
                              ownerImageName: "https://www.thetimes.co.uk/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F10ee0574-2919-11e9-a92b-e57f23e07fe4.jpg?crop=2994%2C1996%2C0%2C0",
                              blogId: "P0001",
                              displayTime: "1 hr ago",
                              title: "I will find you and I will kill you. Be prepared when I come for you",
                              desc: "Death does not wait for you to be ready! Death is not considerate, or fair! And make no mistake—here, you face death. #Liam_Neeson_Quotes",
                              contentImages: [
                                "https://lincolnmartin.com/wp-content/uploads/2015/03/Blog-Lincoln-Martin-Strategic-Marketing-Harvard-Business-School-TAKEN-pricing-value-price-strategy-promotion-advertising-agency-branding-communications-marcomm.jpg",
                                "https://img.cinemablend.com/filter:scale/quill/b/a/a/d/8/1/baad812ca258ac42bdf65bb994d5bc5920aaf04e.jpg?fw=1200",
                                "https://www.irishtimes.com/polopoly_fs/1.1727586.1395008055!/image/image.jpg_gen/derivatives/box_620_330/image.jpg",
                                "https://fw-project.s3.ap-southeast-1.amazonaws.com/fid-2583de6a-378f-4b04-aa33-84ba92394b95.null"
                                ],
                              likes: 3400,
                              isLiked: true,
                              comments: 230,
                              Shares: 189)
        
        let post2   = getPost(ownerName: "Will Smith",
                              ownerImageName: "https://www.biography.com/.image/t_share/MTE4MDAzNDEwNzQzMTY2NDc4/will-smith-9542165-1-402.jpg",
                              blogId: "P0002",
                              displayTime: "3 hrs ago",
                              title: "Life is lived on the Edge",
                              desc: "Fear is not real. It's a product of thoughts you create. Danger is very real. But fear is a choice",
                              contentImages: [
                                "https://thoughtcatalog.com/wp-content/uploads/2018/05/will-smith.jpg",
                                "https://www.azquotes.com/vangogh-image-quotes/62/65/Quotation-Will-Smith-Fear-is-not-real-It-is-a-product-of-thoughts-62-65-84.jpg"
                                ],
                              likes: 53400,
                              isLiked: false,
                              comments: 2330,
                              Shares: 3094)
        
        let post3   = getPost(ownerName: "Morgan Freeman",
                              ownerImageName: "https://lh3.googleusercontent.com/proxy/Z8L_N5NOLRK4ezrPCr7rEuVVeDIB0bSQx13thQVr4gjYwbioWBH7BLfkh0u8CD-6RihhldgKKoVB2RtXEJlK9EJAR-eKbVOU8qQYoDkWCvVxNWMBKyozYQttP5M",
                              blogId: "P0003",
                              displayTime: "12 hrs ago",
                              title: "",
                              desc: "One of the things you can always depend on – this is one of the truths of the universe, and you heard it first from here – whatever we decide we want to do is what we do.",
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
    
    static func getPost(ownerName: String, ownerImageName: String, blogId: String, displayTime: String, title: String, desc: String, contentImages: [String]?, likes: Int, isLiked: Bool, comments: Int, Shares: Int) -> Blog {
        let owner = Owner(id: "", name: ownerName, imageUrl: ownerImageName)
        let createdDate = NCDate(displayText: displayTime)
        let updatedDate = NCDate(displayText: displayTime)
        let post = Blog(blogId: blogId, owner: owner, content: contentImages, title: title, description: desc, location: nil, createdDate: createdDate, updatedDate: updatedDate, totalLikes: likes, isLiked: isLiked, totalComments: comments, totalShares: Shares)
        return post
    }
    
}
