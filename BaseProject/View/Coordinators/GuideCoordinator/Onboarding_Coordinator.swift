//
//  Onboarding_Coordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class OnboardingCoordinator: BaseCoordinator<Void> {

    var navigationController        : UINavigationController!
    var endOnboarding               = PublishSubject<Void>()
    deinit {
        print("deinit OnboardingCoordinator")
    }
    
    override func start() -> Observable<Void> {
        self.reStartApplication()
        return Observable.merge(endOnboarding.asObservable()).take(1).do(onNext: {
            let defaults            = UserDefaults.standard
            defaults.set(true, forKey: Defaults.userGuideShown.rawValue)
        })
    }
    
    func reStartApplication() {
        let viewModel               = LanguageSelectionVM()
        let viewController          = LanguageSelectionVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        viewController.viewModel    = viewModel
        viewModel.showOnboardingScreens.subscribe(onNext: { (_) in self.gotoOnboarding() }).disposed(by: disposeBag)
        
        navigationController        = UINavigationController(rootViewController: viewController)
        window.rootViewController   = navigationController
        window.makeKeyAndVisible()
    }
    
    func gotoOnboarding() {
        let viewModel               = OnboardingVM()
        let viewController          = OnboardingVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        viewController.viewModel    = viewModel
        viewModel.didEndOnboarding.bind(to: endOnboarding).disposed(by: disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
