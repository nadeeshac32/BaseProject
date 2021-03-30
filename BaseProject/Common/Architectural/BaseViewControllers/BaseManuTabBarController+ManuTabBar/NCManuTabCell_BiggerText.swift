//
//  NCManuTabCell_BiggerText.swift
//  Base Project
//
//  Created by Nadeesha Lakmal on 12/13/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

class NCManuTabCell_BiggerText: NCManuTabCell {
    override func updateTitle() {
        self.titleLabel.textColor                   = self.titleColor
        self.titleLabel.font                        = self.isSelected == true ? MainFont.bold.with(size: 20) : MainFont.medium.with(size: 16)
    }
}
