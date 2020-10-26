//
//  Signup_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import CountryPickerView

class SignupVC: BaseFormVC<SignupVM>, DropDownPresentable {

    @IBOutlet weak var fullNameTxtFld                                   : SwivelNormalTextField!
    @IBOutlet weak var passwordTxtFld                                   : SwivelRightButtonActionTextField!
    @IBOutlet weak var confirmPasswordTxtFld                            : SwivelRightButtonActionTextField!
    @IBOutlet weak var mobileTxtFld                                     : SwivelPrefixSelectTextField!
    @IBOutlet weak var privacyPolicyLbl                                 : UILabel!
    
    @IBOutlet public weak var _scrollView                               : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons                           : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons                        : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons                     : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                             : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin                   : NSLayoutConstraint!
    
    override var scrollViewContentHeightWithouDynemicGap                : CGFloat { get { return 490 } set {} }
    var countryPickerView                                               : CountryPickerView = CountryPickerView()
    
    deinit {
        print("deinit SignupVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }
    
    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        self.addBackButton(title: self.previousVCTitle?.localized() ?? "Log In".localized())
        title                                                           = "Register".localized()

        fullNameTxtFld.fieldName                                        = "Full name".localized()
        fullNameTxtFld.validation                                       = FormValidation.required

        passwordTxtFld.fieldName                                        = "Password".localized()
        passwordTxtFld.validation                                       = FormValidation.required.and(validation: FormValidation.password)
        passwordTxtFld.rightButtonActionType                            = .secureKey

        confirmPasswordTxtFld.fieldName                                 = "Confirm password".localized()
        if let viewModel = self.viewModel {
            confirmPasswordTxtFld.validation                            = FormValidation.required.and(validation: FormValidation.confirmPassword(passwordField: viewModel.password)).and(validation: FormValidation.password)
        }
        confirmPasswordTxtFld.rightButtonActionType                     = .secureKey

        mobileTxtFld.fieldName                                          = "Mobile number".localized()
        mobileTxtFld.validation                                         = FormValidation.required.and(validation: FormValidation.phone)
        mobileTxtFld.dropDownType                                       = .countryCodePicker(cpv: countryPickerView)
        mobileTxtFld.dropDownTextFieldDelegate                          = self

        let privacyPolicyPart1                                          = "Privacy Policy text part 1".localized()
        let privacyPolicyPart2                                          = "Privacy Policy text part 2".localized()
        let privacyPolicyPart3                                          = "Privacy Policy text part 3".localized()
        let privacyPolicyPart4                                          = "Privacy Policy text part 4".localized()
        
        let attributedString                                            = NSMutableAttributedString(string: "\(privacyPolicyPart1)\(privacyPolicyPart2)\(privacyPolicyPart3)\(privacyPolicyPart4)")
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: AppConfig.si.colorPrimary,
                                      range: NSRange(location: privacyPolicyPart1.count,
                                                     length: privacyPolicyPart2.count))
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: AppConfig.si.colorPrimary,
                                      range: NSRange(location: "\(privacyPolicyPart1)\(privacyPolicyPart2)\(privacyPolicyPart3)".count,
                                                     length: privacyPolicyPart4.count))

        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                      range: NSRange(location: privacyPolicyPart1.count,
                                                     length: privacyPolicyPart2.count))
        
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                      range: NSRange(location: "\(privacyPolicyPart1)\(privacyPolicyPart2)\(privacyPolicyPart3)".count,
                                                     length: privacyPolicyPart4.count))

        privacyPolicyLbl.attributedText                                 = attributedString
        privacyPolicyLbl.isUserInteractionEnabled                       = true
        let tapgesture                                                  = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired                                 = 1
        privacyPolicyLbl.addGestureRecognizer(tapgesture)
    }
    
    @objc override func backBtnTapped() {
        passwordTxtFld.error.onCompleted()
        super.backBtnTapped()
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Outputs
                fullNameTxtFld.rx.text.orEmpty.bind(to: viewModel.username),
                passwordTxtFld.rx.text.orEmpty.bind(to: viewModel.password),
                confirmPasswordTxtFld.rx.text.orEmpty.bind(to: viewModel.confirmPassword),
                mobileTxtFld.rx.text.orEmpty.bind(to: viewModel.mobileNo._localNumber),
                mobileTxtFld.rx.prefixValue.bind(to: viewModel.mobileNo._countryCode),

                passwordTxtFld.rx.text.subscribe(onNext: { [weak self] (password) in
                    self?.confirmPasswordTxtFld.text                    = ""
                    let textField                                       = self?.confirmPasswordTxtFld
                    let error                                           = textField?.error
                    let validation                                      = textField?.validation.validate(fieldName: textField?.fieldName, text: textField?.finalString)?.first ?? ""
                    error?.onNext(validation.isNotEmpty ? FormValidationError.loginButtonDesablOnFirstLoad.rawValue : "")
                }),

                passwordTxtFld.error.subscribe(onNext: { [weak self] (error) in
                    if error == FormValidationError.loginButtonDesablOnFirstLoad.rawValue { return }
                    if error != "" {
                        let popupController = self?.storyboard?.instantiateViewController(withIdentifier: "AlertPopoverVC") as? AlertPopoverVC
                        popupController?.modalPresentationStyle         = .popover
                        popupController?.preferredContentSize           = CGSize(width: AppConfig.si.screenSize.width - 100, height: 80)

                        if let popoverController = popupController?.popoverPresentationController {
                            popoverController.sourceView                = self?.passwordTxtFld.errorLabel
                            popoverController.sourceRect                = CGRect(x: self?.passwordTxtFld.errorLabel.bounds.minX ?? 0, y: self?.passwordTxtFld.errorLabel.bounds.maxY ?? 0, width: 1, height: 1)
                            popoverController.permittedArrowDirections  = .up
                            popoverController.delegate                  = self
                            if let popupController = popupController {
                              self?.present(popupController, animated: true, completion: nil)
                            }
                        }
                    } else {
                        self?.presentedViewController?.dismiss(animated: true, completion: nil)
                    }
                })
                // MARK: - Inputs
            ])
        }
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = privacyPolicyLbl.text else { return }
        let privacyPolicy                                               = "Privacy Policy text part 2".localized()
        let termsAndCondition                                           = "Privacy Policy text part 4".localized()
        let privacyPolicyRange = (text as NSString).range(of: privacyPolicy)
        let termsAndConditionRange = (text as NSString).range(of: termsAndCondition)
        if gesture.didTapAttributedTextInLabel(label: privacyPolicyLbl, inRange: privacyPolicyRange) {
            let privacyPolicyUrl                                        = "privacyPolicyUrl".localized()
            if let url = URL(string: privacyPolicyUrl) {
                UIApplication.shared.open(url)
            }
        } else if gesture.didTapAttributedTextInLabel(label: privacyPolicyLbl, inRange: termsAndConditionRange){
            let termsAndConditionUrl                                    = "termsAndConditionUrl".localized()
            if let url = URL(string: termsAndConditionUrl) {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension SignupVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
