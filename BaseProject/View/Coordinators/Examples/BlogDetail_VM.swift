//
//  BlogDetail_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class BlogDetailVM: BaseVM, AdvancedBaseListVMDataSource {

    var blog                                            : Blog
    var contentTableViewModel                           : BlogDetailTVVM?
    
    // MARK: - Inputs
    var editBlogTapped                                  = PublishSubject<Bool>()
    
    // MARK:- Output
    let showBlogCreateEditVC                            : Observable<Blog>
    
    deinit {
        print("deinit BlogDetailVM")
    }
    
    init(blog: Blog) {
        self.blog                                       = blog
        showBlogCreateEditVC                            = editBlogTapped.map({ (_) in return blog })
        super.init()
        
        contentTableViewModel                           = BlogDetailTVVM(dataSource: self, blog: blog)
        childViewModels.append(contentTableViewModel!)
    }
    
    
    func deleteBtnTapped() {
        let alert = (title: "Delete Blog", message: "Are you sure you want to delete?",
                     primaryBtnTitle: "Yes", primaryActionColor: AppConfig.si.colorPrimary, primaryAction: { [weak self] in
            if let blogId = self?.blog.blogId {
               do {
                    guard try self?.freezeForRequestLoading.value() == false else { return }
                    self?.freezeForRequestLoading.onNext(true)
               } catch let error { print("Fetal error: \(error)") }
               let httpService = HTTPService()
               httpService.deleteBlogWithId(blogId: blogId, onSuccess: { [weak self] in
                   self?.freezeForRequestLoading.onNext(false)
                let tupple = (message: "Successfully delete.", blockScreen: true, completionHandler: { [weak self] in
                       self?.goToPreviousVC.onNext(true)
                   })
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "existing.blog.deleted"), object: nil, userInfo: nil)
                   self?.successMessage.onNext(tupple)
               }) { [weak self] (error) in
                   self?.handleRestClientError(error: error)
               }
           }
           return
        },
                     secondaryBtnTitle: "No", secondaryActionColor: nil, secondaryAction: nil) as alertType
        showAlert.on(.next(alert))
    }
    
    // MARK: - Network request
    
}
