//
//  BlogCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
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
                    self.goToBlogCreateEditVC()
                }),
                feedVM.doWithSelectedItem.subscribe(onNext: { [unowned self](blog) in
                    self.goToBlogDetailVC(blog: blog, previousTitle: "Feed")
                })
            ])
        }
    }
    
    deinit {
        print("deinit BlogCoordinator")
    }
    
    func goToBlogCreateEditVC() {
        let blogCreatEditVM                   = BlogCreateEditVM(blog: Blog())
        disposeBag.insert([
            // MARK: Outputs
            blogCreatEditVM.showSignInVC.bind(to: showSignInVC),
            // MARK: Inputs
        ])
        let blogCreateEditVC                 = BlogCreateEditVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogCreatEditVM)
        superNC?.pushViewController(blogCreateEditVC, animated: true)
    }
    
    func goToBlogDetailVC(blog: Blog, previousTitle: String) {
        print("goToBlogDetailVC")
    }
}
