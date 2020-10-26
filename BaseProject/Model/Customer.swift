//
//  Customer.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/18/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import RxSwift
import ObjectMapper

class Customer : BaseModel {
    var customerId                      : String?
    var name                            : String?
    var nameStartsFrom                  : String?
    var image                           : UIImage?
    var imageUrl                        : String?
    var mobileNo                        : MobileNumber?
    var _identity                       : Identity?
    
    override var identity               : Identity {
        get {
            return _identity != nil ? _identity! : id
        }
        set {}
    }
    
    var _name                           = BehaviorSubject<String>(value: "")
    var _imageUrl                       = BehaviorSubject<String>(value: "")
    var _image                          = BehaviorSubject<UIImage?>(value: nil)

    override init() {
        self.customerId                 = ""
        self.name                       = ""
        self.nameStartsFrom             = ""
        self.imageUrl                   = ""
        self.image                      = nil
        self.mobileNo                   = MobileNumber()
        super.init(id: self.customerId!)
    }
    
    init(customerId: String?, name: String?, imageUrl: String?, mobileNo: MobileNumber?, nameStartsFrom: String?, image: UIImage?, identity: String? = nil) {
        self.customerId                 = customerId
        self.imageUrl                   = imageUrl
        self.image                      = image
        self.mobileNo                   = mobileNo ?? MobileNumber()
        self.name                       = name
        self.nameStartsFrom             = nameStartsFrom
        self.image                      = image
        self._identity                  = identity
        
        _imageUrl                       = BehaviorSubject<String>(value: imageUrl ?? "")
        _image                          = BehaviorSubject<UIImage?>(value: image ?? nil)
        _name                           = BehaviorSubject<String>(value: name ?? "")
        super.init(id: self.customerId!)
    }
    
    required init?(map: Map) {
        super.init(map: map)
        self.id                         = self.customerId
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        customerId                      <- map["customerId"]
        name                            <- map["name"]
        nameStartsFrom                  <- map["nameStartsFrom"]
        imageUrl                        <- map["imageUrl"]
        mobileNo                        <- map["mobileNo"]
        if mobileNo == nil {
            mobileNo                    = MobileNumber()
        }
        
        _imageUrl                       = BehaviorSubject<String>(value: imageUrl ?? "")
        _name                           = BehaviorSubject<String>(value: name ?? "")
        self.id                         = self.customerId
    }

    func updateSaved() {
        if let savedValue = editedValues() {
            self.name                   = savedValue.name
            self.imageUrl               = savedValue.imageUrl
            self.image                  = savedValue.image
            self.mobileNo?.updateSaved()
            self.nameStartsFrom         = String(savedValue.name.first ?? Character(""))
        }
    }
    
    func resetData() {
        _image.onNext(image ?? nil)
        _imageUrl.onNext(imageUrl ?? "")
        mobileNo?.resetData()
        _name.onNext(name ?? "")
    }
    
    func clearData() {
        _image.onNext(nil)
        _imageUrl.onNext("")
        mobileNo?.clearData()
        _name.onNext("")
    }
        
    func hasEdited() -> Bool {
        if let edit = editedValues() {
            return imageHasEdited() || mobileNo?.hasEdited() == true || edit.name != name
        } else {
            return false
        }
    }
    
    func imageHasEdited() -> Bool {
        if let edit = editedValues() {
            return (imageUrl == "" && edit.image != nil) || edit.imageUrl != imageUrl
        } else {
            return false
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        if let edit = editedValues() {
            return Customer(customerId: customerId, name: edit.name, imageUrl: edit.imageUrl, mobileNo: mobileNo?.copy() as? MobileNumber ?? MobileNumber(), nameStartsFrom: String(edit.name.first ?? Character("")), image: edit.image)
        }
        return Customer(customerId: customerId, name: name, imageUrl: imageUrl, mobileNo: mobileNo, nameStartsFrom: nameStartsFrom, image: image)
    }
    
    func editedValues() -> (imageUrl: String, name: String, image: UIImage?)? {
        do {
            let imageUrlString          = try _imageUrl.value()
            let nameString              = try _name.value()
            let image                   = try _image.value()
                   
            return (imageUrlString, nameString, image)
        } catch let error {
            print("Fetal error: \(error)")
            return nil
        }
    }
    
    override func getSortKey() -> String {
        return name ?? ""
    }
    
}
