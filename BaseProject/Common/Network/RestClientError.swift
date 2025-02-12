//
//  RestClientError.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

typealias ErrorCallback             = (_ error: RestClientError) -> Void
typealias SuccessEmptyDataCallback  = () -> Void

/// `RestClientError` Throws from HTTP Service
public enum RestClientError: Error {
    case AlamofireError(message: String)
    
    case BackendError(code: Int, message: String)
    
    case AuthenticationError(reason: String, desc: String, message: String)
    
    case JsonParseError
    
    case UndefinedError
    
    case EmptyDataError
    
    case InternalServerError
}

extension RestClientError {
    
    /// Rest API Error initializer
    ///
    /// - Parameters:
    ///   - jsonResult:    `json response` returned from api
    init(jsonResult: Dictionary<String, Any>?) {
        // You will have to change this according to you Rest API requirment
        if let status               = jsonResult?["status"] as? String, status == "ERROR",
            let code                = jsonResult?["errorCode"] as? Int,
            let displayMessage      = jsonResult?["displayMessage"] as? String {
            
            if code == 4910 {
                self                = .AuthenticationError(reason: "Invalid refresh token", desc: "Refresh token failure.", message: displayMessage)
            } else {
                self                = .BackendError(code: code, message: displayMessage)
            }
            
        } else if let error         = jsonResult?["error"] as? String, error == "invalid_token",
            let errorDescription = jsonResult?["error_description"] as? String {
            self                    = .AuthenticationError(reason: "Invalid token", desc: errorDescription, message: "Authentication failure.")
            
        } else if let status        = jsonResult?["status"] as? Int, status == 500,
            let error               = jsonResult?["error"] as? String, error == "Internal Server Error" {
            self                    = .InternalServerError
            
        } else {
            self                    = .UndefinedError
        }
    }
}

extension RestClientError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .AlamofireError(message)                       : return    "Alamofire error -> message: \(message)"
        case let .BackendError(code, message)                   : return    "Backend error -> code: \(code), message: \(message)"
        case let .AuthenticationError(reason, desc, message)    : return    "Authentication error -> reason: \(reason), desc: \(desc), message: \(message)"
        case .JsonParseError                                    : return    "Json Parse error"
        case .UndefinedError                                    : return    "Error Not Registered"
        case .EmptyDataError                                    : return    "Error Response Empty"
        case .InternalServerError                               : return    "Internal Server Error"
        }
    }
}
