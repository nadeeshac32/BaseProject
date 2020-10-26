//
//  PhoneContact.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContact: NSObject {

    var id : String?
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        id          = contact.identifier
        name        = contact.givenName + " " + contact.familyName
        if contact.givenName == "" {
            name    = contact.familyName
        }
        if contact.familyName == "" && contact.givenName == "" {
            name    = "-"
        }
        avatarData  = contact.imageData
        for phone in contact.phoneNumbers {
            //  phoneNumber.append(phone.value.stringValue)
            //  let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
            let fulMobNumVar    = phone.value
            if let MccNamVar    = fulMobNumVar.value(forKey: "digits") as? String {
                phoneNumber.append(MccNamVar)
                if name == "-" {
                    name        = MccNamVar
                }
            }
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }

    override init() {
        super.init()
    }
}
