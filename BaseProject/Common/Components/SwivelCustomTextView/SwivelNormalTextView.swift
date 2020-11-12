//
//  SwivelNormalTextView.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/28/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class SwivelNormalTextView: UITextView {
    
    // MARK: - public
    public var placeHolderText: String?     = "Write something.."
    
    public lazy var placeHolderLabel: UILabel! = {
        let placeHolderLabel                = UILabel(frame: .zero)
        placeHolderLabel.numberOfLines      = 0
        placeHolderLabel.backgroundColor    = .clear
        placeHolderLabel.alpha              = 0.5
        return placeHolderLabel
    }()
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        enableNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        enableNotifications()
    }
    
    // MARK: - Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addBoarder(width: 1, cornerRadius: 5, color: .lightGray)
        backgroundColor                     = .white
        textContainerInset                  = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 8)
        returnKeyType                       = .done
        addSubview(placeHolderLabel)
        placeHolderLabel.frame              = CGRect(x: 8, y: 8, width: self.bounds.size.width - 16, height: 15)
        placeHolderLabel.textColor          = textColor
        placeHolderLabel.font               = font
        placeHolderLabel.text               = placeHolderText
        bringSubviewToFront(placeHolderLabel)
        updatePlaceHolderLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderLabel.frame              = CGRect(x: 8, y: 8, width: self.bounds.size.width - 16, height: 15)
        placeHolderLabel.sizeToFit()
    }
    
    private func enableNotifications() {
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.textDidChangeNotification(notification)
        }
    }
    
    @objc func textDidChangeNotification(_ notify: Notification) {
        guard self == notify.object as? UITextView else { return }
        guard placeHolderText != nil else { return }
        
        updatePlaceHolderLabel()
    }
    
    func updatePlaceHolderLabel() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.placeHolderLabel.alpha    = (self?.text.count == 0) ? 0.5 : 0
        }, completion: nil)
        self.layer.borderColor              = (self.text.count == 0) ? UIColor.lightGray.cgColor : AppConfig.si.colorPrimary.cgColor
        self.layer.borderWidth              = (self.text.count == 0) ? 1 : 2
    }
}
