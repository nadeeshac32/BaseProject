//
//  UpdateUserMobile_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

class UpdateUserMobileVM: BaseFormVM {
    
    let user                        : User
    let type                        : OTPVerificationType
    
    // MARK: - Outputs
    let showOTPVerificationVC       : PublishSubject<User> = PublishSubject()
    
    init(user: User, type: OTPVerificationType) {
        self.user                   = user
        self.type                   = type
        super.init()
    }
    
    deinit {
        print("deinit UpdateUserMobileVM")
    }
    
    // MARK: - Overrides
    override func backButtonTapped() {
        if user.hasEdited() {
            let alert = (title: "Discard Changes".localized(), message: "Are you sure you want to discard your changes?".localized(),
            primaryBtnTitle: "Discard".localized(), primaryActionColor: AppConfig.si.colorPrimary, primaryAction: { [weak self] in
               self?.user.resetData()
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
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }
            
            // Bipassing OTP generate network request
            print("Bipassing OTP generate network request")
            self.showOTPVerificationVC.onNext(user)
            
//            if let mobileObject = user.mobileNo?.hasEdited() == true ? user.mobileNo?.copy() as? MobileNumber : user.mobileNo {
//                let httpService         = HTTPService()
//                freezeForRequestLoading.onNext(true)
//                httpService.generateOTP(mobile: mobileObject, onSuccess: { [weak self] in
//                    self?.freezeForRequestLoading.onNext(false)
//                    if let user = self?.user {
//                        self?.showOTPVerificationVC.onNext(user)
//                    }
//                }) { [weak self] (error) in
//                    self?.handleRestClientError(error: error)
//                }
//            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
}
