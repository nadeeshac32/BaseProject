//
//  Onboarding_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

class OnboardingVM {
    
    // MARK: - Inputs
    var skip                        : AnyObserver<Void> = PublishSubject<Void>().asObserver()
    var next                        : AnyObserver<Void> = PublishSubject<Void>().asObserver()
    var endOnboarding               : AnyObserver<Void> = PublishSubject<Void>().asObserver()
    var pageChangeToIndex           : AnyObserver<Int>  = PublishSubject<Int>().asObserver()
    
    // MARK: - Outputs
    var moveToPageWithIndex         : Observable<Int?> = PublishSubject<Int?>().asObservable()
    var didEndOnboarding            : Observable<Void> = PublishSubject<Void>().asObservable()
    var appearGetStartedBtn         : Observable<Bool> = PublishSubject<Bool>().asObservable()
    
    // MARK: - Private Variables
    private var currentPage         = 0
    private var pageCount           = 3
    init() {
        let _pageChangeToIndex      = PublishSubject<Int>()
        self.pageChangeToIndex      = _pageChangeToIndex.asObserver()
        self.appearGetStartedBtn    = _pageChangeToIndex.asObservable()
                .map {  index -> Bool in
                    self.currentPage    = index
                    if index == self.pageCount {
                        return true
                    } else {
                        return false
                    }
                }
        
        let _skip                   = PublishSubject<Void>()
        self.skip                   = _skip.asObserver()
        
        let _next                   = PublishSubject<Void>()
        self.next                   = _next.asObserver()
        
        self.moveToPageWithIndex    = Observable.from([
                _skip.asObservable().map({ () -> Int? in
                    guard self.currentPage != self.pageCount else { return nil }
                    return 3
                }),
                _next.asObservable().map({ () -> Int? in
                    guard self.currentPage != self.pageCount else { return nil }
                    return self.currentPage + 1
                })
            ]).merge()
        
        let _endOnboarding          = PublishSubject<Void>()
        self.endOnboarding          = _endOnboarding.asObserver()
        self.didEndOnboarding       = _endOnboarding.asObservable()
        
    }
}
