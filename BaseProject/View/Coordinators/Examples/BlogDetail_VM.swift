//
//  BlogDetail_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class BlogDetailVM: BaseFormVM { //}, BaseCollectionVMDataSource {

    var blog                                            : Blog
//    var contentGridViewModel                            : BlogCreateContentGridVM?
    
    // MARK: - Inputs
    // MARK: - Outputs
    
    deinit {
        print("deinit BlogCreateEditVM")
    }
    
    init(blog: Blog, blogCreateEditMode: BlogCreateEditMode = .create) {
        self.blog                                       = blog
        super.init()
//        contentGridViewModel                            = BlogCreateContentGridVM(dataSource: self)
//        childViewModels.append(contentGridViewModel!)
//        let contentArray = blog.content?.map({ BlogContent(editable: false, mediaUrl: $0, image: nil) }) ?? []
//        contentGridViewModel?.contentAdd(items: contentArray)
    }
    
    
    // MARK: - Network request
    override func performSubmitRequest() {
    }
    
}
