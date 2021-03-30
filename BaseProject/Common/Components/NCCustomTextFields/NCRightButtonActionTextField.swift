//
//  NCRightButtonActionTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

/// Preset configurations for Right Button Action
enum RightButtonActionType {
    case secureKey
    
    func getConficuration() -> (initialImageName: String, imageColor: UIColor, viewMode: UITextField.ViewMode, action: (_ tf: UITextField, _ rightButton: UIButton) -> ()) {
        
        switch self {
        case .secureKey:
            // initialImageName: 50px x 50px
            return (initialImageName: "icon_passwordUnhide-50", imageColor: AppConfig.si.colorPrimary, viewMode: UITextField.ViewMode.whileEditing, action: { (tf: UITextField, rb: UIButton) in
                tf.isSecureTextEntry = !tf.isSecureTextEntry
                if tf.isSecureTextEntry {
                    rb.setImage(UIImage(named: "icon_passwordUnhide-50")?.withRenderingMode(.alwaysTemplate) , for: .normal)
                } else {
                    rb.setImage(UIImage(named: "icon_passwordHide-50")?.withRenderingMode(.alwaysTemplate) , for: .normal)
                }
            })
        }
    }
    
}

/// Text field extended from `NCNormalTextField` that has custom action for right button which appears while typing.
@IBDesignable open class NCRightButtonActionTextField: NCNormalTextField {
    
    /// Button that will be on the left side of the textfield.
    let rightButton  = UIButton(type: .custom)
    
    /// Action to trigger when the right button is tapped.
    @objc var rightButtonAction: ((_ tf: UITextField, _ rightButton: UIButton) -> ())?
    
    /// Preset conficaration can be set so it will call `configButtonWithImage` automatically.
    var rightButtonActionType: RightButtonActionType? {
        didSet {
            guard let config = rightButtonActionType?.getConficuration() else { return }
            configButtonWithImage(initialImageName: config.initialImageName, imageColor: config.imageColor, viewMode: config.viewMode, rightButtonAction: config.action)
        }
    }
    
    /// Configurations for right button action
    /// - Parameters:
    ///   - initialImageName: Image name for initially loading
    ///   - imageColor: Tint color for button
    ///   - viewMode: Textfield's rightViewMode
    ///   - rightButtonAction: Closure to configure the button action
    ///   - tf: Parent TextField which is always passed by `self`
    ///   - rightButton: The button which triggers the action.
    func configButtonWithImage(initialImageName: String,            // initialImageName: 50px x 50px
                              imageColor: UIColor? = UIColor.white,
                              viewMode: UITextField.ViewMode? = .whileEditing,
                              rightButtonAction: @escaping (_ tf: UITextField, _ rightButton: UIButton) -> ()) {
        
        rightButton.setImage(UIImage(named: initialImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.addTarget(self, action: #selector(self.rightButtonTapped(sender:)), for: .touchUpInside)
        self.rightButtonAction      = rightButtonAction
        rightButton.tintColor       = imageColor
        let inset                   : UIEdgeInsets!
        if #available(iOS 13, *) {
            inset                   = UIEdgeInsets(top: 26, left: 25, bottom: 4, right: 0)
        } else {
            inset                   = UIEdgeInsets(top: 10, left: -5, bottom: -10, right: 5)
        }
        rightButton.imageEdgeInsets = inset
        rightButton.frame           = CGRect(x: 0, y: 0, width: 15, height: 15)
        rightButton.contentMode     = .scaleAspectFill
        self.rightView              = rightButton
        self.rightViewMode          = viewMode!
    }
    
    @objc func rightButtonTapped(sender: AnyObject) {
        rightButtonAction?(self, rightButton)
    }
}
