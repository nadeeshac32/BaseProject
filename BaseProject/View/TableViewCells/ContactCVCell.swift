//
//  ContactCVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class ContactCVCell: BaseCVCell<Customer> {

    @IBOutlet weak var containerVw          : UIView!
    @IBOutlet weak var imageVw              : UIImageView!
    @IBOutlet weak var nameLbl              : UILabel!
    @IBOutlet weak var numberLbl            : UILabel!
    @IBOutlet weak var checkBoxBtn          : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selectionStyle                 = .none
        self.backgroundColor                = .clear
        self.addShadow()
        self.containerVw.layer.cornerRadius = 3
        self.imageVw.layer.cornerRadius     = self.imageVw.frame.width / 2
        self.imageVw.contentMode            = .scaleAspectFill
        self.checkBoxBtn?.isHidden          = true
        self.checkBoxBtn?.setImage(#imageLiteral(resourceName: "icon_checkbox_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    override func configureCell(item: Customer, section: Int, row: Int, selectable: Bool) {
        super.configureCell(item: item, section: section, row: row, selectable: selectable)
        
        disposeBag.insert([
            item._name.asObservable().bind(to: nameLbl.rx.text),
            item.mobileNo!._displayNumber.asObservable().bind(to: numberLbl.rx.text),
            item._imageUrl.subscribe(onNext: { [weak self] (imageUrl) in
                self?.imageVw?.setImageWith(imagePath: imageUrl, defaultImage: item.editedValues()?.image, completion: nil)
            })
        ])
    }
    
    
    override func setForMultiSelectMode(enableMultiSelect: Bool) {
        self.checkBoxBtn?.isHidden      = !enableMultiSelect
    }
    
    override func multiSelectHighlighted(highlighted: Bool) {
        if highlighted == true {
            self.checkBoxBtn?.setImage(#imageLiteral(resourceName: "icon_checkbox_checked").withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            self.checkBoxBtn?.setImage(#imageLiteral(resourceName: "icon_checkbox_unchecked").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
}
