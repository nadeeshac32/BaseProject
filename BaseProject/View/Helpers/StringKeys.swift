//
//  StringKeys.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

// MARK: - UserDefault keys
public enum Defaults: String {
    case userSignedIn
    case userGuideShown
    case reportDownloadDate
}

// MARK: - Storyboard keys
public enum Storyboards: String {
    case main           = "Main"
    case signup         = "Signup"
    case common         = "Common"
    case launchScreen   = "LaunchScreen"
    case example        = "Example"
}

// MARK: - FormValidationError
public enum FormValidationError: String {
    case loginButtonDesablOnFirstLoad = "loginButtonDesablOnFirstLoad"
}
