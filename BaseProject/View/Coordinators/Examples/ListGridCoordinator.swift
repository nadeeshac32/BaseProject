//
//  ListGridCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ListGridCoordinator: BaseTabItemCoordinator {
    
    // MARK: - Outputs
    override func initialiseVC() {
        if let homeVC = rootVC as? ManuTabBarWithListsGridsVC, let homeVM = homeVC.viewModel {
            disposeBag.insert([
                homeVM.showSignInVC.bind(to: showSignInVC)            ])
        }
    }
    
    deinit {
        print("deinit ListCoordinator")
    }
}
