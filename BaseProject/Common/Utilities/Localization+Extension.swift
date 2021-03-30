//
//  Localization+Extension.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//


import Foundation

enum LocalizedFile: String {
    case Localizable    = "Localizable"
    case Common         = "CommonLocalizable"
    case Registration   = "RegistrationLocalizable"
    case Home           = "HomeLocalizable"
    case Profile        = "ProfileLocalizable"
    case TableViewCell  = "TableViewCellLocalizable"
}

extension String {
    func localized() -> String {
        switch self {
            case "Ok"                               : return NSLocalizedString("Ok", tableName: "Localizable" , comment: "Ok button title")
            default: return self
        }
    }

    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
    
}
