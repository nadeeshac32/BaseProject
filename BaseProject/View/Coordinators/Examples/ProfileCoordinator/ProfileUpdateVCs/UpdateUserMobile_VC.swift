//
//  UpdateUserMobile_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift
import CountryPickerView

class UpdateUserMobileVC: BaseFormVC<UpdateUserMobileVM>, DropDownPresentable {
    
    @IBOutlet weak var mobileTxtFld                         : NCPrefixSelectTextField!

    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!

    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 180 } set {} }
    let countryPickerView                                   = CountryPickerView()

    deinit {
        print("deinit UpdateUserMobileVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }

    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        let countryCode = viewModel?.user.mobileNo?.countryCode == nil || viewModel?.user.mobileNo?.countryCode == "" ? countryPickerView.selectedCountry.phoneCode : viewModel?.user.mobileNo?.countryCode
        viewModel?.user.mobileNo?.countryCode               = countryCode
        viewModel?.user.mobileNo?.resetData()
        super.customiseView()
        
        self.addBackButton(title: "")
        let otpVerificationType                             = viewModel?.type ?? OTPVerificationType.UpdateMobile
        title                                               = otpVerificationType == OTPVerificationType.UpdateMobile ? "Change Mobile Number".localized() : "Forgot Password".localized()
        
        mobileTxtFld.fieldName                              = "Mobile number".localized()
        mobileTxtFld.validation                             = FormValidation.required.and(validation: FormValidation.phone)
        mobileTxtFld.dropDownType                           = .countryCodePicker(cpv: countryPickerView, selectedCode: countryCode)
        mobileTxtFld.dropDownTextFieldDelegate              = self
    }


    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel, let _ = viewModel.user.mobileNo {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.user.mobileNo!._countryCode.bind(to: mobileTxtFld.rx.prefixValue),
                viewModel.user.mobileNo!._localNumber.bind(to: mobileTxtFld.rx.text.orEmpty),
                
                // MARK: - Outputs
                mobileTxtFld.rx.prefixValue.bind(to: viewModel.user.mobileNo!._countryCode),
                mobileTxtFld.rx.text.orEmpty.bind(to: viewModel.user.mobileNo!._localNumber),
            ])
        }
    }
    
}
