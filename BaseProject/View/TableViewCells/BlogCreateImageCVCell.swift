//
//  BlogCreateImageCVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

protocol BlogCreateImageCVCellDelegate: BaseCVCellDelegate {
    func removeContent(item: BlogContent, section: Int, row: Int)
}

class BlogCreateImageCVCell: BaseCVCell<BlogContent> {
    
    @IBOutlet weak var multimediaVw: SwivelMultimediaView!
    @IBOutlet weak var removeBtn: UIButton!
    
    deinit {
        print("BlogCreateImageCVCell deinit")
    }
    
    weak var blogCreateImageGridDelegate: BlogCreateImageCVCellDelegate?
    override weak var delegate: BaseCVCellDelegate? {
        get {
            return blogCreateImageGridDelegate
        }
        set {
            if let newViewModel = newValue as? BlogCreateImageCVCellDelegate {
                blogCreateImageGridDelegate         = newViewModel
            } else {
                print("incorrect BaseVM type for BaseVC")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor                        = .clear
        self.multimediaVw.layer.cornerRadius        = 5
        self.removeBtn.setImage(UIImage(named: "icon_cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.removeBtn.isHidden                     = true
        self.addShadow()
    }
        
    override func configureCell(item: BlogContent, section: Int, row: Int, selectable: Bool) {
        super.configureCell(item: item, section: section, row: row, selectable: selectable)
        removeBtn.isHidden                          = !item.isRemovable
        if item.isRemovable, let asset = item.asset {
            multimediaVw.asset                      = asset
        } else if let mediaUrl = item.mediaUrl {
            multimediaVw.assetUrl                   = mediaUrl
        }
    }
    @IBAction func removeBtnTapped(_ sender: Any) {
        guard let item = self.item, item.isRemovable == true, let section = section, let row = row else { return }
        blogCreateImageGridDelegate?.removeContent(item: item, section: section, row: row)
    }
    
    override func prepareForReuse() {
        multimediaVw.resetView()
    }
    
    
}
