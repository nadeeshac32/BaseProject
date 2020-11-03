//
//  User.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import RxSwift
import ObjectMapper

class User : BaseModel {
    
    static let si                       = User()    //    shared instance
    
    var fullName                        : String?
    var email                           : String?
    var image                           : UIImage?
    var imageUrl                        : String?
    var mobileNo                        : MobileNumber?
    var language                        : String?
    var registeredUser                  : Bool?
    
    var _fullName                       = BehaviorSubject<String>(value: "")
    var _imageUrl                       = BehaviorSubject<String>(value: "")
    var _image                          = BehaviorSubject<UIImage?>(value: nil)
    var _email                          = BehaviorSubject<String>(value: "")

    override init() {
        self.fullName                   = "Will Smith"
        self.email                      = ""
        self.imageUrl                   = "https://cdn.aarp.net/content/dam/aarp/entertainment/movies-for-grownups/2020/07/1140-will-smith.jpg"
        self.image                      = nil
        self.mobileNo                   = MobileNumber()
        self.language                   = ""
        self.registeredUser             = false
        super.init(id: UserAuth.si.userId)
    }
    
    init(fullName: String?, email: String?, image: UIImage?, imageUrl: String?, mobileNo: MobileNumber?, language: String?, registeredUser: Bool? = false) {
        self.fullName                   = fullName
        self.email                      = email
        self.image                      = image
        self.imageUrl                   = imageUrl
        self.mobileNo                   = mobileNo ?? MobileNumber()
        self.language                   = language
        self.registeredUser             = registeredUser
        
        _fullName                       = BehaviorSubject<String>(value: fullName ?? "")
        _email                          = BehaviorSubject<String>(value: email ?? "")
        _imageUrl                       = BehaviorSubject<String>(value: imageUrl ?? "")
        _image                          = BehaviorSubject<UIImage?>(value: image ?? nil)
        
        super.init(id: UserAuth.si.userId)
    }
    
    func resetWithData(user: User) {
        self.fullName                   = user.fullName
        self.email                      = user.email
        self.image                      = user.image
        self.imageUrl                   = user.imageUrl
        self.mobileNo?.countryCode      = user.mobileNo?.countryCode
        self.mobileNo?.localNumber      = user.mobileNo?.localNumber
        self.mobileNo?.displayNumber    = user.mobileNo?.displayNumber
        self.language                   = user.language
        self.registeredUser             = user.registeredUser
        resetData()
    }
    
    required init?(map: Map) {
        super.init(map: map)
        self.id                         = UserAuth.si.userId
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        fullName                        <- map["fullName"]
        email                           <- map["email"]
        imageUrl                        <- map["imageUrl"]
        mobileNo                        <- map["mobileNo"]
        if mobileNo == nil {
            mobileNo                    = MobileNumber()
        }
        language                        <- map["language"]
        registeredUser                  <- map["registeredUser"]
        
        _fullName                       = BehaviorSubject<String>(value: fullName ?? "")
        _email                          = BehaviorSubject<String>(value: email ?? "")
        _imageUrl                       = BehaviorSubject<String>(value: imageUrl ?? "")
        self.id                         = UserAuth.si.userId
    }

    func updateSaved() {
        if let savedValue = editedValues() {
            self.fullName               = savedValue.fullName
            self.email                  = savedValue.email
            self.imageUrl               = savedValue.imageUrl
            self.image                  = savedValue.image
            self.mobileNo?.updateSaved()
        }
    }
    
    func resetData() {
        _fullName.onNext(fullName ?? "")
        _email.onNext(email ?? "")
        _image.onNext(image ?? nil)
        _imageUrl.onNext(imageUrl ?? "")
        mobileNo?.resetData()
    }
    
    func clearData() {
        _fullName.onNext("")
        _email.onNext("")
        _image.onNext(nil)
        _imageUrl.onNext("")
        mobileNo?.clearData()
    }
        
    func hasEdited() -> Bool {
        if let edit = editedValues() {
            return imageHasEdited() || mobileNo?.hasEdited() == true || edit.fullName != fullName  || edit.email != email
        } else {
            return false
        }
    }
    
    func imageHasEdited() -> Bool {
        if let edit = editedValues() {
            return ((imageUrl == "" || imageUrl == nil) && edit.image != nil) || (edit.imageUrl != imageUrl ?? "")
        } else {
            return false
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        if let edit = editedValues() {
            return User(fullName: edit.fullName, email: edit.email, image: edit.image, imageUrl: edit.imageUrl, mobileNo: mobileNo?.copy() as? MobileNumber ?? MobileNumber(), language: language, registeredUser: registeredUser)
        }
        return User(fullName: fullName, email: email, image: image, imageUrl: imageUrl, mobileNo: mobileNo, language: language, registeredUser: registeredUser)
    }
    
    func editedValues() -> (fullName: String, email: String, imageUrl: String, image: UIImage?)? {
        do {
            let nameString              = try _fullName.value()
            let emailString             = try _email.value()
            let imageUrlString          = try _imageUrl.value()
            let image                   = try _image.value()
                   
            return (nameString, emailString, imageUrlString, image)
        } catch let error {
            print("Fetal error: \(error)")
            return nil
        }
    }
    
    override func getSortKey() -> String {
        return fullName ?? ""
    }
    
}
