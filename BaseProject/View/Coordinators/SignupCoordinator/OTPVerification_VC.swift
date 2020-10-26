//
//  OTPVerification_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import PinCodeTextField
import MessageUI

class OTPVerificationVC: BaseFormVC<OTPVerificationVM> {
    
    @IBOutlet weak var verificationSentLbl                              : UILabel!
    @IBOutlet weak var countDownLbl                                     : UILabel!
    @IBOutlet weak var openEmailAppBtn                                  : UIButton!
    @IBOutlet weak var pinTxtFld                                        : PinCodeTextField!
    @IBOutlet weak var resendBtn                                        : UIButton!
    
    @IBOutlet public weak var _scrollView                               : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons                           : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons                        : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons                     : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                             : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin                   : NSLayoutConstraint!
    override var scrollViewContentHeightWithouDynemicGap                : CGFloat { get { return 450 } set {} }
    
    deinit {
        print("deinit OTPVerificationVC")
    }
    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }
    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        
        self.addBackButton(title: "")
        let otpVerificationType                                         = viewModel?.otpVerificationType ?? OTPVerificationType.SignUp
        title                                                           = otpVerificationType == OTPVerificationType.SignUp ? "Verification Code".localized() :
                                                                          otpVerificationType == OTPVerificationType.UpdateEmail ? "Change Email Address".localized() :
                                                                          otpVerificationType == OTPVerificationType.UpdateMobile ? "Change Mobile Number".localized() : "Forgot Password".localized()
        
        self.verificationSentLbl.text                                   = ""
        self.openEmailAppBtn.isHidden                                   = otpVerificationType == OTPVerificationType.UpdateEmail ? false : true
        
        
        pinTxtFld.delegate                                              = self
        pinTxtFld.keyboardType                                          = .numberPad
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pinTxtFldTapped(_:)))
        self.pinTxtFld.addGestureRecognizer(tap)
        
        self.resendBtn.setTitleColor(AppConfig.si.colorPrimaryDisabled, for: .disabled)
    }

    @objc func pinTxtFldTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.pinTxtFld.becomeFirstResponder()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        if let viewModel = viewModel {
            disposeBag.insert(
                // MARK: Outputs
                resendBtn.rx.tap.bind(onNext: viewModel.performResendRequest),
                openEmailAppBtn.rx.tap.bind(to: viewModel.openMailAppTapped),
                
                // MARK: Inputs
                viewModel.openMailApp.subscribe(onNext: { [weak self] (_) in
                    let mailUrlString       = "message://"
                    var canOpenMail         = false
                    if let mailUrl = URL(string: mailUrlString) {
                        if UIApplication.shared.canOpenURL(mailUrl) { canOpenMail = true }
                    }
                    
                    let googleUrlString     = "googlegmail://"
                    var canOpenGMail        = false
                    if let googleUrl = URL(string: googleUrlString) {
                        if UIApplication.shared.canOpenURL(googleUrl) { canOpenGMail = true }
                    }
                    
                    let openMailAction      = { UIApplication.shared.open(URL(string: mailUrlString)!, options: [:], completionHandler: nil) }
                    let openGmailAction     = { UIApplication.shared.open(URL(string: googleUrlString)!, options: [:], completionHandler: nil) }
                    
                    if canOpenGMail && canOpenMail {
                        let optionMenu      = UIAlertController(title: "Choose Option".localized(), message: nil, preferredStyle: .actionSheet)
                        let openMail        = UIAlertAction(title: "Mail".localized(), style: .default, handler: { (alert: UIAlertAction!) -> Void in openMailAction() })
                        let openGmail       = UIAlertAction(title: "Gmail".localized(), style: .default, handler: { (alert: UIAlertAction!) -> Void in openGmailAction() })
                        let cancelAction    = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler:nil)
                        
                        optionMenu.addAction(openMail)
                        optionMenu.addAction(openGmail)
                        optionMenu.addAction(cancelAction)
                        
                        self?.present(optionMenu, animated: true, completion: nil)
                    } else if canOpenMail {
                        openMailAction()
                    } else if canOpenGMail {
                        openGmailAction()
                    }
                }),
                viewModel.isResendEnabled.bind(to: resendBtn.rx.isEnabled),
                viewModel.updateVerificationCodeText.subscribe(onNext: { [weak self] (attributedString) in
                    self?.verificationSentLbl.attributedText            = attributedString
                }),
                viewModel.updateCountDownText.subscribe(onNext: { [weak self] (countDownString) in
                    self?.countDownLbl.text                             = countDownString
                }),
                viewModel.clearOTP.subscribe(onNext: { [weak self] (_) in
                    self?.pinTxtFld.text                                = ""
                    viewModel.otp.onNext("")
                })
            )
        }
    }
}


extension OTPVerificationVC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool { return true }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) { }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) { viewModel?.otp.onNext(textField.text ?? "") }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool { return true }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool { return true }
}



extension OTPVerificationVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            // show error
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            break
        case .failed:
            break
        case .sent:
            break
        case .saved:
            break
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
