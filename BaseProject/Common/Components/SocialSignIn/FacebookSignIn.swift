//
//  FacebookSignIn.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

protocol FacebookSignInSupport: class {
    var facebookSignInVM: SocialSignInVM { get }
    func configureFacebookSignIn(facebookSignInButton: SwivelFBLoginButton)
    func signedInWithFacebookToken(token: String)
}

/// Default implementation of `FacebookSignInSupport` protocol
extension FacebookSignInSupport where Self: SocialSignInSupportVC {

    var facebookSignInVM: SocialSignInVM {
        return viewModel!
    }
    
    func configureFacebookSignIn(facebookSignInButton: SwivelFBLoginButton) {
        facebookSigninBtn.loginCompletionHandler = { [weak self] (button, result) in
            switch result {
            case .success(let result):
                if let token = result.token?.tokenString {
                    self?.signedInWithFacebookToken(token: token)
                }
                //  Profile.loadCurrentProfile { (profile, error) in
                //      print("user name: \(String(describing: profile?.name))")
                //  }
                break
            case .failure:
                self?.somethingWentWrong()
                break
            }
        }
        
        facebookSignInButton.loginCancleHandler = { [weak self] (button) in
            self?.userCanceled()
        }
    }
    
    func signedInWithFacebookToken(token: String) {
        facebookSignInVM.signInWithFacebook(token: token)
    }
}


protocol FacebookSignable: FacebookSignInSupport, SocialSignInCanclable { }
