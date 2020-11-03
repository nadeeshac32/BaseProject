//
//  SwivelNormalTextField.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//


import UIKit

/// Normal Text field with underline highlighted with red when validation fails.
@IBDesignable open class SwivelNormalTextField: AnimateTextField {
    /**
     * The color of the border when it has no content.
     * This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    private var _borderInactiveColor: UIColor?
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     * The color of the border when it has content.
     * This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    private var _borderActiveColor: UIColor?
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     * The color of the placeholder text.
     * This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }

    open override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     * The color of the error text.
     * This property applies a color to the complete error string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var errorColor: UIColor = .red {
        didSet {
            updateError()
        }
    }
    
    /**
     * The scale of the smaller font.
     * This property determines the size of the smaller font label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var smallerFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
            updateError()
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
            updateError()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 1)
    private let errorLabelHeight                    = CGFloat(12)
    private let placeholderActiveInsets             = CGPoint(x: 0, y: 6)
    var textFieldInsets                             = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 20)
    private let errorInsets                         = CGPoint(x: 0, y: 6)
    private let inactiveBorderLayer                 = CALayer()
    private let activeBorderLayer                   = CALayer()
    private var activePlaceholderPoint: CGPoint     = CGPoint.zero
    private var activeErrorPoint: CGPoint           = CGPoint.zero
    private var inactiveErrorPoint: CGPoint         = CGPoint.zero
    
    // MARK: - Private
    private func updatePlaceholder() {
        placeholderLabel.text                       = placeholder
        placeholderLabel.textColor                  = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func updateError() {
        let errorValue                              = try? error.value()
        errorLabel.text                             = errorValue != FormValidationError.loginButtonDesablOnFirstLoad.rawValue ? errorValue : ""
        errorLabel.textColor                        = errorColor
        errorLabel.sizeToFit()
        
        let textRect                                = self.textRect(forBounds: bounds)
        var originX                                 = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - errorLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - errorLabel.bounds.width
        default:
            break
        }
        
        errorLabel.frame                            = CGRect(x: errorInsets.x, y: textRect.height/2, width: textRect.width, height: errorLabelHeight)
        
        inactiveErrorPoint                          = CGPoint(x: errorLabel.frame.origin.x,
                                                              y: (frame.height / 2) + errorLabel.frame.size.height + errorInsets.y)
        activeErrorPoint                            = CGPoint(x: errorLabel.frame.origin.x,
                                                              y: frame.height + errorInsets.y)
        errorLabel.frame.origin                     = inactiveErrorPoint
    }
    
    private func smallerFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont                             = UIFont(descriptor: font.fontDescriptor, size: font.pointSize * smallerFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame                      = CGRect(x: originX, y: textRect.height/2 + placeholderActiveInsets.y,
                                                             width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint                      = CGPoint(x: placeholderActiveInsets.x,
                                                              y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderActiveInsets.y)
    }
    
    // MARK: - Overrides
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //  return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
        return CGRect(x: bounds.origin.x + textFieldInsets.left, y: bounds.origin.y + textFieldInsets.top, width: bounds.size.width - (textFieldInsets.left + textFieldInsets.right), height: bounds.size.height)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        //  return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
        return CGRect(x: bounds.origin.x + textFieldInsets.left, y: bounds.origin.y + textFieldInsets.top, width: bounds.size.width - (textFieldInsets.left + textFieldInsets.right), height: bounds.size.height)
    }
    
    // MARK: - TextFieldEffects
    open override func drawViewsForRect(_ rect: CGRect) {
        let frame                                   = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame                      = frame.insetBy(dx: self.textRect(forBounds: self.bounds).origin.x, dy: placeholderActiveInsets.y)
        placeholderLabel.font                       = smallerFontFromFont(font!)
        
        errorLabel.frame                            = frame.insetBy(dx: errorInsets.x, dy: errorInsets.y)
        errorLabel.font                             = smallerFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        updateError()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        
        addSubview(placeholderLabel)
        addSubview(errorLabel)
    }
    
    open override func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({ [weak self] in
                self?.placeholderLabel.frame.origin = CGPoint(x: self?.textRect(forBounds: self?.bounds ?? CGRect.zero).origin.x ?? 0, y: self?.placeholderLabel.frame.origin.y ?? 0)
                self?.placeholderLabel.alpha        = 0
            }), completion: { [weak self] _ in
                self?.animationCompletionHandler?(.textEntry)
            })
        }
    
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin               = activePlaceholderPoint

        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.placeholderLabel.alpha            = 1.0
        })

        activeBorderLayer.frame                     = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    open override func animateViewsForTextDisplay() {
        if let text = text, text.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({ [weak self] in
                self?.layoutPlaceholderInTextRect()
                self?.placeholderLabel.alpha        = 1
            }), completion: { [weak self] _ in
                self?.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame                 = self.rectForBorder(self.borderThickness.active, isFilled: false)
            inactiveBorderLayer.frame               = self.rectForBorder(self.borderThickness.inactive, isFilled: true)
        }
    }
    
    open override func animateViewsForErrorDisplay() {
        _borderInactiveColor                        = errorColor
        _borderActiveColor                          = errorColor
        inactiveBorderLayer.backgroundColor         = _borderInactiveColor?.cgColor
        activeBorderLayer.backgroundColor           = _borderActiveColor?.cgColor
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({ [weak self] in
            self?.errorLabel.frame.origin           = self?.activeErrorPoint ?? CGPoint.zero
            self?.errorLabel.alpha                  = 1.0
        }), completion: nil)
    }
    
    open override func animateViewsForErrorRemoving() {
        _borderInactiveColor                        = borderInactiveColor
        _borderActiveColor                          = borderActiveColor
        inactiveBorderLayer.backgroundColor         = _borderInactiveColor?.cgColor
        activeBorderLayer.backgroundColor           = _borderActiveColor?.cgColor
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({ [weak self] in
            self?.errorLabel.frame.origin           = self?.inactiveErrorPoint ?? CGPoint.zero
            self?.errorLabel.alpha                  = 0.0
        }), completion: nil)
    }
    
    open override func updateBorder() {
        inactiveBorderLayer.frame                   = rectForBorder(borderThickness.inactive, isFilled: !isFirstResponder)
        activeBorderLayer.frame                     = rectForBorder(borderThickness.active, isFilled: isFirstResponder)
        
        _borderInactiveColor                        = borderInactiveColor
        _borderActiveColor                          = isEnabled ? borderActiveColor : borderInactiveColor
        inactiveBorderLayer.backgroundColor         = _borderInactiveColor?.cgColor
        activeBorderLayer.backgroundColor           = _borderActiveColor?.cgColor
    }
    
}
