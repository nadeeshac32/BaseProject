//
//  BlogCreateContentGridVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/30/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Photos

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
        self.removeExistingItems(items: [item])
        requestLoading.onNext(false)
    }
    
    func isContentAdded() -> Bool {
        return ((getNewContent()?.count ?? 0) > 0) == true
    }
    
    func getNewContent() -> [BlogContent]? {
        do { return try items.value().filter({ $0.asset != nil }) } catch { return nil }
    }
    
}
