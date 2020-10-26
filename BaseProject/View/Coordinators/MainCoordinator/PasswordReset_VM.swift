//
//  PasswordReset_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class PasswordResetVM: BaseFormVM {
    
    let user                        : User!
    
    // MARK: - Inputs
    let password                    = BehaviorSubject<String>(value: "")
    let reenterPassword             = BehaviorSubject<String>(value: "")
    
    deinit {
        print("deinit PasswordResetVM")
    }
    
    init(user: User) {
        self.user                   = user
        super.init()
    }
    // MARK: - Overrides
    override func backButtonTapped() {
        if hasEdited() {
            let alert = (title: "Discard Changes".localized(), message: "Are you sure you want to discard your changes?".localized(),
            primaryBtnTitle: "Discard".localized(), primaryActionColor: AppConfig.si.colorPrimary, primaryAction: { [weak self] in
               self?.goToPreviousVC.onNext(true)
               return
            },
            secondaryBtnTitle: "Keep Editing".localized(), secondaryActionColor: nil, secondaryAction: nil) as alertType
            showAlert.on(.next(alert))
        } else {
            goToPreviousVC.onNext(true)
        }
    }
    
    // MARK: - Class methods
    func hasEdited() -> Bool {
        var passwordString          = ""
        var reenterPasswordString   = ""
        do {
            passwordString          = try password.value()
            reenterPasswordString   = try reenterPassword.value()
        } catch let error {
            print("Fetal error: \(error)")
        }
        
        return passwordString != "" || reenterPasswordString != ""
    }
    
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }
            
            // Bypassing password reset via mobile request
            print("Bypassing password reset via mobile request")
            let tupple = (message: "Successfully reset the password.".localized(), blockScreen: true, completionHandler: { [weak self] in
                self?.logoutUserWithoutPermission()
            })
            self.successMessage.onNext(tupple)
            
//            let passwordString      = try password.value()
//            guard let mobile = self.user.mobileNo?.copy() as? MobileNumber else { return }
//
//            let httpService         = HTTPService()
//            freezeForRequestLoading.onNext(true)
//            httpService.updateResetPassword(mobileNo: mobile, newPassword: passwordString, onSuccess: { [weak self] in
//                self?.freezeForRequestLoading.onNext(false)
//                let tupple = (message: "Successfully reset the password.".localized(), blockScreen: true, completionHandler: { [weak self] in
//                    self?.logoutUserWithoutPermission()
//                })
//                self?.successMessage.onNext(tupple)
//            }) { [weak self] (error) in
//                self?.handleRestClientError(error: error)
//            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
}

