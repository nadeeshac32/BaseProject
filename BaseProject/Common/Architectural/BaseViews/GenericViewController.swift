//
//  GenericViewController.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

/// Generic base class for viewcontrollers that doesn't have xib files
open class GenericViewController<View: GenericView>: UIViewController {
    open var contentView: View {
        return view as! View
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func loadView() {
        view = View(frame: UIScreen.main.bounds)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    open func configureView() {}
}

