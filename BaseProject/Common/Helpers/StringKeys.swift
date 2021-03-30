//
//  StringKeys.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

// MARK: - UserDefault keys
public enum Defaults: String {
    case userSignedIn
    case userGuideShown
}

// MARK: - Storyboard keys
public enum Storyboards: String {
    case main           = "Main"
    case signup         = "Signup"
    case common         = "Common"
    case launchScreen   = "LaunchScreen"
    case example        = "Example"
    case profile        = "Profile"
}

// MARK: - FormValidationError
public enum FormValidationError: String {
    case loginButtonDesablOnFirstLoad = "loginButtonDesablOnFirstLoad"
}
