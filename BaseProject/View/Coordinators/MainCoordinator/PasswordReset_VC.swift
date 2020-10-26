//
//  PasswordReset_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PasswordResetVC: BaseFormVC<PasswordResetVM>, DropDownPresentable {
    
    @IBOutlet weak var passwordTxtFld                       : SwivelRightButtonActionTextField!
    @IBOutlet weak var reenterPasswordTxtFld                : SwivelRightButtonActionTextField!
    
    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!

    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 320 } set {} }
    
    deinit {
        print("deinit PasswordResetVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }
    
    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        self.addBackButton(title: "")
        
        passwordTxtFld.fieldName                            = "Password".localized()
        passwordTxtFld.validation                           = FormValidation.required.and(validation: FormValidation.password)
        passwordTxtFld.rightButtonActionType                = .secureKey

        reenterPasswordTxtFld.fieldName                     = "Re-enter password".localized()
        if let viewModel = self.viewModel {
            reenterPasswordTxtFld.validation                = FormValidation.required.and(validation: FormValidation.confirmPassword(passwordField: viewModel.password)).and(validation: FormValidation.password)
        }
        reenterPasswordTxtFld.rightButtonActionType         = .secureKey
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
                passwordTxtFld.rx.text.orEmpty.bind(to: viewModel.password),
                reenterPasswordTxtFld.rx.text.orEmpty.bind(to: viewModel.reenterPassword),

                // MARK: - Inputs
                passwordTxtFld.rx.text.subscribe(onNext: { [weak self] (password) in
                    self?.reenterPasswordTxtFld.text            = ""
                    let textField                               = self?.reenterPasswordTxtFld
                    let error                                   = textField?.error
                    let validation                              = textField?.validation.validate(fieldName: textField?.fieldName, text: textField?.finalString)?.first ?? ""
                    error?.onNext(validation.isNotEmpty ? FormValidationError.loginButtonDesablOnFirstLoad.rawValue : "")
                }),

                passwordTxtFld.error.subscribe(onNext: { [weak self] (error) in
                    if error == FormValidationError.loginButtonDesablOnFirstLoad.rawValue { return }
                    if error != "" {
                        let popupController = UIStoryboard(name: Storyboards.signup.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: "AlertPopoverVC") as? AlertPopoverVC
                        popupController?.modalPresentationStyle = .popover
                        popupController?.preferredContentSize   = CGSize(width: AppConfig.si.screenSize.width - 100, height: 80)

                        if let popoverController = popupController?.popoverPresentationController {
                            popoverController.sourceView        = self?.passwordTxtFld.errorLabel
                            popoverController.sourceRect        = CGRect(x: self?.passwordTxtFld.errorLabel.bounds.minX ?? 0,
                                                                         y: self?.passwordTxtFld.errorLabel.bounds.maxY ?? 0,
                                                                         width: 1,
                                                                         height: 1)
                            popoverController.permittedArrowDirections = .up
                            popoverController.delegate          = self
                            if let popupController = popupController {
                              self?.present(popupController, animated: true, completion: nil)
                            }
                        }
                    } else { self?.presentedViewController?.dismiss(animated: true, completion: nil) }
                })
            ])
        }
    }
}

extension PasswordResetVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return .none }
}
