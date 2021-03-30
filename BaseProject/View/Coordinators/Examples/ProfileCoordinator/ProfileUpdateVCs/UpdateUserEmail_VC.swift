//
//  UpdateUserEmail_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift
import CountryPickerView

class UpdateUserEmailVC: BaseFormVC<UpdateUserEmailVM> {
    
    @IBOutlet weak var emailTxtFld                          : NCNormalTextField!

    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!

    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 180 } set {} }

    deinit {
        print("deinit UpdateUserEmailVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad(extraFormFields: nil)
    }

    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        self.addBackButton(title: "")

        emailTxtFld.fieldName                                        = "Email".localized()
        emailTxtFld.validation                                       = FormValidation.required.and(validation: FormValidation.email)
    }

    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.user._email.bind(to: emailTxtFld.rx.text.orEmpty),
                
                // MARK: - Outputs
                emailTxtFld.rx.text.orEmpty.bind(to: viewModel.user._email)
            ])
        }
    }
}

