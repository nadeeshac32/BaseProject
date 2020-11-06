//
//  BlogAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/28/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Alamofire

protocol BlogAPIProtocol {
    func getBlogFeed(method: HTTPMethod!,
                        page: Int, limit: Int,
                        onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?,
                        onError: ErrorCallback?)
    
    func createBlog(method: HTTPMethod!,
                    blog: Blog!,
                    onSuccess: SuccessEmptyDataCallback?,
                    onError: ErrorCallback?)
    
    func updateBlog(method: HTTPMethod!,
                    blog: Blog!,
                    onSuccess: SuccessEmptyDataCallback?,
                    onError: ErrorCallback?)
    
    func likeBlog(blogId: String!,
                  isLike: Bool,
                  onSuccess: SuccessEmptyDataCallback?,
                  onError: ErrorCallback?)
    
    func getBlogsByUser(method: HTTPMethod!,
                        user: User,
                        page: Int, limit: Int,
                        onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?,
                        onError: ErrorCallback?)
}
