//
//  SwivelManuTabCell_Underline.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/17/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

class SwivelManuTabCell_Underline: SwivelManuTabCell {
    override func setupLabelConstraints() {
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: titleLabel)
        
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    var indicatorView   : UIView?
    override func setupIndicatorView() {
        indicatorView = UIView()
        addSubview(indicatorView!)
        
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: indicatorView!)
        addConstraintsWithFormatString(formate: "V:[v0(3)]|", views: indicatorView!)
    }
    
    override func updateTitle() {
        self.titleLabel.textColor                   = self.titleColor
        self.titleLabel.font                        = self.isSelected == true ? MainFont.bold.with(size: 16) : MainFont.medium.with(size: 16)
    }
    
    override func updateIndicator() {
        self.indicatorView?.backgroundColor         = self.isSelected == true ? self.highLighterColor : UIColor.clear
    }
}
