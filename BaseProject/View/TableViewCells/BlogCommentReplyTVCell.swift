//
//  BlogCommentReplyTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/11/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import DropDown

protocol BlogCommentReplyTVCellDelegate: class {
    func replyCommentEdit(comment: String, commentId: String)
    func replyCommentDelete(commentId: String)
}

class BlogCommentReplyTVCell: BaseTVCell<BlogChildComment> {

    @IBOutlet weak var profileImageVw: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var hightlighterVw: UIView!
    
    let dropDown                                = DropDown()
    
    weak var replyCommentCellDelegate           : BlogCommentReplyTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                     = .none
        self.backgroundColor                    = .white
        hightlighterVw.layer.cornerRadius       = 2
        profileImageVw.layer.cornerRadius       = self.profileImageVw.frame.width / 2
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        usernameLbl.text                        = ""
        commentLbl.text                         = ""
        dateLbl.text                            = ""
        
        dropDown.anchorView                     = moreBtn
        dropDown.direction                      = .bottom
        dropDown.width                          = 100
        dropDown.bottomOffset                   = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource                     = ["Edit", "Delete"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                if let comment = self.item?.comment, let id = self.item?.id {
                    self.replyCommentCellDelegate?.replyCommentEdit(comment: comment, commentId: id)
                }
            } else if index == 1 {
                if let id = self.item?.id {
                    self.replyCommentCellDelegate?.replyCommentDelete(commentId: id)
                }
            }
        }
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
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        dropDown.show()
    }
}
