//
//  Signin_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift
import CountryPickerView
import GoogleSignIn
import FBSDKLoginKit

class SigninVC: BaseFormVC<SigninVM>, DropDownPresentable, GoogleSignable, FacebookSignable {

    @IBOutlet weak var usernameTxtFld                                   : SwivelUsernameTextField!
    @IBOutlet weak var passwordTxtFld                                   : SwivelRightButtonActionTextField!
    @IBOutlet weak var forgetPasswordBtn                                : UIButton!
    @IBOutlet weak var registerBtn                                      : UIButton!
    @IBOutlet weak var googleSigninBtn                                  : GIDSignInButton!
    @IBOutlet weak var facebookSigninBtn                                : SwivelFBLoginButton!
    
    @IBOutlet public weak var _scrollView                               : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons                           : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons                        : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons                     : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                             : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin                   : NSLayoutConstraint!
    
    override var dynemicGapShouldCalculate                              : Bool { get { return false } set {} }
    override var scrollViewContentHeightWithouDynemicGap                : CGFloat { get { return 698 } set {} }
    override var scrollViewMinimumDynemicGap                            : CGFloat { get { return 16 } set {} }
    
    var countryPickerView                                               : CountryPickerView = CountryPickerView()
    
    deinit {
        print("deinit SigninVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }
    
    override func customiseView() {
        initialise(scrollView: _scrollView,
                   dynemicGapCons: _dynemicGapCons,
                   scrollViewTopCons: _scrollViewTopCons,
                   scrollViewBottomCons: _scrollViewBottomCons,
                   submitButton: _submitButton,
                   scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        
        title                                                           = "Log In".localized()
        
        usernameTxtFld.fieldName                                        = "Email or Mobile number".localized()
        usernameTxtFld.usernameTextFieldDelegate                        = self
        usernameTxtFld.validation                                       = FormValidation.required.and(validation: FormValidation.email.or(validation: FormValidation.phone))
        usernameTxtFld.cpv                                              = countryPickerView
        
        passwordTxtFld.fieldName                                        = "Password".localized()
        passwordTxtFld.validation                                       = FormValidation.required
        passwordTxtFld.rightButtonActionType                            = .secureKey
        
        registerBtn.addBoarder(width: 2, cornerRadius: 5, color: AppConfig.si.colorPrimary)
        registerBtn.setTitleColor(AppConfig.si.colorPrimary, for: .normal)
        
        forgetPasswordBtn.setTitleColor(AppConfig.si.colorPrimary, for: .normal)
        
        // MARK: - Configure google sign in button
        configureGoogleSignIn(delegate: self, googleSignInButton: googleSigninBtn)
        
        // MARK: - Configure facebook sign in button
        configureFacebookSignIn(facebookSignInButton: facebookSigninBtn)
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            
            disposeBag.insert([
                // MARK: - Outputs
                usernameTxtFld.rx.prefixValue.bind(to: viewModel.usernamePrefex),
                usernameTxtFld.rx.text.orEmpty.bind(to: viewModel.username),
                passwordTxtFld.rx.text.orEmpty.bind(to: viewModel.password),
                registerBtn.rx.tap.bind(to: viewModel.selectRegister),
                forgetPasswordBtn.rx.tap.bind(to: viewModel.forgotPasswordTapped)
                
                // MARK: - Inputs
            ])
        }
    }
}
