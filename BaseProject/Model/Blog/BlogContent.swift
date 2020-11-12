//
//  BlogContent.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper
import Photos

class BlogContent: BaseModel {
    var mediaUrl            : String?
    var asset               : PHAsset?
    var isRemovable         : Bool = false

    init(editable: Bool, mediaUrl: String?, asset: PHAsset?) {
        self.mediaUrl       = mediaUrl ?? UUID().uuidString
        self.asset          = asset
        self.isRemovable    = editable
        super.init(id: self.mediaUrl!)
    }

    required init?(map: Map) {
        super.init(map: map)
        self.id             = self.mediaUrl
    }

}
