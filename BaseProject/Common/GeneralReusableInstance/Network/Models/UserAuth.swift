//
//  UserAuth.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import KeychainSwift
import GoogleSignIn

class UserAuth: BaseModel {
    static let          si                  = UserAuth()    //    shared instance
    
    var signedIn        : Bool              = false
    var userId          : String            = ""
    var username        : String            = ""
    var firstName       : String            = ""
    var lastName        : String            = ""
    var fullName        : String            { return "\(self.firstName) \(self.lastName)" }
    var token           : String            = ""
    var refreshToken    : String            = ""
    var tokenType       : String            = ""
    var mobile          : String            = ""
    var email           : String            = ""
    var profilepic      : String            = ""
    var language        : String            = ""
    var address         : String            = ""
    var expiresIn       : Int               = 0
    var scope           : String            = ""
    
    let defaults                            = UserDefaults.standard
    let keychain                            = KeychainSwift()
    
    private override init() {
        super.init()
    }
    required init?(map: Map) {
        super.init(map: map)
        self.id                             = self.userId
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        userId                              <- map["userId"]
        username                            <- map["username"]
        firstName                           <- map["user_firstName"]
        lastName                            <- map["user_lastName"]
        language                            <- map["language"]
        mobile                              <- map["user_mobile"]
        email                               <- map["user_email"]
        profilepic                          <- map["user_profilepic"]
        address                             <- map["user_address"]
        
        token                               <- map["accessToken"]
        refreshToken                        <- map["refreshToken"]
        tokenType                           <- map["tokenType"]
        
        self.id                             = self.userId
    }

    //call this method in app delegate
    func initialise() {
        
        self.signedIn                       = keychain.getBool("user_SignedIn") ?? false
        self.userId                         = defaults.string(forKey: "userId")             ?? ""
        self.token                          = keychain.get("access_token")                  ?? ""
        
        if self.signedIn && self.userId != "" && self.token != "" {
            self.username                   = defaults.string(forKey: "username")           ?? ""
            self.firstName                  = defaults.string(forKey: "user_firstName")     ?? ""
            self.lastName                   = defaults.string(forKey: "user_lastName")      ?? ""
            self.mobile                     = defaults.string(forKey: "user_mobile")        ?? ""
            self.email                      = defaults.string(forKey: "user_email")         ?? ""
            self.profilepic                 = defaults.string(forKey: "user_profilepic")    ?? ""
            self.language                   = defaults.string(forKey: "user_language")      ?? ""
            self.address                    = defaults.string(forKey: "user_address")       ?? ""
            
            self.token                      = keychain.get("access_token")                  ?? ""
            self.refreshToken               = keychain.get("refresh_token")                 ?? ""
            self.tokenType                  = keychain.get("token_type")                    ?? ""
            
//            let bookString                  = defaults.string(forKey: "user_books")         ?? ""
//            self.books                      = Mapper<Book>().mapArray(JSONfile: bookString)
        } else {
            logOut()
        }
    }
    
    func setUserDetails(user: UserAuth) {
        self.signedIn                       = user.signedIn
        self.userId                         = user.userId
        self.username                       = user.username
        self.firstName                      = user.firstName
        self.lastName                       = user.lastName
        self.mobile                         = user.mobile
        self.email                          = user.email
        self.profilepic                     = user.profilepic
        self.language                       = user.language
        self.address                        = user.address
        
        self.token                          = user.token
        self.refreshToken                   = user.refreshToken
        self.tokenType                      = user.tokenType
        
        keychain.set(signedIn               , forKey: "user_SignedIn")
        defaults.set(userId                 , forKey: "userId")
        defaults.set(username               , forKey: "username")
        defaults.set(firstName              , forKey: "user_firstName")
        defaults.set(lastName               , forKey: "user_lastName")
        defaults.set(mobile                 , forKey: "user_mobile")
        defaults.set(email                  , forKey: "user_email")
        defaults.set(profilepic             , forKey: "user_profilepic")
        defaults.set(language               , forKey: "user_language")
        defaults.set(address                , forKey: "user_address")
        
        keychain.set(token                  , forKey: "access_token")
        keychain.set(refreshToken           , forKey: "refresh_token")
        keychain.set(tokenType              , forKey: "token_type")
    }
    
    func setUserDetails(signedIn            : Bool      = false,
                        userId              : String    = "",
                        username            : String    = "",
                        firstName           : String    = "",
                        lastName            : String    = "",
                        mobile              : String    = "",
                        email               : String    = "",
                        profilepic          : String    = "",
                        language            : String    = "",
                        address             : String    = "",
                        
                        token               : String    = "",
                        refreshToken        : String    = "",
                        tokenType           : String    = "") {
        
        self.signedIn                       = signedIn
        self.userId                         = userId
        self.username                       = username
        self.firstName                      = firstName
        self.lastName                       = lastName
        self.mobile                         = mobile
        self.email                          = email
        self.profilepic                     = profilepic
        self.language                       = language
        self.address                        = address
        
        self.token                          = token
        self.refreshToken                   = refreshToken
        self.tokenType                      = tokenType
//        self.books                          = books
        
        keychain.set(signedIn               , forKey: "user_SignedIn")
        defaults.set(userId                 , forKey: "userId")
        defaults.set(username               , forKey: "username")
        defaults.set(firstName              , forKey: "user_firstName")
        defaults.set(lastName               , forKey: "user_lastName")
        defaults.set(mobile                 , forKey: "user_mobile")
        defaults.set(email                  , forKey: "user_email")
        defaults.set(profilepic             , forKey: "user_profilepic")
        defaults.set(language               , forKey: "user_language")
        defaults.set(address                , forKey: "user_address")
        
        keychain.set(token                  , forKey: "access_token")
        keychain.set(refreshToken           , forKey: "refresh_token")
        keychain.set(tokenType              , forKey: "token_type")
//        defaults.set(books.toJSONString()   , forKey: "user_books")
    }
    
    func logOut() {
        Settings.si.removeSavedSettings()
        GIDSignIn.sharedInstance().signOut()
        setUserDetails()
    }
    
    func printUser() {
        print("user details =>")
        print("user_SignedIn                : \(signedIn)")
        print("userId                       : \(userId)")
        print("username                     : \(username)")
        print("user_firstName               : \(firstName)")
        print("user_lastName                : \(lastName)")
        print("user_mobile                  : \(mobile)")
        print("user_email                   : \(email)")
        print("user_profilepic              : \(profilepic)")
        print("user_language                : \(language)")
        print("user_address                 : \(address)")
        
        print("access_token                 : \(token)")
        print("refresh_token                : \(refreshToken)")
        print("token_type                   : \(tokenType)")
    }
}
