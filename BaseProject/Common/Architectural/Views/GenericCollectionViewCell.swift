//
//  GenericCollectionViewCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

/// Base class for Collection view cells that doesn't have xib files
open class GenericCollectionViewCell: UICollectionViewCell, ConfigurableView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public required init() {
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    open func configureView() {}
}
