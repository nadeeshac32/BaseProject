//
//  AppCoordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let defaults                = UserDefaults.standard
    
    deinit {
        print("deinit AppCoordinator")
    }
    
    override func start() -> Observable<Void> {
        // Initialise user details as soon as App starts
        UserAuth.si.initialise()
        
        let userGuideShown              = defaults.bool(forKey: Defaults.userGuideShown.rawValue)
        if !userGuideShown {
            // This code execute only once
            let onboardingCoordinator   = OnboardingCoordinator(window: window)
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "settings.language.changed"), object: nil, queue: nil) { (_) in
                onboardingCoordinator.reStartApplication()
            }
            return coordinate(to: onboardingCoordinator).take(1).do(onNext: {
                let _ = self.start()
            })
        } else {
            let mainCoordinator         = MainCoordinator(window: window)
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "settings.language.changed"), object: nil, queue: nil) { (_) in
                mainCoordinator.reStartApplication()
            }
            return coordinate(to: mainCoordinator)
        }
    }
    
}
