//
//  SwivelTabBarItem.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

/// This will be used as UITabBarItems within  SwivelTabBar
class SwivelTabBarItem: UIButton {
    
    var itemHeight: CGFloat             = 0
    var lock                            = false
    var viewController                  : UIViewController!
    var isForcused                      = false {
        didSet {
            if isForcused {
                iconImageView.image     = selectedIcon ?? icon
            } else {
                iconImageView.image     = icon
            }
        }
    }
    var color: UIColor                  = UIColor.lightGray {
        didSet {
            guard lock == false else { return }
            if imageUrl == "" {
                iconImageView.tintColor = color
            }
            textLabel.textColor         = color
        }
    }
    
    private let iconImageView           = SwivelUIMaker.makeImageView(contentMode: .scaleAspectFit)
    private let textLabel               = SwivelUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 11), color: .black, alignment: .center)
    private var imageUrl                = ""
    private var icon                    : UIImage!
    private var selectedIcon            : UIImage!
    
    convenience init(icon: UIImage, selectedIcon: UIImage? = nil, title: String, font: UIFont = UIFont.systemFont(ofSize: 11), viewController: UIViewController!, lock: Bool = false) {
        self.init()
        translatesAutoresizingMaskIntoConstraints   = false
        self.lock                                   = lock
        self.icon                                   = icon
        self.selectedIcon                           = selectedIcon ?? self.icon
        if !self.lock {
            self.icon                               = self.icon.withRenderingMode(.alwaysTemplate)
            self.selectedIcon                       = self.selectedIcon.withRenderingMode(.alwaysTemplate)
        } else {
            self.icon                               = self.icon.withRenderingMode(.alwaysOriginal)
            self.selectedIcon                       = self.selectedIcon.withRenderingMode(.alwaysOriginal)
        }
        self.iconImageView.image                    = self.icon
        self.textLabel.text                         = title
        self.textLabel.font                         = font
        self.viewController                         = viewController
        setupView()
    }

    private func setupView() {
        removeAllSubViews()
        addSubviews(views: iconImageView, textLabel)
        iconImageView.top(toView: self, space: 7)
        iconImageView.centerX(toView: self)
        iconImageView.square()

        let iconBottomConstant: CGFloat = textLabel.text == "" ? -15 : -38
        iconImageView.bottom(toView: self, space: iconBottomConstant)

        textLabel.bottom(toView: self, space: -20)
        textLabel.centerX(toView: self)
    }
    
    public func setImageWithUrl(imageUrl: String) {
        self.imageUrl                               = imageUrl
        if imageUrl != "" {
            self.textLabel.removeFromSuperview()
            self.iconImageView.removeFromSuperview()
            addSubview(iconImageView)
            iconImageView.setImageWith(imagePath: imageUrl, ignoreCache: true, completion: nil)
            iconImageView.setImageWith(imagePath: imageUrl, ignoreCache: true) { [weak self] (image) in
                guard let `self` = self else { return }
                self.icon                           = image?.withRenderingMode(.alwaysOriginal) ?? self.icon
                self.selectedIcon                   = image?.withRenderingMode(.alwaysOriginal)
            }
            iconImageView.contentMode               = .scaleAspectFill
            iconImageView.top(toView: self, space: 12)
            iconImageView.centerX(toView: self)
            iconImageView.bottom(toView: self, space: -25)
            iconImageView.square()
            iconImageView.layer.cornerRadius        = (self.frame.height - (7 + 30)) / 2
        }
    }
}
