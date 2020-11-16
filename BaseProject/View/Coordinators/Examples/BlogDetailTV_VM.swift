//
//  BlogDetailTV_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper


/// If you initialise a instance of this class in side another BaseVM instance you should add newly created instance to the parent BaseVM's childViewModels array.
class BlogDetailTVVM: AdvancedBaseListVM<BlogDetailTVCellType, BlogDetailTableViewSection> {
    
    var commentIndexPath            : IndexPath?
    var replyingToParentCommentId   : String?
    var edittingCommentId           : String?
    
    // MARK:- Input
    var comment                     = BehaviorSubject<String>(value: "")
    var typeCmmentForBlog           = PublishSubject<Bool>()
    var endCommenting               = PublishSubject<Bool>()
    var typeReplyCommentFor         = PublishSubject<(commentId: String, commentOwner: String, commentIndexPath: IndexPath)>()
    
    var editCommentFor              = PublishSubject<(isChildComment: Bool,
                                                        commentId: String,
                                                        commentIndexPath: IndexPath,
                                                        comment: String,
                                                        parentCommentIndexPath: IndexPath?,
                                                        parentCommentOwner: String?)>()
    
    // MARK:- Output
    var showShareBlogOptions        = PublishSubject<[Any]>()
    var displayContent              = PublishSubject<String>()
    var newCommentWithPlaceholder   : Observable<String>!
    var endCommentWithPlaceholder   : Observable<String>!
    var editCommentWithPlaceholder  : Observable<(comment: String, placeholder: String)>!
    var isEnable                    : Observable<Bool>!
    
    
    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var limit              : Int { get { return 10 } set {} }
    
    var blog                        : Blog
    
    init(dataSource: AdvancedBaseListVMDataSource?, blog: Blog) {
        self.blog                   = blog
        super.init(dataSource: dataSource)
        
        newCommentWithPlaceholder   = Observable.merge([
            typeCmmentForBlog.asObservable().map({ [weak self] _ in
                self?.commentIndexPath          = nil
                self?.replyingToParentCommentId = nil
                self?.edittingCommentId         = nil
                return "Type Comment"
            }),
            typeReplyCommentFor.asObservable().map({ [weak self] commentId, commentOwner, commentIndexPath in
                self?.replyingToParentCommentId = commentId
                self?.commentIndexPath          = commentIndexPath
                self?.edittingCommentId         = nil
                return "Reply to \(commentOwner)"
            })
        ])
        
        editCommentWithPlaceholder  = editCommentFor.asObservable().map({ [weak self] (commentDetails) in
            self?.replyingToParentCommentId     = nil
            self?.commentIndexPath              = commentDetails.isChildComment == true ? commentDetails.parentCommentIndexPath : commentDetails.commentIndexPath
            self?.edittingCommentId             = commentDetails.commentId
            return (comment: commentDetails.comment, placeholder: commentDetails.isChildComment == true ? "Reply to \(commentDetails.parentCommentOwner ?? "")" : "Type Comment")
        })
        
        endCommentWithPlaceholder               = endCommenting.asObservable().map({ [weak self] _ in
            self?.commentIndexPath              = nil
            self?.replyingToParentCommentId     = nil
            self?.edittingCommentId             = nil
            return "Type Comment"
        })
        
        isEnable                                = comment.asObservable().map({ text in
            return (text != "")
        })
        
    }
    
    deinit { print("deinit BlogDetailTVVM") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStaticItems(items: [blog])
        requestLoading.onNext(false)
    }

    override func performGetItemsRequest(loadPage: Int, limit: Int) {
        let httpService                             = HTTPService()
        showSpiner()
        httpService.getBlogComments(blogId: blog.id, page: loadPage, limit: limit, onSuccess: { [weak self] (comments, total, page, limit, size) in
            self?.requestLoading.onNext(false)
            self?.handleResponse(items: comments, total: total, page: page, size: size)
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }
    
    func shareBtnTapped(blog: Blog) {
        var sharebles                   = [Any]()
        if let title                    = blog.title { sharebles.append(title) }
        if let desc                     = blog.desc { sharebles.append(desc) }
        if let content                  = blog.content { sharebles.append(content.map { $0 }) }
        showShareBlogOptions.onNext(sharebles)
    }
    
    func viewContent(url: String) {
        displayContent.onNext(url)
    }
    
    func setForNormalComment() {
        self.commentIndexPath           = nil
        self.replyingToParentCommentId  = nil
        self.edittingCommentId          = nil
    }
    
    // MARK:- Network request
    func performCommentRequest() {
        let comment                     : String
        do {
            guard try !freezeForRequestLoading.value() else { return }
            comment                     = try self.comment.value()
        } catch { print("error: \(error)"); return; }
        
        let httpService                 = HTTPService()
        freezeForRequestLoading.onNext(true)
        if let edittingCommentId        = self.edittingCommentId {
            httpService.editComment(commentId: edittingCommentId, comment: comment, onSuccess: { [weak self] in
                self?.freezeForRequestLoading.onNext(false)
                self?.endCommenting.onNext(true)
                self?.reloadList()
            }) { [weak self] (error) in
                self?.endCommenting.onNext(true)
                self?.handleRestClientError(error: error)
            }
        } else if let blogId            = self.blog.blogId {
            httpService.createComment(blogId: blogId, comment: comment, parentCommentId: replyingToParentCommentId, onSuccess: { [weak self] in
                self?.freezeForRequestLoading.onNext(false)
                self?.endCommenting.onNext(true)
                self?.reloadList()
            }) { [weak self] (error) in
                self?.endCommenting.onNext(true)
                self?.handleRestClientError(error: error)
            }
        }
    }
    
    
    func deleteChildComment(commentId: String, indexPath: IndexPath) {
        do { guard try !freezeForRequestLoading.value() else { return } } catch { return }
        let httpService                 = HTTPService()
        freezeForRequestLoading.onNext(true)
        httpService.deleteCommentWithId(commentId: commentId, onSuccess: { [weak self] in
            self?.freezeForRequestLoading.onNext(false)
            self?.reloadList()
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }

}
