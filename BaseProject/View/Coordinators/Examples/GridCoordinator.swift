//
//  GridCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class GridCoordinator: BaseTabItemCoordinator {
    
    // MARK: - Outputs
    override func initialiseVC() {
        if let homeVC = rootVC as? MenuTabBarWithGridsVC, let homeVM = homeVC.viewModel {
            disposeBag.insert([
                homeVM.showSignInVC.bind(to: showSignInVC),
//                homeVM.showExampleVC.subscribe(onNext: { [unowned self] (_) in
//                    self.goToExampleVC()
//                })
            ])
        }
    }
    
    deinit {
        print("deinit GridCoordinator")
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
