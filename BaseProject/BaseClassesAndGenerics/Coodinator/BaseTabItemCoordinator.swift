//
//  BaseTabItemCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseTabItemCoordinator: BaseCoordinator<Void> {
    
    weak var superNC    : UINavigationController?
    weak var rootVC     : BaseSuperVC?
    let showSignInVC    : PublishSubject<Bool>      = PublishSubject()
    
    required init(window: UIWindow, navigationController: UINavigationController?, rootVC: BaseSuperVC?) {
        self.superNC    = navigationController
        self.rootVC     = rootVC
        super.init(window: window)
    }
    
    open func initialiseVC() { }
    
}
