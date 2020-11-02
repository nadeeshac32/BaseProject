//
//  BlogCreateImageCVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogCreateImageCVCell: BaseCVCell<Blog> {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor                        = .clear
        self.addShadow()
        self.profileImageView.layer.cornerRadius    = self.profileImageView.frame.width / 2
        self.usernameLbl.text                       = ""
    }
        
    override func configureCell(item: Blog, section: Int, row: Int, selectable: Bool) {
        super.configureCell(item: item, section: section, row: row, selectable: selectable)
        profileImageView.image                      = UIImage(named: item.owner?.imageUrl ?? "")
        usernameLbl.text                            = item.owner?.name
    }
}
