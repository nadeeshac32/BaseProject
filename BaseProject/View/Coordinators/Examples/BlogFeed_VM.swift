//
//  BlogFeed_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

enum BlogFeedType {
    case home, mySpace
}


class BlogFeedVM: BaseTableViewVM<Blog> {
    
    let blogFeedType                : BlogFeedType
    
    // MARK: - Inputs
    let addBlogHasTapped            : AnyObserver<Void>
    let shareBlogHasTapped          : PublishSubject<Blog> = PublishSubject()
    
    // MARK: - Outputs
    let showBlogCreateEditVC        : Observable<Void>
    var showShareBlogOptions        : Observable<[Any]>
    
    override var dataLoadIn         : DataLoadIn? { get { return blogFeedType == .mySpace ? .ViewWillAppear : .ViewDidLoad } set {} }
    override var loadFromAPI        : Bool { get { return blogFeedType == .mySpace ? true : false } set {} }
    override var loadAsDynemic      : Bool { get { return blogFeedType == .mySpace ? true : false } set {} }
    
    deinit {
        print("deinit BlogFeedVM :\(blogFeedType)")
    }
    
    init(blogFeedType: BlogFeedType) {
        self.blogFeedType           = blogFeedType
        
        let _addBlogHasTapped       = PublishSubject<Void>()
        self.addBlogHasTapped       = _addBlogHasTapped.asObserver()
        self.showBlogCreateEditVC   = _addBlogHasTapped.asObservable()
        
        self.showShareBlogOptions   = shareBlogHasTapped.asObserver().map({ (blog) -> [Any] in
            var sharebles           = [Any]()
            if let title            = blog.title { sharebles.append(title) }
            if let desc             = blog.desc { sharebles.append(desc) }
            if let content          = blog.content { sharebles.append(content.map { $0 }) }
            return sharebles
        })
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if blogFeedType == .home {
            fetchFeed()
        }
    }
    
    // Class Methods
    func fetchFeed() {
        let posts = BlogRepository.fetchPosts()
        self.addNewItems(items: posts)
        requestLoading.onNext(false)
    }
    
    // MARK: - Network request
    override func perfomrGetItemsRequest(loadPage: Int, limit: Int) {
        let httpService                             = HTTPService()
        showSpiner()
        if blogFeedType == .home {
            httpService.getBlogFeed(page: loadPage, limit: limit, onSuccess: { [weak self] (blogs, total, page, limit) in
                self?.requestLoading.onNext(false)
                self?.handleResponse(items: blogs, total: total, page: page)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } else {
            httpService.getBlogsByUser(user: User.si, page: loadPage, limit: limit, onSuccess: { [weak self] (blogs, total, page, limit) in
                self?.requestLoading.onNext(false)
                self?.handleResponse(items: blogs, total: total, page: page)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        }
    }
    
    
}
