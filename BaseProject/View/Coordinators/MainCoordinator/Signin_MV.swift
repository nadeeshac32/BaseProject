//
//  Signin_MV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import GoogleSignIn

class SigninVM: BaseFormVM, SocialSignInVM {
    
    // MARK: - Inputs
    let selectRegister                          : AnyObserver<Void>
    let usernamePrefex                          = BehaviorSubject<String>(value: "")
    let username                                = BehaviorSubject<String>(value: "")
    let password                                = BehaviorSubject<String>(value: "")
    let forgotPasswordTapped                    : AnyObserver<Void>
    
    // MARK: - Outputs
    let showHomeVC                              : PublishSubject<Bool>      = PublishSubject()
    let showRegisterVC                          : Observable<Void>
    let showGenerateOTPvCtoResetPassword        : Observable<User>
    
    deinit {
        print("deinit SigninVM")
    }
    
    override init() {
        let _selectRegister                     = PublishSubject<Void>()
        self.selectRegister                     = _selectRegister.asObserver()
        self.showRegisterVC                     = _selectRegister.asObservable()
        
        let _forgotPasswordTapped               = PublishSubject<Void>()
        self.forgotPasswordTapped               = _forgotPasswordTapped.asObserver()
        self.showGenerateOTPvCtoResetPassword   = _forgotPasswordTapped.asObservable().map({ (_) -> User in
            return User()
        })
        
        super.init()
    }
    
    // MARK: - Class methods
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !requestLoading.value() else { return }
            let usernamePrefexString    = try usernamePrefex.value()
            var usernameString          = try username.value()
            let passwordString          = try password.value()
            if usernamePrefexString != "" && usernameString.hasPrefix("0") {
                usernameString          = String(usernameString.dropFirst(1))
            }
            let httpService             = HTTPService()
            requestLoading.onNext(true)
            httpService.signin(username: "\(usernamePrefexString)\(usernameString)", password: passwordString, onSuccess: { [weak self] in
                self?.requestLoading.onNext(false)
                self?.showHomeVC.onNext(true)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
    
}
