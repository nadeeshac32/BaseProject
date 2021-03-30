//
//  SocialSignInVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

//import FirebaseMessaging

protocol SocialSignInVM {
    func signInWithGoogle(token: String)
    func signInWithFacebook(token: String)
    func updateFirebaseToken()
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
                self?.updateFirebaseToken()
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
                self?.updateFirebaseToken()
                self?.showHomeVC.onNext(true)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
    func updateFirebaseToken() {
//        if let token = Messaging.messaging().fcmToken {
//            let httpService = HTTPService()
//            httpService.addFirebaseToken(fcmToken: token, onSuccess: {
//                print("addToken success")
//            }) { [weak self] (error) in
//                self?.handleRestClientError(error: error)
//            }
//        } else {
//            print("token is not received")
//        }
    }
    
}
