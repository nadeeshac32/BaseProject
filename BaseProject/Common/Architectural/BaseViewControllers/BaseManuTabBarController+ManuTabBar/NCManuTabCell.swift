//
//  NCManuTabCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class NCManuTabCell: UICollectionViewCell {
    
    let titleLabel      : UILabel = {
        let lbl         = UILabel()
        return lbl
    }()
    
    var titleColor      : UIColor = AppConfig.si.colorPrimary {
        didSet {
            updateTitle()
        }
    }
    var highLighterColor: UIColor = AppConfig.si.colorPrimary {
        didSet {
            updateIndicator()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.30) { [weak self] in
                self?.updateIndicator()
                self?.updateTitle()
                self?.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment                    = .center
        self.titleLabel.textColor                   = AppConfig.si.colorPrimary
        self.titleLabel.font                        = MainFont.medium.with(size: 16)
        addSubview(titleLabel)
        setupLabelConstraints()
        setupIndicatorView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text                             = ""
    }
   
    func setupLabelConstraints() {
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: titleLabel)
        
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func setupIndicatorView() { }
    
    func updateTitle() { }
    
    func updateIndicator() { }
    
}

