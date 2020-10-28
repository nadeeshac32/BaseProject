//
//  BlogContent.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import ObjectMapper

class BlogContent: BaseModel {
    var mediaUrl        : String?
    var image           : UIImage?
    var videoThumbUrl   : String?
    var videoFilePath   : String?

    init(mediaUrl: String?, image: UIImage?, videoThumbUrl: String? = nil, videoFilePath: String? = nil) {
        self.mediaUrl       = mediaUrl ?? UUID().uuidString
        self.image          = image
        self.videoThumbUrl  = videoThumbUrl
        self.videoFilePath  = videoFilePath
        super.init(id: mediaUrl!)
    }

    required init?(map: Map) {
        super.init(map: map)
        self.id         = self.mediaUrl
    }

}
