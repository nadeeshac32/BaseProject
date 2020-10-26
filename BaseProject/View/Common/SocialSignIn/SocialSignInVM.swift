//
//  SocialSignInVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

protocol SocialSignInVM {
    func signInWithGoogle(token: String)
    func signInWithFacebook(token: String)
}

extension SocialSignInVM where Self: SocialSignInSupportVM {
    func signInWithGoogle(token: String) {
        hideKeyBoard.onNext(true)
        do {
            guard try !requestLoading.value() else { return }
            let httpService             = HTTPService()
            requestLoading.onNext(true)
            httpService.signinWithGoogle(idToken: token, onSuccess: { [weak self] in
                self?.requestLoading.onNext(false)
                self?.showHomeVC.onNext(true)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
    func signInWithFacebook(token: String) {
        hideKeyBoard.onNext(true)
        do {
            guard try !requestLoading.value() else { return }
            let httpService             = HTTPService()
            requestLoading.onNext(true)
            httpService.signinWithFacebook(accessToken: token, onSuccess: { [weak self] in
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
