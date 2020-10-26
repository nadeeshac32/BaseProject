//
//  DynemicList_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/18/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class DynemicListVM: BaseListVM<Customer> {
    
    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var shouldSortFromKey  : Bool { get { return true } set {} }
    
    deinit {
        print("deinit DynemicListVM")
    }
    
    // MARK: - Network request
    override func perfomrGetItemsRequest(loadPage: Int, limit: Int) {
//        let httpService             = HTTPService()
//        showSpiner()
//        httpService.getAllCustomersForUser(page: loadPage, limit: limit, onSuccess: { [weak self] (customers, total, page, limit) in
//            self?.requestLoading.onNext(false)
//            self?.handleResponse(items: customers, total: total, page: page)
//            if total == 0 {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "no.existing.customer"), object: nil, userInfo: nil)
//            }
//        }) { [weak self] (error) in
//            self?.handleRestClientError(error: error)
//        }
    }
    
}
