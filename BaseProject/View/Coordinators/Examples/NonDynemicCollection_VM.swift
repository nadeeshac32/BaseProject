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
    
    var loadingMethod               : Customers? = .allContacts
    let httpService                 = HTTPService()
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    override var shouldSortFromKey  : Bool { get { return true } set {} }
    
    // MARK: - Outputs
    let enableSyncButton            : PublishSubject<Bool> = PublishSubject()
    
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
    
    // MARK: - Network request
//    func performSync() {
//        guard selectedItems.count > 0 else {
//            let tupple = (message: "Please select contacts you want".localized(), blockScreen: false, completionHandler: { })
//            warningMessage.onNext(tupple)
//            return
//        }
//        let customerChunks          = selectedItems.chunked(into: 150)
//        performSyncRequest(forChuncks: customerChunks)
//    }
    
//    func performSyncRequest(forChuncks: [[Customer]]) {
//        var chunks                  = forChuncks
//        guard chunks.count > 0 else { return }
//        if let nextChunck           = chunks.popLast() {
//            let syncPostData = CustomersSyncPostData(customersChunck: nextChunck)
//            requestLoading.onNext(true)
//            enableSyncButton.onNext(false)
//            httpService.syncCustomers(customersChunk: syncPostData, onSuccess: { [weak self] in
//                if chunks.count > 0 {
//                    self?.performSyncRequest(forChuncks: chunks)
//                } else {
//                    self?.requestLoading.onNext(false)
//                    self?.enableSyncButton.onNext(true)
//                    let tupple      = (message: "Sync Successful.".localized(), blockScreen: false, completionHandler: {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new.customers.syncked"), object: nil, userInfo: nil)
//                    })
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new.customer.added"), object: nil, userInfo: nil)
//                    self?.cancelMultiSelection()
//                    self?.successMessage.onNext(tupple)
//                }
//            }) { (error) in
//                self.handleRestClientError(error: error)
//            }
//        }
//    }
}
