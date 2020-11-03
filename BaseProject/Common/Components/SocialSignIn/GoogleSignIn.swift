//
//  GoogleSignIn.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/19/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

protocol GoogleSignInSupport: class {
    var googleSignInVM: SocialSignInVM { get }
    func configureGoogleSignIn(delegate: GIDSignInDelegate, googleSignInButton: GIDSignInButton)
    func signedInWithGoogleToken(token: String)
}

/// Default implementation of `GoogleSignInSupport` protocol
extension GoogleSignInSupport where Self: SocialSignInSupportVC {

    var googleSignInVM: SocialSignInVM {
        return viewModel!
    }
    
    func configureGoogleSignIn(delegate: GIDSignInDelegate, googleSignInButton: GIDSignInButton) {
        GIDSignIn.sharedInstance()?.delegate    = delegate
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //  Automatically sign in the user.
        //  Attempts to restore a previously authenticated user without interaction.
        //  GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        googleSigninBtn.style                   = .wide
        googleSigninBtn.colorScheme             = .dark
    }
    
    func signedInWithGoogleToken(token: String) {
        googleSignInVM.signInWithGoogle(token: token)
    }
}


/// SigninVC implementation of `GoogleSignInSupport` protocol
extension SocialSignInSupportVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else if (error as NSError).code == GIDSignInErrorCode.canceled.rawValue {
                userCanceled()
                return
            } else {
                print("didSignInFor error: \(error.localizedDescription)")
            }
            return
        }

        /*
        print("fullName: \(String(describing: user.profile.name))")
        print("userId: \(String(describing: user.userID))")
        print("idToken: \(String(describing: user.authentication.idToken))")
        print("givenName: \(String(describing: user.profile.givenName))")
        print("familyName: \(String(describing: user.profile.familyName))")
        print("email: \(String(describing: user.profile.email))")
         */
       
        if let idToken = user.authentication.idToken {
            signedInWithGoogleToken(token: idToken)
        } else {
            somethingWentWrong()
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        userDisconnect()
    }
    
}

protocol GoogleSignable: GoogleSignInSupport, GIDSignInDelegate, SocialSignInCanclable { }
