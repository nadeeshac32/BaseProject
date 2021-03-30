//
//  PhoneContacts.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case phone
}

class PhoneContacts {

    class func getAllContacts(filter: ContactsFilter) -> [PhoneContact]{
        var phoneContacts = [PhoneContact]()
        
        var allContacts = [PhoneContact]()
        for contact in self.loadContacts() {
            allContacts.append(PhoneContact(contact: contact))
        }

        var filterdArray = [PhoneContact]()
        if filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 })
        } else if filter == .phone {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        phoneContacts.append(contentsOf: filterdArray)

//        for contact in phoneContacts {
//            print("**************")
//            print("Name         -> \(String(describing: contact.name))")
//            print("Email        -> \(contact.email)")
//            print("Phone Number -> \(contact.phoneNumber)")
//        }
        return phoneContacts
    }
    
    class func loadContacts() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey,
            CNContactImageDataAvailableKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
}

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
