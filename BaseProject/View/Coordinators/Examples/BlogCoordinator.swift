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
                })
            ])
        }
    }
    
    deinit {
        print("deinit BlogCoordinator")
    }
    
    func goToBlogCreateEditVC() {
        let blogCreatEditVM                   = BlogCreateEditVM(blog: Blog())
        // VM bindings
        disposeBag.insert([
            // MARK: Outputs
            blogCreatEditVM.showSignInVC.bind(to: showSignInVC),
            // MARK: Inputs
        ])
        let blogCreateEditVC                 = BlogCreateEditVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogCreatEditVM)
        superNC?.pushViewController(blogCreateEditVC, animated: true)
    }
}
