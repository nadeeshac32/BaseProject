//
//  BlogTempTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/30/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogTempTVCell: BaseTVCell<Blog> {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                         = .none
        self.backgroundColor                        = .white
        self.hideSeparator()
        self.profileImageView.layer.cornerRadius    = self.profileImageView.frame.width / 2
        self.usernameLbl.text                       = ""
    }
    
    override func configureCell(item: Blog, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        profileImageView.image                      = UIImage(named: item.owner?.imageUrl ?? "")
        usernameLbl.text                            = item.owner?.name
    }
    
    
    
}
