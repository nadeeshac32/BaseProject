//
//  Signup_Coordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class SignupCoordinator: BaseTabItemCoordinator {

    let showRootVC                  : PublishSubject<Bool> = PublishSubject()
    
    deinit {
        print("deinit SignupCoordinator")
    }
    
    // Never use this abstract method
    override func start() -> Observable<Void> {
        return PublishSubject().asObservable()
    }
    
    func goToSignupVC() {
        if let signupVC = rootVC as? SignupVC, let signupVM = signupVC.viewModel {
            
            signupVM.showOTPVerificationVC.asObservable().subscribe(onNext: { (userPostData) in
                self.goToOTPVerificationVC(userPostData: userPostData)
            }).disposed(by: disposeBag)
            
            superNC?.pushViewController(signupVC, animated: true)
        }
    }
    
    func goToOTPVerificationVC(userPostData: UserPostData) {
        let otpVerificationVM       = OTPVerificationVM(showRootVC: showRootVC, userPostData: userPostData)
        let otpVerificationVC       = OTPVerificationVC.initFromStoryboard(name: Storyboards.signup.rawValue, withViewModel: otpVerificationVM)
        superNC?.pushViewController(otpVerificationVC, animated: true)
    }
}

