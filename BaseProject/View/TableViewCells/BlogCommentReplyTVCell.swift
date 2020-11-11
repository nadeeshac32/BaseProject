//
//  BlogCommentReplyTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/11/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit


class BlogCommentReplyTVCell: BaseTVCell<BlogChildComment> {

    @IBOutlet weak var profileImageVw: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var hightlighterVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                     = .none
        self.backgroundColor                    = .white
        //  self.hideSeparator()
        hightlighterVw.layer.cornerRadius       = 2
        profileImageVw.layer.cornerRadius       = self.profileImageVw.frame.width / 2
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        usernameLbl.text                        = ""
        commentLbl.text                         = ""
        dateLbl.text                            = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        usernameLbl.text                        = ""
        commentLbl.text                         = ""
        dateLbl.text                            = ""
    }
    
    override func configureCell(item: BlogChildComment, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        profileImageVw.setImageWith(imagePath: item.owner?.imageUrl ?? "", completion: nil)
        usernameLbl.text                        = item.owner?.name ?? ""
        dateLbl.text                            = item.createdDate?.displayDate ?? ""
        item._comment.bind(to: commentLbl.rx.text).disposed(by: disposeBag)
    }
}
