//
//  BlogCreateImageCVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogCreateImageCVCell: BaseCVCell<BlogContent> {
    
    override func awakeFromNib() {
            super.awakeFromNib()
            self.backgroundColor                = .clear
            self.addShadow()
            
        }
        
        override func configureCell(item: BlogContent, section: Int, row: Int, selectable: Bool) {
            super.configureCell(item: item, section: section, row: row, selectable: selectable)
        }
}
