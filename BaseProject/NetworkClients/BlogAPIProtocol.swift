//
//  BlogAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/28/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
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
    
    func getBlogComments(method: HTTPMethod!,
                         blogId: String,
                         page: Int, limit: Int,
                         onSuccess: ((_ comments: [Comment], _ total: Int, _ page: Int, _ limit: Int, _ size: Int) -> Void)?,
                         onError: ErrorCallback?)
    
    func deleteBlogWithId(method: HTTPMethod!,
                                 blogId: String,
                                 onSuccess: SuccessEmptyDataCallback?,
                                 onError: ErrorCallback?)
    
    func createComment(method: HTTPMethod!,
                       blogId: String!,
                       comment: String!,
                       parentCommentId: String?,
                       onSuccess: SuccessEmptyDataCallback?,
                       onError: ErrorCallback?)
    
    func editComment(method: HTTPMethod!,
                     commentId: String!,
                     comment: String!,
                     onSuccess: SuccessEmptyDataCallback?,
                     onError: ErrorCallback?)
    
    func deleteCommentWithId(method: HTTPMethod!,
                             commentId: String,
                             onSuccess: SuccessEmptyDataCallback?,
                             onError: ErrorCallback?)
    
}

extension HTTPService: BlogAPIProtocol {
    func getBlogFeed(method: HTTPMethod! = .get, page: Int, limit: Int, onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/summary/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            onSuccess?(arrayResponse.items ?? [], arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit)
            return
        })
    }
    
    func createBlog(method: HTTPMethod! = .post, blog: Blog!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog"
        let parameters                  = blog.toJSON()
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func updateBlog(method: HTTPMethod! = .put, blog: Blog!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog"
        let parameters                  = blog.toJSON()
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func likeBlog(blogId: String!, isLike: Bool, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/like/\(blogId!)"
        let method                      = isLike == true ? HTTPMethod.post : HTTPMethod.delete
        
        genericRequest(method: method, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func getBlogsByUser(method: HTTPMethod! = .get, user: User, page: Int, limit: Int, onSuccess: ((_ blogs: [Blog], _ total: Int, _ page: Int, _ limit: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/user/summary/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            let owner                   = Owner(id: user.id, name: user.fullName ?? "", imageUrl: user.imageUrl)
            let updatedBlogs            = (arrayResponse.items ?? []).map { (blog) -> Blog in
                blog.owner              = owner
                return blog
            }
            onSuccess?(updatedBlogs, arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit)
            return
        })
    }
    
    func getBlogComments(method: HTTPMethod! = .get, blogId: String, page: Int, limit: Int, onSuccess: ((_ comments: [Comment], _ total: Int, _ page: Int, _ limit: Int, _ size: Int) -> Void)?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/comment/\(blogId)/\(page)/\(limit)"
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Comment.self, onError: onError, completionHandlerForArray: { (arrayResponse) in
            onSuccess?(arrayResponse.items ?? [], arrayResponse.total ?? 0, arrayResponse.page ?? 0, limit, arrayResponse.size ?? 0)
            return
        })
    }
    
    func deleteBlogWithId(method: HTTPMethod! = .delete, blogId: String, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/\(blogId)"
        genericRequest(method: method, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func createComment(method: HTTPMethod! = .post, blogId: String!, comment: String!, parentCommentId: String?, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/comment"
        var parameters                  : [String : AnyObject] = [
            "blogId"                    : "\(blogId!)" as AnyObject,
            "comment"                   : "\(comment!)" as AnyObject
        ]
        
        if let parentCommentId = parentCommentId {
            parameters["parentCommentId"] = parentCommentId as AnyObject
        }
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func editComment(method: HTTPMethod! = .put, commentId: String!, comment: String!, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/comment"
        let parameters                  : [String : AnyObject] = [
            "commentId"                 : "\(commentId!)" as AnyObject,
            "comment"                   : "\(comment!)" as AnyObject
        ]
        
        genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
    
    func deleteCommentWithId(method: HTTPMethod! = .delete, commentId: String, onSuccess: SuccessEmptyDataCallback?, onError: ErrorCallback?) {
        let contextPath                 = "\(urls.blogPath)/blog/comment/\(commentId)"
        genericRequest(method: method, parameters: nil, contextPath: contextPath, responseType: Blog.self, onError: onError, completionHandlerForNull: {
            onSuccess?()
            return
        })
    }
}
