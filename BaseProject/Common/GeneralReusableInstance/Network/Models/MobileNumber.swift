//
//  MobileNumber.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class MobileNumber : Mappable {
    var countryCode : String?           = ""
    var localNumber : String?           = ""
    var displayNumber : String?         = ""
    
    var _countryCode                    = BehaviorSubject<String>(value: "")
    var _localNumber                    = BehaviorSubject<String>(value: "")
    var _displayNumber                  = BehaviorSubject<String>(value: "")

    init() {
        self.countryCode                = ""
        self.localNumber                = ""
        self.displayNumber              = ""
    }
    init(countryCode: String? = "", localNumber: String? = "", displayNumber: String? = "") {
        self.countryCode                = countryCode
        self.localNumber                = localNumber
        self.displayNumber              = displayNumber
        
        _countryCode                    = BehaviorSubject<String>(value: countryCode ?? "")
        _localNumber                    = BehaviorSubject<String>(value: localNumber ?? "")
        _displayNumber                  = BehaviorSubject<String>(value: displayNumber ?? "")
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        countryCode                     <- map["countryCode"]
        localNumber                     <- map["localNumber"]
        displayNumber                   <- map["displayNumber"]
        
        countryCode                     = countryCode ?? ""
        localNumber                     = localNumber ?? ""
        displayNumber                   = displayNumber ?? ""
        
        _countryCode                    = BehaviorSubject<String>(value: countryCode ?? "")
        _localNumber                    = BehaviorSubject<String>(value: localNumber ?? "")
        _displayNumber                  = BehaviorSubject<String>(value: displayNumber ?? "")
    }

    func updateSaved() {
        if let savedValue = editedValues() {
            self.countryCode            = savedValue.countryCode
            self.localNumber            = savedValue.localNumber
            self.displayNumber          = "\(savedValue.countryCode)\(savedValue.localNumber)"
            _displayNumber.onNext(displayNumber ?? "")
        }
    }
    
    func resetData() {
        _countryCode.onNext(countryCode ?? "")
        _localNumber.onNext(localNumber ?? "")
        _displayNumber.onNext(displayNumber ?? "")
    }
    
    func clearData() {
        self.countryCode                = ""
        self.localNumber                = ""
        self.displayNumber              = ""
        
        _countryCode.onNext("")
        _localNumber.onNext("")
        _displayNumber.onNext("")
    }
        
    func hasEdited() -> Bool {
        if let edit = editedValues() {
            return edit.countryCode != countryCode! || edit.localNumber != localNumber! || edit.displayNumber != displayNumber!
        } else {
            return false
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        if let edit = editedValues() {
            if edit.countryCode != countryCode || edit.localNumber != localNumber {
                return MobileNumber(countryCode: edit.localNumber == "" ? "" : edit.countryCode, localNumber: edit.localNumber, displayNumber: "")
            } else {
                return MobileNumber(countryCode: "", localNumber: "", displayNumber: edit.displayNumber)
            }
        }
        return MobileNumber(countryCode: countryCode, localNumber: localNumber, displayNumber: displayNumber)
    }
    
    private func editedValues() -> (countryCode: String, localNumber: String, displayNumber: String)? {
        do {
            let countryCodeString       = try _countryCode.value()
            let localNumberString       = try _localNumber.value()
            let displayNumberString     = try _displayNumber.value()
                   
            return (countryCodeString, localNumberString, displayNumberString)
        } catch let error {
            print("Fetal error: \(error)")
            return nil
        }
    }

}
