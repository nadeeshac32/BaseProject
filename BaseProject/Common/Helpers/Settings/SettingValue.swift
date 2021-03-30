//
//  SettingValue.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation

class SettingValue: NSObject {
    
    let index           : Int!
    let text            : String!
    let value           : Float!
    let stringValue     : String!
    
    
    /// Initialiser of Setting Value
    /// - Parameters:
    ///   - index: Index of the SettingValue which it's gonna be in it's Setting's values array.
    ///   - text: Display value of Setting Value
    ///   - value: Floating value of Setting value
    ///   - stringValue: String value of Setting value
    init(index: Int, text: String, value: Float, stringValue: String?) {
        self.index          = index
        self.text           = text
        self.value          = value
        self.stringValue    = stringValue ?? "\(value)"
    }
    
    func getBoolValue() -> Bool {
        if value == 0 {
            return false
        } else {
            return true
        }
    }
    
}
