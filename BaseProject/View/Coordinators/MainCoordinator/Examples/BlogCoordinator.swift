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
//                homeVM.showExampleVC.subscribe(onNext: { [unowned self] (_) in
//                    self.goToExampleVC()
//                })
            ])
        }
    }
    
    deinit {
        print("deinit BlogCoordinator")
    }
    
    func goToExampleVC() {
//        let exampleVM                   = exampleVM()
//        // VM bindings
//        disposeBag.insert([
//            // MARK: Outputs
//            exampleVM.showSignInVC.bind(to: showSignInVC),
//            // MARK: Inputs
//        ])
//        let exampleVC                 = ExampleVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: exampleVM)
//        superNC?.pushViewController(exampleVC, animated: true)
    }
}
