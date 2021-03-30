//
//  NCDocument.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class NCDocument: UIDocument {
    
    var data: Data?
    
    override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        
        return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        guard let data = contents as? Data else { return }
        
        self.data = data
    }
    
}

extension URL {
    var isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
}
