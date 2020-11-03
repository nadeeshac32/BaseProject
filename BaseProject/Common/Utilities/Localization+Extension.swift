//
//  Localization+Extension.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//


import Foundation

enum LocalizedFile: String {
    case Localizable    = "Localizable"
    case Common         = "CommonLocalizable"
    case Registration   = "RegistrationLocalizable"
    case Home           = "HomeLocalizable"
    case Customers      = "CustomersLocalizable"
    case Transactions   = "TransactionsLocalizable"
    case Reports        = "ReportsLocalizable"
    case Profile        = "ProfileLocalizable"
    case TableViewCell  = "TableViewCellLocalizable"
}

extension String {
    func localized() -> String {
        switch self {
            
            // MARK: - ********************** Common Localization **********************
            // MARK: - Common
            case "Ok"                               : return NSLocalizedString("Ok", tableName: "CommonLocalizable" , comment: "Ok button title")
            case "Close"                            : return NSLocalizedString("Close", tableName: "CommonLocalizable" , comment: "Close button title")
            case "Cancel"                           : return NSLocalizedString("Cancel", tableName: "CommonLocalizable" , comment: "Cancel button title")
            case "Discard Changes"                  : return NSLocalizedString("Discard Changes", tableName: "CommonLocalizable" , comment: "Title for Discard warning")
            case "Are you sure you want to discard your changes?" : return NSLocalizedString("Are you sure you want to discard your changes?", tableName: "CommonLocalizable" , comment: "Message for Discard warning")
            case "Discard"                          : return NSLocalizedString("Discard", tableName: "CommonLocalizable" , comment: "Discard warning button title")
            case "Keep Editing"                     : return NSLocalizedString("Keep Editing", tableName: "CommonLocalizable" , comment: "Discard warning button title")
            case "Edit"                             : return NSLocalizedString("Edit", tableName: "CommonLocalizable" , comment: "Edit button title")
            case "Change Photo"                     : return NSLocalizedString("Change Photo", tableName: "CommonLocalizable" , comment: "Title for Photo upload button")
            case "Add Photo"                        : return NSLocalizedString("Add Photo", tableName: "CommonLocalizable" , comment: "Title for Photo upload button")
            
            case "Take Photo"                       : return NSLocalizedString("Take Photo", tableName: "CommonLocalizable" , comment: "Text for Photo selection option")
            case "Choose Photo"                     : return NSLocalizedString("Choose Photo", tableName: "CommonLocalizable" , comment: "Text for Photo selection option")
            case "Email or Mobile number"           : return NSLocalizedString("Email or Mobile number", tableName: "CommonLocalizable" , comment: "Text for Username Txt Field placeholder")
            case "Email address"                    : return NSLocalizedString("Email address", tableName: "CommonLocalizable" , comment: "Text for Username Txt Field placeholder")
            case "Mobile number placeholder"        : return NSLocalizedString("Mobile number", tableName: "CommonLocalizable" , comment: "Text for Username Txt Field placeholder")
            
            case "Select From"                      : return NSLocalizedString("Select From", tableName: "CommonLocalizable" , comment: "Document picker text")
            case "Files"                            : return NSLocalizedString("Files", tableName: "CommonLocalizable" , comment: "Document picker text")
            case "Folder"                           : return NSLocalizedString("Folder", tableName: "CommonLocalizable" , comment: "Document picker text")
            case "Confirm"                          : return NSLocalizedString("Confirm", tableName: "CommonLocalizable" , comment: "Confiem user input")
            
            case "This field"                       : return NSLocalizedString("This field", tableName: "CommonLocalizable" , comment: "Form validation")
            case "is required."                     : return NSLocalizedString("%@ is required.", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Invalid"                          : return NSLocalizedString("Invalid %@.", tableName: "CommonLocalizable" , comment: "Form validation")
            case "input"                            : return NSLocalizedString("input", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Please enter password first."     : return NSLocalizedString("Please enter password first.", tableName: "CommonLocalizable" , comment: "Form validation")
            case "password doesn't match"           : return NSLocalizedString("password doesn't match", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Invalid value"                    : return NSLocalizedString("Invalid value.", tableName: "CommonLocalizable" , comment: "Form validation")
            case "field can be empty."              : return NSLocalizedString("%@ field can be empty.", tableName: "CommonLocalizable" , comment: "Form validation")
            case "This"                             : return NSLocalizedString("This", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Value should be more than"        : return NSLocalizedString("Value should be more than %@", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Maximum value you can enter is"   : return NSLocalizedString("Maximum value you can enter is %@", tableName: "CommonLocalizable" , comment: "Form validation")
            case "Sign Out"                         : return NSLocalizedString("Sign Out", tableName: "CommonLocalizable" , comment: "Sign out")
            case "Signin out confirmation"          : return NSLocalizedString("Are you sure you want to sign out?", tableName: "CommonLocalizable" , comment: "Signin out confirmation")
            case "Cannot connect to Internet."      : return NSLocalizedString("Cannot connect to Internet.", tableName: "CommonLocalizable" , comment: "Error for Cannot connect to Internet.")
            case "Something went wrong."            : return NSLocalizedString("Something went wrong.", tableName: "CommonLocalizable" , comment: "Error for Something went wrong")
            case "You have selected maximum"        : return NSLocalizedString("You have selected maximum number of items.", tableName: "CommonLocalizable" , comment: "Warning for Mutli select maximum reached")
            case "privacyPolicyUrl"                 : return NSLocalizedString("privacyPolicyUrl", tableName: "CommonLocalizable" , comment: "Url for privacyPolicyUrl")
            case "termsAndConditionUrl"             : return NSLocalizedString("termsAndConditionUrl", tableName: "CommonLocalizable" , comment: "Url for termsAndConditionUrl")
            case "New"                              : return NSLocalizedString("New", tableName: "CommonLocalizable" , comment: "Text for New")
            case "Can't connect at the moment"      : return NSLocalizedString("Can't connect at the moment", tableName: "CommonLocalizable" , comment: "Text for Connection failer")
            case "Check your network connection."   : return NSLocalizedString("Check your network connection.", tableName: "CommonLocalizable" , comment: "Text for Connection failer")
            
            case "Choose Option"                    : return NSLocalizedString("Choose Option", tableName: "ProfileLocalizable" , comment: "Title for Choose Options for email App")
            case "Mail"                             : return NSLocalizedString("Mail", tableName: "ProfileLocalizable" , comment: "Email app option")
            case "Gmail"                            : return NSLocalizedString("Gmail", tableName: "ProfileLocalizable" , comment: "Email app option")
            case "Name"                             : return NSLocalizedString("Name", tableName: "ProfileLocalizable" , comment: "Label name for Name field")
            case "Email"                            : return NSLocalizedString("Email", tableName: "ProfileLocalizable" , comment: "Label name for Email")
            
            case "Old password"                     : return NSLocalizedString("Old password", tableName: "ProfileLocalizable" , comment: "Label name for Old password")
            case "New password"                     : return NSLocalizedString("New password", tableName: "ProfileLocalizable" , comment: "Label name for New password")
            case "Confirm password"                 : return NSLocalizedString("Confirm password", tableName: "ProfileLocalizable" , comment: "Label name for Confirm password")
            
            case "Your password has been changed."  : return NSLocalizedString("Your password has been changed. Please login again.", tableName: "ProfileLocalizable" , comment: "Text for password resetsuccess")
            
            case "Change Mobile Number"             : return NSLocalizedString("Change Mobile Number", tableName: "ProfileLocalizable" , comment: "Title for OTP Generate VC")
            case "Forgot Password"                  : return NSLocalizedString("Forgot Password", tableName: "ProfileLocalizable" , comment: "Title for OTP Generate VC")
            case "Mobile number"                    : return NSLocalizedString("Mobile number", tableName: "ProfileLocalizable" , comment: "Label name for Mobile number")
            
            // MARK: - ********************** Registration Related Localization **********************
            // MARK: - Onboarding PVC
            case "onboarding screen 1 text Part1"   : return NSLocalizedString("onboarding screen 1 text Part1", tableName: "RegistrationLocalizable" , comment: "onboarding screen 1 text Part1")
            case "onboarding screen 1 text Part2"   : return NSLocalizedString("onboarding screen 1 text Part2", tableName: "RegistrationLocalizable" , comment: "onboarding screen 1 text Part2")
            
            case "onboarding screen 2 text Part1"   : return NSLocalizedString("onboarding screen 2 text Part1", tableName: "RegistrationLocalizable" , comment: "onboarding screen 2 text Part1")
            case "onboarding screen 2 text Part2"   : return NSLocalizedString("onboarding screen 2 text Part2", tableName: "RegistrationLocalizable" , comment: "onboarding screen 2 text Part2")
            
            case "onboarding screen 3 text Part1"   : return NSLocalizedString("onboarding screen 3 text Part1", tableName: "RegistrationLocalizable" , comment: "onboarding screen 3 text Part1")
            case "onboarding screen 3 text Part2"   : return NSLocalizedString("onboarding screen 3 text Part2", tableName: "RegistrationLocalizable" , comment: "onboarding screen 3 text Part2")
            
            case "onboarding screen 4 text Part1"   : return NSLocalizedString("onboarding screen 4 text Part1", tableName: "RegistrationLocalizable" , comment: "onboarding screen 4 text Part1")
            case "onboarding screen 4 text Part2"   : return NSLocalizedString("onboarding screen 4 text Part2", tableName: "RegistrationLocalizable" , comment: "onboarding screen 4 text Part2")
            
            
            case "A verification code is sent to %@": return NSLocalizedString("A verification code is sent to %@", tableName: "RegistrationLocalizable" , comment: "text for 'A verification code is sent to %@'")
            case "It will expire in %@ second(s)"   : return NSLocalizedString("It will expire in %@ second(s)", tableName: "RegistrationLocalizable" , comment: "text for 'It will expire in %@ second(s)'")
            
            
            // MARK: - Signup VC
            case "Log In"                           : return NSLocalizedString("Log In", tableName: "RegistrationLocalizable" , comment: "Title for log in button")
            case "Register"                         : return NSLocalizedString("Register", tableName: "RegistrationLocalizable" , comment: "Title for Register screen")
            case "Full name"                        : return NSLocalizedString("Full name", tableName: "RegistrationLocalizable" , comment: "Label name for Name field")
            case "Password"                         : return NSLocalizedString("Password", tableName: "RegistrationLocalizable" , comment: "Label name for Password field")
            case "Privacy Policy text part 1"       : return NSLocalizedString("Privacy Policy text part 1", tableName: "RegistrationLocalizable" , comment: "Text Privacy Policy 'By tapping register, you have read and agreed to'")
            case "Privacy Policy text part 2"       : return NSLocalizedString("Privacy Policy text part 2", tableName: "RegistrationLocalizable" , comment: "Text Privacy Policy 'Privacy Policy'")
            case "Privacy Policy text part 3"       : return NSLocalizedString("Privacy Policy text part 3", tableName: "RegistrationLocalizable" , comment: "Text Privacy Policy 'and'")
            case "Privacy Policy text part 4"       : return NSLocalizedString("Privacy Policy text part 4", tableName: "RegistrationLocalizable" , comment: "Text Privacy Policy 'Terms of Use'")
            case "Verification Code"                : return NSLocalizedString("Verification Code", tableName: "RegistrationLocalizable" , comment: "Title for OTP Verification screen")
            case "Change Email Address"             : return NSLocalizedString("Change Email Address", tableName: "RegistrationLocalizable" , comment: "Title for OTP Verification screen")
            
            // MARK: - OTPVerification VM
            case "Your Mobile"                      : return NSLocalizedString("Your Mobile", tableName: "RegistrationLocalizable" , comment: "Placeholder for Mobile number")
            case "Your Email Address"               : return NSLocalizedString("Your Email Address", tableName: "RegistrationLocalizable" , comment: "Placeholder for Email Address")
            
            case "Go Back"                          : return NSLocalizedString("Go Back", tableName: "CommonLocalizable" , comment: "Title for Go back user verification dialog box")
            case "Are you sure?"                    : return NSLocalizedString("Are you sure?", tableName: "CommonLocalizable" , comment: "Message for Go back user verification dialog box")
            case "Yes"                              : return NSLocalizedString("Yes", tableName: "CommonLocalizable" , comment: "Option for Go back user verification dialog box")
            case "No"                               : return NSLocalizedString("No", tableName: "CommonLocalizable" , comment: "Option for Go back user verification dialog box")
            
            case "Verification code has expired."   : return NSLocalizedString("Verification code has expired.", tableName: "RegistrationLocalizable" , comment: "Warning Text for OTP expiration")
            case "Registered successfully"          : return NSLocalizedString("Registered successfully please login", tableName: "RegistrationLocalizable" , comment: "Success Text Registration success")
            case "Email changed successfully"       : return NSLocalizedString("Your Email has been changed. Please login again.", tableName: "RegistrationLocalizable" , comment: "Success Text Email change success")
            case "Mobile No changed successfully"   : return NSLocalizedString("Your Mobile Number has been changed. Please login again.", tableName: "RegistrationLocalizable" , comment: "Success Text Mobile No change success")
            case "Re-enter password"                : return NSLocalizedString("Re-enter password", tableName: "RegistrationLocalizable" , comment: "Label name for Re-enter password field")
            case "Successfully reset the password." : return NSLocalizedString("Successfully reset the password.", tableName: "RegistrationLocalizable" , comment: "Success Text Password reset success")
            
                    
            
            default: return self
        }
    }

    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
    
}
