//
//  LanguageSelection_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import RxSwift

class LanguageSelectionVM: BaseVM {
    
    // MARK: - Inputs
    var continueTapped              : AnyObserver<Void>
    
    // MARK: - Outputs
    var showOnboardingScreens       : Observable<Void>
    let toggleToEnglish             : PublishSubject<Bool> = PublishSubject()
    let toggleToBahasa              : PublishSubject<Bool> = PublishSubject()
    
    deinit {
        print("deinit LanguageSelectionVM")
    }
    
    override init() {
        let _continueTapped         = PublishSubject<Void>()
        self.continueTapped         = _continueTapped.asObserver()
        self.showOnboardingScreens  = _continueTapped.asObservable()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated: animated)
        if Settings.si.appLanguage?.selectedValue?.text == Language.English.rawValue {
            toggleToEnglish.onNext(true)
        } else {
            toggleToBahasa.onNext(true)
        }
    }
    
    func selectEnglish() {
        toggleToEnglish.onNext(true)
        Settings.si.appLanguage?.saveSettingValueIndex(index: Language.English.getIndex())
    }
    
    func selectBhasha() {
        toggleToBahasa.onNext(true)
        Settings.si.appLanguage?.saveSettingValueIndex(index: Language.Bahasa.getIndex())
    }
}
