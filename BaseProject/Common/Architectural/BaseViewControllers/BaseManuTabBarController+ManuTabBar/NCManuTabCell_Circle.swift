//
//  NCManuTabCell_Circle.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/17/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit

class NCManuTabCell_Circle: NCManuTabCell {
    override func setupLabelConstraints() {
        addConstraintsWithFormatString(formate: "H:|-[v0]-|", views: titleLabel)
        addConstraintsWithFormatString(formate: "V:|-8-[v0]-8-|", views: titleLabel)
        
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override func setupIndicatorView() {
        titleLabel.addBoarder(width: 1, cornerRadius: 17, color: highLighterColor)
    }
    
    override func updateTitle() {
        self.titleLabel.textColor                   = self.isSelected == true ? .white : self.titleColor
        self.titleLabel.font                        = self.isSelected == true ? MainFont.bold.with(size: 16) : MainFont.medium.with(size: 16)
    }
    
    override func updateIndicator() {
        self.titleLabel.backgroundColor             = self.isSelected == true ? self.highLighterColor : UIColor.clear
    }
}
