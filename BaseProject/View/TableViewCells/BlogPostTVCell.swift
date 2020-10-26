//
//  BlogPostTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogPostTVCell: BaseTVCell<BlogPost> {
    
    @IBOutlet weak var profileImageVw           : UIImageView!
    @IBOutlet weak var userNameLbl              : UILabel!
    @IBOutlet weak var timeAgoLbl               : UILabel!
    @IBOutlet weak var captionLbl               : UILabel!
    @IBOutlet weak var postImageVw              : UIImageView!
    @IBOutlet weak var postStatusLbl            : UILabel!
    @IBOutlet weak var likeBtn                  : UIButton!
    @IBOutlet weak var commentBtn               : UIButton!
    @IBOutlet weak var shareBtn                 : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                     = .none
        self.backgroundColor                    = .white
        self.hideSeparator()
        self.profileImageVw.layer.cornerRadius  = self.profileImageVw.frame.width / 2
        likeBtn.setImage(#imageLiteral(resourceName: "icon_like").withRenderingMode(.alwaysTemplate), for: .normal)
        commentBtn.setImage(#imageLiteral(resourceName: "icon_comment").withRenderingMode(.alwaysTemplate), for: .normal)
        shareBtn.setImage(#imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    override func configureCell(item: BlogPost, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        profileImageVw.image                    = item.createdBy?.profileImage
        userNameLbl.text                        = item.createdBy?.username
        timeAgoLbl.text                         = item.timeAgo
        captionLbl.text                         = item.caption
        postImageVw.image                       = item.image
        postStatusLbl.text                      = "\(item.numberOfLikes!) Likes     \(item.numberOfComments!) Comments     \(item.numberOfShares!) Shares"
    }
    
}
