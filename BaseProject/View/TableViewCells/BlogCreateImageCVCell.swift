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
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    
    var blogCreateImageGridDelegate: BlogCreateImageCVCellDelegate?
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
        self.selectedImageView.layer.cornerRadius   = 5
        self.removeBtn.setImage(UIImage(named: "icon_cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.removeBtn.isHidden                     = true
        self.selectedImageView.image                = UIImage(named: AppConfig.si.default_ImageName)
        self.addShadow()
    }
        
    override func configureCell(item: BlogContent, section: Int, row: Int, selectable: Bool) {
        super.configureCell(item: item, section: section, row: row, selectable: selectable)
        removeBtn.isHidden                          = !item.isRemovable
        if item.isRemovable, let image = item.image {
            selectedImageView.image                 = image
        } else if let imagePath = item.mediaUrl {
            // TODO: - Chech whether the mediaUrl is for an image
            selectedImageView.setImageWith(imagePath: imagePath, completion: nil)
        }
    }
    @IBAction func removeBtnTapped(_ sender: Any) {
        guard let item = self.item, item.isRemovable == true, let section = section, let row = row else { return }
        blogCreateImageGridDelegate?.removeContent(item: item, section: section, row: row)
    }
    
}
