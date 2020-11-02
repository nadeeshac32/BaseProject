//
//  BlogCreateEditGrid_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/30/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

/// If you initialise a instance of this class in side another BaseVM instance you should add newly created instance to the parent BaseVM's childViewModels array.
class BlogCreateEditGridVM: BaseCollectionVM<Blog> {
    
    // TODO: - dataLoadIn will be ViewDidLoad once the push notifications are enabled
//    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    
    deinit {
        print("deinit BlogCreateEditGridVM")
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
