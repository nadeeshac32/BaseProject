//
//  Root_MV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

class BottomTabBarVM: BaseVM {
    
    let gotoSignin: PublishSubject<Bool> = PublishSubject()
    
    deinit {
        print("deinit BottomTabBarVM")
    }
}
