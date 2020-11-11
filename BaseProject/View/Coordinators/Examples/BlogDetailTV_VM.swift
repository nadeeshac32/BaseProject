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
    
    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var limit              : Int { get { return 10 } set {} }
    
    var blog                        : Blog
    
    init(dataSource: AdvancedBaseListVMDataSource?, blog: Blog) {
        self.blog                   = blog
        super.init(dataSource: dataSource)
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
    
    
}
