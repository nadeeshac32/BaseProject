//
//  Root_MV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class BottomTabBarVM: BaseVM {
    
    let gotoSignin: PublishSubject<Bool> = PublishSubject()
    
    deinit {
        print("deinit BottomTabBarVM")
    }
}
