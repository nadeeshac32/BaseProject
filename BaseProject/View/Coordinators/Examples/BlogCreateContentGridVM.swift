//
//  BlogCreateContentGridVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/30/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

/// If you initialise a instance of this class in side another BaseVM instance you should add newly created instance to the parent BaseVM's childViewModels array.
class BlogCreateContentGridVM: BaseCollectionVM<BlogContent> {
    
    override var loadFromAPI        : Bool { get { return false } set {} }
    override var loadAsDynemic      : Bool { get { return false } set {} }
    
    deinit { print("deinit BlogCreateContentGridVM") }
    
    func contentAdd(items: [BlogContent]) {
        self.addNewItems(items: items)
        requestLoading.onNext(false)
    }
    
    func contentRemove(item: BlogContent, section: Int, row: Int) {
        // TODO: - Base Collection VM  removeItems(items: [String: [Items]])
        self.removeExistingItems(items: [item])
        requestLoading.onNext(false)
    }
    
}
