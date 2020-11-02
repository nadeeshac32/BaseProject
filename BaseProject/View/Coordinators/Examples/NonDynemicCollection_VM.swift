//
//  NonDynemicCollection_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class NonDynemicCollectionVM: BaseCollectionVM<Customer> {
    
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    override var shouldSortFromKey  : Bool { get { return true } set {} }
    
    deinit {
        print("deinit NonDynemicCollectionVM")
    }
    
    override func viewDidLoad() {
        getCustomersFromPhoneContacts()
        super.viewDidLoad()
    }
    
    override func getMaxSelectedItemsCountWarning() -> String {
        return "Maximum allowed contacts to sync".localizeWithFormat(arguments: "\(multiSelectMax)")
    }
    
    // Class Methods
    func getCustomersFromPhoneContacts() {
        let phoneContacts           = PhoneContacts.getAllContacts(filter: .phone)
        let customers: [Customer]   = phoneContacts.map { (phoneContact) -> Customer in
            let mobile              = MobileNumber(countryCode: "", localNumber: "", displayNumber: phoneContact.phoneNumber.first ?? "")
            var imageFromData       : UIImage? = nil
            if let imageData        = phoneContact.avatarData {
                imageFromData       = UIImage(data: imageData)
            }
            return Customer(customerId: "", name: phoneContact.name, imageUrl: "", mobileNo: mobile, nameStartsFrom: String(phoneContact.name?.first ?? Character("")), image: imageFromData, identity: phoneContact.id)
        }
        let sections                = Dictionary(grouping: customers) { $0.nameStartsFrom! }
        self.addNewItems(items: sections)
        requestLoading.onNext(false)
    }
    
}
