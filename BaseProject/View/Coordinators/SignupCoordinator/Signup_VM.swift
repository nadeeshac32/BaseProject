//
//  Signup_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift

class SignupVM: BaseFormVM {
    // MARK: - Inputs
    let logUserIn                   : AnyObserver<Void>
    let username                    = BehaviorSubject<String>(value: "")
    let password                    = BehaviorSubject<String>(value: "")
    let confirmPassword             = BehaviorSubject<String>(value: "")
    let mobileNo                    = MobileNumber()
    
    // MARK: - Outputs
    let showOTPVerificationVC       : PublishSubject<UserPostData>
    let showHomeVC                  : Observable<Void>
    
    deinit {
        print("deinit SignupVM")
    }
    override init() {
        let _logUserIn              = PublishSubject<Void>()
        self.logUserIn              = _logUserIn.asObserver()
        self.showHomeVC             = _logUserIn.asObservable()
        
        self.showOTPVerificationVC  = PublishSubject()
        
        super.init()
    }
    
    // MARK: - Class methods
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }
            let usernameString      = try username.value()
            let passwordString      = try password.value()
            let mobileObject        = mobileNo.copy() as? MobileNumber

            // Bypassing OTP Generate network request
            print("Bypassing OTP Generate network request")
            let userPostData        = UserPostData(fullName: usernameString, password: passwordString, email: nil, mobileNo: mobileObject)
            self.showOTPVerificationVC.onNext(userPostData)
            
//            let httpService         = HTTPService()
//            freezeForRequestLoading.onNext(true)
//            httpService.generateOTP(mobile: mobileObject, onSuccess: { [weak self] in
//                self?.freezeForRequestLoading.onNext(false)
//                let userPostData    = UserPostData(fullName: usernameString, password: passwordString, email: nil, mobileNo: mobileObject)
//                self?.showOTPVerificationVC.onNext(userPostData)
//            }) { [weak self] (error) in
//                self?.handleRestClientError(error: error)
//            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
}
