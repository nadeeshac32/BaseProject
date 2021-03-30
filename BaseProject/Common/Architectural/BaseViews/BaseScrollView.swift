//
//  BaseScrollView.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

/// Base classing this class will enable scroll view to hide keyboard when it's tapped.
/// This class is used in BaseFormVC as well. Check that class for more info.
class BaseScrollView: UIScrollView {

    override func awakeFromNib() {
        let tap         = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        self.addGestureRecognizer(tap)
        self.bounces    = false
    }

    @objc func hideKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        self.endEditing(true)
    }
    
}


//class BaseScrollView: UIScrollView, UIGestureRecognizerDelegate {
//
//    override func awakeFromNib() {
//        let tap                     = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
//        tap.cancelsTouchesInView    = false
//        self.addGestureRecognizer(tap)
//        self.bounces                = false
//    }
//
//    @objc func hideKeyboard(_ sender: UITapGestureRecognizer? = nil) {
//        self.endEditing(true)
//    }
//    
//}
