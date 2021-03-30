//
//  NCPrefixSelectTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CountryPickerView

protocol DropDownPresentable: class {
    func showCountryPickerDropDown(tf: NCPrefixSelectTextField, cpv: CountryPickerView)
    func showCountryPickerDropDown(tf: NCUsernameTextField, cpv: CountryPickerView)
}

/// UIViewController implementation of `DropDownPresentable` protocol
extension DropDownPresentable where Self: UIViewController {
    func showCountryPickerDropDown(tf: NCPrefixSelectTextField, cpv: CountryPickerView) {
        cpv.delegate    = tf
        cpv.showCountriesList(from: self)
    }
    
    func showCountryPickerDropDown(tf: NCUsernameTextField, cpv: CountryPickerView) {
        cpv.delegate    = tf
        cpv.showCountriesList(from: self)
    }
}


/// Preset configurations for Prefix selection dropdown
/// If you're adding another preset to the `DropDownType` enum you'll need to have another case here
enum DropDownType {
    case countryCodePicker(cpv: CountryPickerView, selectedCode: String? = nil)
    
    func getConficuration() -> (initialPrefix: String, imageColor: UIColor) {
        switch self {
        case let .countryCodePicker(cpv, selectedCode):
            // initialImageName: 50px x 50px
            return (initialPrefix: selectedCode ?? cpv.selectedCountry.phoneCode, imageColor: AppConfig.si.colorPrimary)
        }
    }
    
}

/// Text field extended from `NCNormalTextField` that show a dropdown when tapped. Dropdown can be configured.
@IBDesignable open class NCPrefixSelectTextField: NCNormalTextField, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    /// Dropdown label containing view
    private var dropDownView                    : DropDownPrefixView = DropDownPrefixView()
    
    /// Delegate to pass message to the ViewController to actually show the dropdown.
    /// UIViewController class has already implemented this `DropDownPresentable` protocol
    /// So to use this Dropdown field in your ViewController you have to mark the YourViewController as it extends DropDownPresentable
    /// Then assign YourViewController to the delegate. `textfield.dropDownTextFieldDelegate = self` in YourViewController.
    weak var dropDownTextFieldDelegate          : DropDownPresentable?
    
    /// Preset conficaration can be set so it will call `configDropDownWith` automatically.
    var dropDownType: DropDownType? {
        didSet {
            guard let config = dropDownType?.getConficuration() else { return }
            configDropDownWith(initialPrefix: config.initialPrefix, downArrowColor: config.imageColor)
        }
    }
    
    /// Insets for User's Text input rectangle
    override var textFieldInsets                : UIEdgeInsets { get { return UIEdgeInsets(top: 12, left: 80, bottom: 0, right: 20) } set {} }
    
    
    /// Configurations for right button action
    /// - Parameters:
    ///   - initialPrefix: Initial selected value
    ///   - downArrowColor: Downdown arrow color
    func configDropDownWith(initialPrefix: String, downArrowColor: UIColor? = UIColor.white) {
        dropDownView.backgroundColor            = .clear
        dropDownView.prefixLabel.textColor      = self.textColor
        dropDownView.prefixLabel.text           = initialPrefix
        self.prefixValue                        = initialPrefix
        self.leftView                           = dropDownView
        self.leftViewMode                       = .always

        let tap = UITapGestureRecognizer(target: self, action: #selector(dropDownTapped(sender:)))
        dropDownView.addGestureRecognizer(tap)
    }

    /// Once the dropdown is tapped this method will trigger. It will call delegate method to show the dropdown
    @objc func dropDownTapped(sender: AnyObject) {
        if let dropDownType = dropDownType {
            switch dropDownType {
                
            /// If you're adding another preset to the `DropDownType` enum you'll need to have another case here
            case let .countryCodePicker(cpv, _):
                dropDownTextFieldDelegate?.showCountryPickerDropDown(tf: self, cpv: cpv)
                return
            }
        }
    }
    
    /// This is the call back delegate method that will call after the user have picked a country from the country picker.
    /// If you're adding another preset to the `DropDownType` enum you'll need to have this kind of another method to handle the selection of the drop down.
    public func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.dropDownView.prefixLabel.text      = country.phoneCode
        self.prefixValue                        = country.phoneCode
        self.becomeFirstResponder()
    }
}

class DropDownPrefixView: GenericView {

    private(set) var prefixLabel: UILabel = {
        $0.textAlignment            = .center
        $0.textColor                = .black
        $0.font                     = UIFont.systemFont(ofSize: 16)
        $0.text                     = ""
        return $0
    }(UILabel())
    
    private(set) var downIcon: UIImageView = {
        $0.image                    = UIImage(named: "icon_down")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor                = #colorLiteral(red: 0.1921344995, green: 0.1921699941, blue: 0.1921290755, alpha: 1)
        return $0
    }(UIImageView())
    
    override func configureView() {
        super.configureView()
        initializeUI()
        createConstraints()
    }
    
    private func initializeUI() {
        self.backgroundColor = UIColor.green
        addSubview(prefixLabel)
        addSubview(downIcon)
    }
    
    private func createConstraints() {
        self.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        prefixLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalTo(downIcon.snp.left)
            make.height.equalTo(30)
            make.centerY.equalTo(downIcon.snp.centerY).offset(2)
        }
        
        downIcon.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(0)
        }
    }
}
