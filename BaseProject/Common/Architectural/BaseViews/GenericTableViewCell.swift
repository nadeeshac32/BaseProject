//
//  GenericTableViewCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

/// Base class for Table view cells that doesn't have xib files
open class GenericTableViewCell: UITableViewCell, ConfigurableView {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    open func configureView() {}
}


