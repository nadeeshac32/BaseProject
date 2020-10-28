//
//  BlogCreateEdit_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

//class BlogCreateEditVM: BaseCollectionVM<BlogContent> {
class BlogCreateEditVM: BaseFormVM {

    var blog                        : Blog!
    
//    override var loadFromAPI        : Bool { get { return false } set {} }
//    override var loadAsDynemic      : Bool { get { return false } set {} }
    
    deinit {
        print("deinit BlogFeedVM")
    }
    
    init(blog: Blog) {
        self.blog                   = blog
        super.init()
    }
    
    
    override func viewDidLoad() {
        fetchFeed()
        super.viewDidLoad()
    }
    
    // Class Methods
    func fetchFeed() {
//        let posts = BlogRepository.fetchPosts()
//        self.addNewItems(items: posts)
//        requestLoading.onNext(false)
    }
    
    // MARK: - Network request
    
}
