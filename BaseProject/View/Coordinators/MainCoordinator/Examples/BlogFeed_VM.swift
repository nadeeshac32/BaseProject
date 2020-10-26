//
//  BlogFeed_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class BlogFeedVM: BaseListVM<Blog> {
    
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    
    deinit {
        print("deinit BlogFeedVM")
    }
    
    override func viewDidLoad() {
        fetchFeed()
        super.viewDidLoad()
    }
    
    // Class Methods
    func fetchFeed() {
        let posts = BlogRepository.fetchPosts()
        self.addNewItems(items: posts)
        requestLoading.onNext(false)
    }
    
    // MARK: - Network request
    
}
