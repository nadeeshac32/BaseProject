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

class BlogFeedVM: BaseTableViewVM<Blog> {
    
    // MARK: - Inputs
    let addBlogHasTapped            : AnyObserver<Void>
    let shareBlogHasTapped          : PublishSubject<Blog> = PublishSubject()
    
    // MARK: - Outputs
    let showBlogCreateEditVC        : Observable<Void>
    var showShareBlogOptions        : Observable<[Any]>
    
    // TODO: - dataLoadIn will be ViewDidLoad once the push notifications are enabled
//    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    
    deinit {
        print("deinit BlogFeedVM")
    }
    
    override init() {
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
        fetchFeed()
        super.viewDidLoad()
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
        httpService.getBlogSummary(page: loadPage, limit: limit, onSuccess: { [weak self] (blogs, total, page, limit) in
            self?.requestLoading.onNext(false)
            self?.handleResponse(items: blogs, total: total, page: page)
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }
    
    
}
