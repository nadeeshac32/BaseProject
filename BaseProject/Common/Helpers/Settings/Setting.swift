//
//  Setting.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit


/// Setting category
/// Currently we have only one setting category
public enum SettingType: String {

    /// All the generalise settings will define under here
    case general    = "General"
    
    func getIconImgName() -> String {
        switch self {
        case .general:
            return "info_icon"
        }
    }
    
}

/// Setting value selection type
public enum SettingsValueSelectionOption: String {
    
    /// Setting is a boolean flag
    case toggle     = "Toggle"
    
    /// Setting value can be selected from an array
    case dropDown   = "DropDown"
    
    /// Setting value is a counter
    case counter    = "Counter"
}

class Setting: NSObject {
    
    let defaults                    = UserDefaults.standard
    
    /// keyword that used save in userdefauls
    var keyWord                     : String!
    
    /// Setting cartegory
    var type                        : SettingType!
    
    /// Setting title that can be displayed in UI
    var title                       : String!
    
    /// Setting description that can be displayed in UI
    var desc                        : String!
    
    /// Setting value selection type
    var valueSelectionOption        : SettingsValueSelectionOption!
    
    /// Setting value(s) as an array
    /// For a toggle setting this array contains only two values
    /// For a counter setting this array contains only one value
    var values                      : [SettingValue]!
    
    /// Selected setting value
    var selectedValue               : SettingValue? {
        didSet {
            if valueSelectionOption == SettingsValueSelectionOption.dropDown {
                self.desc           = selectedValue?.text ?? ""
            }
            self.action?(selectedValue)
        }
    }
    
    /// Index of the default value in the values array
    var defaultValueIndex           : Int!
    
    /// Call block that will execute each time the SelectedValue changes it's value
    var action                      : ((_ settingValue: SettingValue?) -> Void)?
    
    
    /// Initialiser of Setting
    /// - Parameters:
    ///   - keyWord: keyword that used save in userdefauls
    ///   - type: Setting cartegory
    ///   - title: Setting title that can be displayed in UI
    ///   - desc: Setting description that can be displayed in UI
    ///   - valueSelectionOption: Setting value selection type
    ///   - values: Setting value(s) as an array
    ///      1. For a dropdown setting this array contains multiple values
    ///      1. For a toggle setting this array contains only two values
    ///      1. For a counter setting this array contains only one value
    ///   - defaultValueIndex: Index of the default SettingValue in the values array
    ///   - defaultStringValue: Value of the default SettingValue in the values array
    ///   - defaultText: Text of the default SettingValue in the values array
    ///   - action: Call block that will execute each time the SelectedValue changes it's value
    init(keyWord: String, type: SettingType, title: String, desc: String, valueSelectionOption: SettingsValueSelectionOption, values: [SettingValue], defaultValueIndex: Int, defaultStringValue: String, defaultText: String = "", action: ((_ settingValue: SettingValue?) -> Void)? = nil) {
        super.init()
        self.keyWord                = keyWord
        self.type                   = type
        self.title                  = title
        self.desc                   = desc
        self.valueSelectionOption   = valueSelectionOption
        self.values                 = values
        self.defaultValueIndex      = defaultValueIndex
        if valueSelectionOption == .counter {
            self.readSettingDynemicValue(keyWord: keyWord, defaultValueIndex: defaultValueIndex, defaultText: defaultText, stringValue: defaultStringValue)
        } else {
            self.readSetting(keyWord: keyWord, defaultValueIndex: defaultValueIndex)
        }
        self.action                 = action
    }
        
    internal func readSettingDynemicValue(keyWord: String, defaultValueIndex: Int, defaultText: String, stringValue: String) {
        var savedSettingValueForKeyword: Float!
        if defaults.object(forKey: keyWord) != nil {
            savedSettingValueForKeyword = defaults.float(forKey: keyWord)
            self.selectedValue      = SettingValue(index: -1, text: defaultText, value: savedSettingValueForKeyword, stringValue: stringValue)
        } else if values.count > defaultValueIndex {
            let defaultValue        = values[defaultValueIndex]
            self.selectedValue      = SettingValue(index: -1, text: defaultText, value: defaultValue.value, stringValue: stringValue)
        }
    }
    
    internal func readSetting(keyWord: String, defaultValueIndex: Int) {
        var savedSettingIndexForKeyword: Int!
        if defaults.object(forKey: keyWord) != nil {
            savedSettingIndexForKeyword = defaults.integer(forKey: keyWord)
        } else {
            savedSettingIndexForKeyword = defaultValueIndex
        }
        
        if savedSettingIndexForKeyword >= 0, savedSettingIndexForKeyword < values.count {
            self.selectedValue      = values[savedSettingIndexForKeyword]
        }
    }
    
    
    /// Save a setting with the Index of the SettingValue in it's values array
    /// - Parameter index: Index of the SettingValue
    func saveSettingValueIndex(index: Int) {
        defaults.set(index, forKey: self.keyWord)
        if index >= 0, index < values.count {
            self.selectedValue      = values[index]
        }
    }
    
    
    /// Save a flag setting with boolean value
    /// - Parameter boolValue: Boolean value that need to be saved
    func saveSettingValueWithBool(boolValue: Bool) {
        let index                   = boolValue ? 1 : 0
        defaults.set(index, forKey: self.keyWord)
        if index >= 0, index < values.count {
            self.selectedValue      = values[index]
        }
    }
    
    
    /// Save a counter setting with Dynemic value
    /// - Parameter value: Value that needs to be saved
    func saveDynemicSettingValue(value: Float) {
        defaults.set(value, forKey: self.keyWord)
        self.selectedValue          = SettingValue(index: -1, text: self.selectedValue?.text ?? "", value: value, stringValue: self.selectedValue?.stringValue ?? "")
    }
    
    
    /// Reset the SettingValue to it's default value
    func resetSetting() {
        if valueSelectionOption == .counter {
            if values.count > defaultValueIndex {
                let defaultValue        = values[defaultValueIndex]
                saveDynemicSettingValue(value: defaultValue.value)
            }
        } else {
            saveSettingValueIndex(index: defaultValueIndex)
        }
    }
    
}
