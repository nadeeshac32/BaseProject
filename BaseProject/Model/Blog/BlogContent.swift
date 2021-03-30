//
//  BlogContent.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import ObjectMapper
import Photos
import TLPhotoPicker

class BlogContent: BaseModel {
    var mediaUrl            : String?
    var asset               : TLPHAsset?
    var isRemovable         : Bool = false

    init(editable: Bool, mediaUrl: String?, asset: TLPHAsset?) {
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
