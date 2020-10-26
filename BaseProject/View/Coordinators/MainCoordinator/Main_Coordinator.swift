//
//  Main_Coordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class MainCoordinator: BaseCoordinator<Void> {

    private let defaults                        = UserDefaults.standard
    var navigationController                    : UINavigationController!
    
    deinit {
        print("deinit MainCoordinator")
    }
    
    override func start() -> Observable<Void> {
        reStartApplication()

        return Observable.never()
    }
    
    func reStartApplication() {
        if UserAuth.si.signedIn && UserAuth.si.token != "" {
            goToRootVC()
        } else {
            goToSigninVC()
        }
    }
    
    private func goToSigninVC() {
        let viewController                      = SigninVC.initFromStoryboard(name: Storyboards.main.rawValue)
        let viewModel                           = SigninVM()
        viewController.viewModel                = viewModel
        navigationController                    = UINavigationController(rootViewController: viewController)
        
        disposeBag.insert([
            viewModel.showHomeVC.subscribe(onNext: { [weak self] (_) in
                self?.goToRootVC()
            }),
            viewModel.showRegisterVC.subscribe(onNext: { [weak self] in
                if let nav = self?.navigationController {
                    self?.goToSignupVC(in: nav)
                }
            }),
            viewModel.showGenerateOTPvCtoResetPassword.subscribe(onNext: { [weak self] (user) in
                if let nav = self?.navigationController {
                    self?.goToOTPGeneraterViaMobile(in: nav, user: user)
                }
            })
        ])
        window.rootViewController               = navigationController
        window.makeKeyAndVisible()
    }
    
    /// This method redirects to signup coordinator. Once the signup process is finished navigation stack pops pack to signin screen so the new use can signin with his/her new credentials
    private func goToSignupVC(in navigationController: UINavigationController) {
        let signupVM                            = SignupVM()
        let signupCoordinator                   = SignupVC.initCoordinatorFromStoryboard(name: Storyboards.signup.rawValue, withViewModel: signupVM, type: SignupCoordinator.self, window: window, nav: navigationController) as? SignupCoordinator
        signupCoordinator?.showRootVC.subscribe(onNext: { [weak self] (_) in
            self?.navigationController.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        signupCoordinator?.goToSignupVC()
    }
    
    /// Reset forget password via mobile. This method will navigate to Mobile number entering screen.
    /// User has to enter his account's mobile number which he/she wants to reset his password for.
    /// Submitting the form will Generate and send a new OTP to his mobile number which he entered. Then the app will navigate to OTP verification screen.
    /// Once the otp is verified, it means the mobile number is real user's, so it will navigate to Reset password screen.
    private func goToOTPGeneraterViaMobile(in navigationController: UINavigationController, user: User) {
        let otpVerificationType                 = OTPVerificationType.ResetPasswordViaMobile
        let updateUserDetailVM                  = UpdateUserMobileVM(user: user, type: otpVerificationType)
        disposeBag.insert([
            updateUserDetailVM.showSignInVC.subscribe(onNext: { (_) in
                navigationController.popToRootViewController(animated: true)
            }),
            
            // Submitting the form will Generate and send a new OTP to his mobile number which he entered.
            // Then the app will navigate to OTP verification screen.
            updateUserDetailVM.showOTPVerificationVC.subscribe(onNext: { [unowned self] (user) in
                self.goToOTPVerificationVC(in: navigationController, user: user, type: otpVerificationType)
            })
        ])
        let updateUserDetailVC                  = UpdateUserMobileVC.initFromStoryboard(name: Storyboards.main.rawValue, withViewModel: updateUserDetailVM)
        navigationController.pushViewController(updateUserDetailVC, animated: true)
    }
    
    /// Navigating to OTP verification screen. Varifying mobile number for forget password
    /// Once the otp is verified, it means the mobile number is real user's, so it will navigate to Reset password screen.
    private func goToOTPVerificationVC(in navigationController: UINavigationController, user: User, type: OTPVerificationType) {
        let otpVerificationVM                   = OTPVerificationVM(user: user, otpVerificationType: type)
        disposeBag.insert([
            otpVerificationVM.showSignInVC.subscribe(onNext: { (_) in
                navigationController.popToRootViewController(animated: true)
            }),
            
            // Navigating to Reset password screen.
            otpVerificationVM.showResetPasswordVC.subscribe(onNext: { (_) in
                self.goToPasswordResetVC(in: navigationController, user: user, type: type)
            })
        ])
        let otpVerificationVC                   = OTPVerificationVC.initFromStoryboard(name: Storyboards.signup.rawValue, withViewModel: otpVerificationVM)
        navigationController.pushViewController(otpVerificationVC, animated: true)
    }
    
    /// Navigating to Password reset screen from Forget password.
    private func goToPasswordResetVC(in navigationController: UINavigationController, user: User, type: OTPVerificationType) {
        let passwordResetVM                     = PasswordResetVM(user: user)
        disposeBag.insert([
            passwordResetVM.showSignInVC.subscribe(onNext: { (_) in
                navigationController.popToRootViewController(animated: true)
            })
        ])
        let passwordResetVC                     = PasswordResetVC.initFromStoryboard(name: Storyboards.main.rawValue, withViewModel: passwordResetVM)
        navigationController.pushViewController(passwordResetVC, animated: true)
    }
    
    private func goToRootVC() {
        let rootTBNController                   = BottomTabBarVC.initFromStoryboardEmbedInNav(name: Storyboards.example.rawValue, window: window)
        let rootVM                              = BottomTabBarVM()
        rootVM.gotoSignin.subscribe(onNext: { [weak self] (_) in
            let _ = self?.start()
        }).disposed(by: disposeBag)
        (rootTBNController.topViewController as? BottomTabBarVC)?.viewModel = rootVM
        self.navigationController               = rootTBNController
        window.rootViewController               = navigationController
        window.makeKeyAndVisible()
        
//        let rootVM                              = BaseMenuVM()
//        let rootTBNController                   = ManuTabBarWithListsVC.initFromStoryboardEmbedInNVC(name: Storyboards.example.rawValue, withViewModel: rootVM)
//        self.navigationController               = rootTBNController
//        window.rootViewController               = navigationController
//        window.makeKeyAndVisible()
    }
    
}
