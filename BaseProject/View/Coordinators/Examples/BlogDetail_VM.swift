//
//  BlogDetail_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class BlogDetailVM: BaseVM, AdvancedBaseListVMDataSource { //BaseFormVM, AdvancedBaseListVMDataSource {

    var blog                                            : Blog
    var contentTableViewModel                           : BlogDetailTVVM?
    
    // MARK: - Inputs
    // MARK: - Outputs
    
    deinit {
        print("deinit BlogDetailVM")
    }
    
    init(blog: Blog) {
        self.blog                                       = blog
        super.init()
        contentTableViewModel                           = BlogDetailTVVM(dataSource: self, blog: blog)
        childViewModels.append(contentTableViewModel!)
    }    
    
    // MARK: - Network request
    
}
