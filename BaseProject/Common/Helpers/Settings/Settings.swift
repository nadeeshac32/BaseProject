//
//  Settings.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

enum Language: String {
    case English    = "English"
    case Bahasa     = "Bahasa"
    
    func getButtonWidth() -> CGFloat {
        switch self {
        case .English:
            return 90
        case .Bahasa:
            return 85
        }
    }
    
    func getIndex() -> Int {
        switch self {
        case .English:
            return 1
        case .Bahasa:
            return 0
        }
    }
    
    func getValue() -> String {
        switch self {
        case .English:
            return "en"
        case .Bahasa:
            return "id"
        }
    }
}


/// Settings class is used to hold application settings.
/// Here you can setup setting variables as you want  so that variables and values can be accessed through out the app.
class Settings: NSObject {
    
    static let si                       = Settings()
    
    // two examples of setting up a Setting
    var appLanguage                     : Setting?
    var notificationsDueInDays          : Setting?
    
    var settingsArray                   : [Setting] = []
    
    private override init() {
        // Setup app language setting
        var valuesLanguage              : [SettingValue] = []
        valuesLanguage.append(SettingValue(index: 0, text: Language.Bahasa.rawValue, value: Float(Language.Bahasa.getIndex()), stringValue: Language.Bahasa.getValue()))
        valuesLanguage.append(SettingValue(index: 1, text: Language.English.rawValue, value: Float(Language.English.getIndex()), stringValue: Language.English.getValue()))
        appLanguage                     = Setting(keyWord: "appLanguage",
                                                  type: SettingType.general,
                                                  title: "App Language".localized(),
                                                  desc: "Select language".localized(),
                                                  valueSelectionOption: SettingsValueSelectionOption.dropDown,
                                                  values: valuesLanguage,
                                                  defaultValueIndex: Language.English.getIndex(),
                                                  defaultStringValue: Language.English.getValue()) { (settingValue) in
                                                                                                     if let lang = settingValue?.stringValue {
                                                                                                        Bundle.set(languageCode: lang)
                                                                                                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settings.language.changed"), object: nil, userInfo: nil)
                                                                                                     }
                                                                                                 }
        if let selectedLanguage = appLanguage?.selectedValue?.stringValue {
            Bundle.set(languageCode: selectedLanguage)
        }
        settingsArray.append(appLanguage!)
        
        
        // Setup due in days setting
        var valuesDueInDays : [SettingValue] = []
        valuesDueInDays.append(SettingValue(index: 0, text: "7 days", value: 7, stringValue: nil))
        notificationsDueInDays           = Setting(keyWord: "notificationsDueInDays",
                                                  type: .general,
                                                  title: "Reminder Notifications".localized(),
                                                  desc: "Due in Days".localized(),
                                                  valueSelectionOption: SettingsValueSelectionOption.counter,
                                                  values: valuesDueInDays,
                                                  defaultValueIndex: 0,
                                                  defaultStringValue: "7",
                                                  defaultText: "")
        settingsArray.append(notificationsDueInDays!)
    }
    
    
    /// You can reset settings to default values by calling this method.
    func removeSavedSettings() {
        for setting in settingsArray {
            setting.resetSetting()
        }
    }
    
    
    /// You can categorise settings when you setup a setting.
    /// - Returns: Array of Setting categories that you have setup
    func getSettingTypes() -> [SettingType] {
        var settingTypes: [SettingType]    = []
        for setting in settingsArray {
            if !(settingTypes.contains(setting.type)) {
                settingTypes.append(setting.type)
            }
        }
        return settingTypes
    }
    
    
    /// You can get Array of Settings for specific category.
    /// - Parameter settingType: SettingCategory that you want to filter with
    /// - Returns: Array of Settings for the desired SettingCategory
    func getSettingsFor(settingType: SettingType) -> [Setting] {
        var settings: [Setting]         = []
        for setting in settingsArray {
            if setting.type == settingType {
                settings.append(setting)
            }
        }
        return settings
    }
    
}

private var bundleKey: UInt8 = 0
final class BundleExtension: Bundle {
     override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static let once: Void = {
        object_setClass(Bundle.main, type(of: BundleExtension()))
    }()
    
    /// Changing app language
    /// - Note: Once you call this method, language bundle that the app is using will change accordingly. Newly rendering UI will appear according to the correct language. But which are already renders needs to be redrawn to appear the language change.
    /// - Parameter languageCode: language code of the language that you want to change into
    static func set(languageCode: String) {
        Bundle.once

        let isLanguageRTL = Locale.characterDirection(forLanguage: languageCode) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight

        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([languageCode],forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            print("Setting.swift: Failed to get a bundle path languageCode: \(languageCode)\nLanguage bundles are not set yet")
            return
        }

        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
