//
//  SwivelMaxCharachtersTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit


/// Using this class enables you to set a maximum character limit to the TextField.
/// Input character count will be display in a small label in the right side.
@IBDesignable open class SwivelMaxCharachtersTextField: SwivelNormalTextField, UITextFieldDelegate {
    
    @objc var maxCountExeedAction: ((_ tf: UITextField, _ charCountLabel: UILabel) -> ())?
    var maxCount: Int                       = 50
    private(set) var characterCountLabel: UILabel = {
        $0.textAlignment                    = .right
        $0.textColor                        = .lightGray
        $0.font                             = UIFont.systemFont(ofSize: 12)
        $0.text                             = "0/0"
        return $0
    }(UILabel(frame: CGRect(x: 0, y: 20, width: 40, height: 20)))
    
    override var textFieldInsets            : UIEdgeInsets { get { return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 40) } set {} }
    
    
    /// Configurations for max charactor count
    /// - Parameters:
    ///   - maxCount: maximum charactor count
    ///   - countColor: Color of the count label
    ///   - viewMode: Textfield's rightViewMode
    ///   - defaultTextToGetLength: If there any default text value for TextField.
    ///   - maxCountExeedAction: Closure to configure the max count ExeedAction
    func configMaxCount(maxCount: Int? = 50,
                                countColor: UIColor? = .lightGray,
                                viewMode: UITextField.ViewMode? = .always,
                                defaultTextToGetLength: String? = nil,
                                maxCountExeedAction: ((_ tf: UITextField, _ charCountLabel: UILabel) -> ())? = nil) {
        self.maxCountExeedAction            = maxCountExeedAction
        self.maxCount                       = maxCount!
        self.characterCountLabel.textColor  = countColor
        self.characterCountLabel.text       = "\(defaultTextToGetLength?.count ?? 0)/\(self.maxCount)"
        let countLabelView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        countLabelView.addSubview(characterCountLabel)
        self.rightView                      = countLabelView
        self.rightViewMode                  = viewMode!
        self.delegate                       = self
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result                          = true
        let currentString: NSString         = textField.text! as NSString
        let newString: NSString             = currentString.replacingCharacters(in: range, with: string) as NSString
        result                              = newString.length <= self.maxCount
        if result {
            self.characterCountLabel.text   = "\(newString.length)/\(self.maxCount)"
        }
        return result
    }
    
}
