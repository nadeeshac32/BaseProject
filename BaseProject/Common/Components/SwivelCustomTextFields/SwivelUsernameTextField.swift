//
//  SwivelUsernameTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CountryPickerView

enum UsernameType {
    case email
    case mobile
}

/// TextField that can be used as username input field.
/// Once the user start to type numeric value it will show a country picker and changed to a mobile number input field. But when you type a letter it will change back to email input field.
@IBDesignable open class SwivelUsernameTextField: SwivelNormalTextField, UITextFieldDelegate, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    var dropDownView                            : DropDownPrefixView = DropDownPrefixView()
    var cpv                                     : CountryPickerView?
    weak var usernameTextFieldDelegate          : DropDownPresentable?
    
    var currentType: UsernameType = .email {
        didSet {
            if self.currentType == .email {
                removeCountryPicker()
            } else if cpv != nil {
                configDropDownWith(initialPrefix: cpv!.selectedCountry.phoneCode)
            }
        }
    }
    
    func getLeftPadding() -> UIEdgeInsets {
        if currentType == .email {
            return UIEdgeInsets(top: 12, left: 0, bottom: -10, right: 20)
        } else {
            return UIEdgeInsets(top: 12, left: 80, bottom: -10, right: 20)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: getLeftPadding())
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: getLeftPadding())
    }
    
    private var realDelegate: UITextFieldDelegate?
    open override var delegate: UITextFieldDelegate? {
        get {
            return realDelegate
        }
        set {
            realDelegate = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.delegate = self
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.placeholder                        = "Email or Mobile number".localized()
        self.fieldName                          = "Email or Mobile number".localized()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString   = "\(textField.text ?? "")"
        let finalString     : String
        
        if string != "" {
            finalString = "\(textField.text ?? "")\(string)"
        } else if currentString.count > 0 {
            finalString = String(currentString.dropLast())
        } else {
            finalString = ""
        }

        if let _ = Int(finalString) {
            currentType                         = .mobile
        } else {
            currentType                         = .email
        }
        
        if finalString == "" {
            self.placeholder                    = "Email or Mobile number".localized()
            self.fieldName                      = "Email or Mobile number".localized()
        }
        
        return realDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func removeCountryPicker() {
        self.placeholder                        = "Email address".localized()
        self.fieldName                          = "Email address".localized()
        self.dropDownView.prefixLabel.text      = ""
        self.prefixValue                        = ""
        self.leftViewMode                       = .never
        self.leftView                           = nil
        self.setNeedsLayout()
        //  self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    //  initialImageName: 50px x 50px
    func configDropDownWith(initialPrefix: String) {
        self.placeholder                        = "Mobile number placeholder".localized()
        self.fieldName                          = "Mobile number".localized()
        self.dropDownView.backgroundColor       = .clear
        self.dropDownView.prefixLabel.textColor = self.textColor
        self.dropDownView.prefixLabel.text      = initialPrefix
        self.prefixValue                        = initialPrefix
        let tap                                 = UITapGestureRecognizer(target: self, action: #selector(dropDownTapped(sender:)))
        self.dropDownView.addGestureRecognizer(tap)
        self.leftView                           = dropDownView
        self.leftViewMode                       = .always
        self.setNeedsLayout()
        //  self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @objc func dropDownTapped(sender: AnyObject) {
        usernameTextFieldDelegate?.showCountryPickerDropDown(tf: self, cpv: cpv!)
    }

    public func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.dropDownView.prefixLabel.text      = country.phoneCode
        self.prefixValue                        = country.phoneCode
        self.becomeFirstResponder()
    }
}
