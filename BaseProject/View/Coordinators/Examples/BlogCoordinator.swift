//
//  BlogCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BlogCoordinator: BaseTabItemCoordinator {
    
    // MARK: - Outputs
    override func initialiseVC() {
        if let feedVC = rootVC as? BlogFeedVC, let feedVM = feedVC.viewModel {
            disposeBag.insert([
                feedVM.showSignInVC.bind(to: showSignInVC),
                feedVM.showBlogCreateEditVC.subscribe(onNext: { [unowned self] (_) in
                    self.goToBlogCreateEditVC(previousTitle: feedVM.blogFeedType == .home ? "Home" : "My Space")
                }),
                feedVM.doWithSelectedItem.subscribe(onNext: { [unowned self](blog) in
                    self.goToBlogDetailVC(blog: blog, previousTitle: feedVM.blogFeedType == .home ? "Home" : "My Space")
                })
            ])
        }
    }
    
    deinit {
        print("deinit BlogCoordinator")
    }
    
    func goToBlogCreateEditVC(blog: Blog? = nil, previousTitle: String) {
        let blogCreatEditVM     = BlogCreateEditVM(blog: blog ?? Blog(), blogCreateEditMode: blog == nil ? .create : .edit)
        disposeBag.insert([
            blogCreatEditVM.showSignInVC.bind(to: showSignInVC),
        ])
        let blogCreateEditVC    = BlogCreateEditVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogCreatEditVM)
        blogCreateEditVC.previousVCTitle = previousTitle
        superNC?.pushViewController(blogCreateEditVC, animated: true)
    }
    
    func goToBlogDetailVC(blog: Blog, previousTitle: String) {
        let blogDetailVM        = BlogDetailVM(blog: blog)
        disposeBag.insert([
            blogDetailVM.showBlogCreateEditVC.subscribe(onNext: { [weak self] (blog) in
                self?.goToBlogCreateEditVC(blog: blog, previousTitle: "Back")
            }),
            blogDetailVM.showSignInVC.bind(to: showSignInVC),
            
        ])
        let blogDetailVC        = BlogDetailVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogDetailVM)
        superNC?.pushViewController(blogDetailVC, animated: true)
    }
}
