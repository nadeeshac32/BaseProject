//
//  MultimediaPostData.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/13/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class MultimediaPostData: NSObject {
    var url             : URL?
    var image           : UIImage?
    var mimeType        : String?
    
    init(url: URL? = nil, image: UIImage? = nil, mimeType: String? = nil) {
        self.url = url
        self.image = image
        self.mimeType = mimeType
    }
}
