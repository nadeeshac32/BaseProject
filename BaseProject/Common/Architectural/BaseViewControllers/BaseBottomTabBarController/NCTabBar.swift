//
//  NCTabBar.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit

/// Subclass of UITabBar which will be used inside the NCTabBarController
class NCTabBar: UITabBar {
    
    var tabItems                    = [NCTabBarItem]()
    convenience init(items: [NCTabBarItem]) {
        self.init()
        tabItems                    = items
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    override var tintColor: UIColor! {
        didSet {
            for item in tabItems {
                item.color          = tintColor
            }
        }
    }
    
    func setupView() {
        if tabItems.count == 0 { return }
        let line                    = NCUIMaker.makeLine(color: .gray, height: 0.5)
        self.barTintColor           = #colorLiteral(red: 0.9725311399, green: 0.9695178866, blue: 0.9729015231, alpha: 1)
        addSubviews(views: line)
        line.horizontal(toView: self)
        line.top(toView: self)

        var horizontalConstraints   = "H:|"
        let itemWidth: CGFloat      = screenWidth / CGFloat(tabItems.count)
        for i in 0 ..< tabItems.count {
            let item                = tabItems[i]
            addSubviews(views: item)
            if item.itemHeight == 0 {
                item.vertical(toView: self)
            }
            else {
                item.bottom(toView: self)
                item.height(item.itemHeight)
            }
            item.width(itemWidth)
            horizontalConstraints  += String(format: "[v%d]", i)
            if item.lock == false {
                item.color = tintColor
            }
        }

        horizontalConstraints      += "|"
        addConstraints(withFormat: horizontalConstraints, arrayOf: tabItems)
    }
}

extension UITabBar {

    // Modify the height.
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 64.0)
    }
}
