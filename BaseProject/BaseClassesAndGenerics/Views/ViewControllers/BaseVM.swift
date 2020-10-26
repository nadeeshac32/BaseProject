//
//  BaseVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Base ViewModel that supports BaseVC.
/// Handles all the RestClientErrors + authentication failure & logout functionality.
/// Displaying Success / Warning / Error messages
class BaseVM: NSObject {
    // MARK: - Inputs
    
    // MARK: - Outputs
    let setupTitleViewInViewWillAppear      : PublishSubject<Bool>                                  = PublishSubject()
    let setupTitleViewInViewDidAppear       : PublishSubject<Bool>                                  = PublishSubject()
    let removeTitleViewInViewWillDisappear  : PublishSubject<Bool>                                  = PublishSubject()
    let removeTitleViewInViewDidDisappear   : PublishSubject<Bool>                                  = PublishSubject()
    
    let adjustForKeyboardHeightChange       : Observable<CGFloat>
    
    let hideKeyBoard                        : PublishSubject<Bool>                                  = PublishSubject()
    
    let errorMessage                        : PublishSubject<(message: String, blockScreen: Bool, completionHandler: () -> ()?)>   = PublishSubject()
    let successMessage                      : PublishSubject<(message: String, blockScreen: Bool, completionHandler: () -> ()?)>   = PublishSubject()
    let warningMessage                      : PublishSubject<(message: String, blockScreen: Bool, completionHandler: () -> ()?)>   = PublishSubject()
    let toastMessage                        : PublishSubject<String>                                = PublishSubject()

    let requestLoading                      : BehaviorSubject<Bool>                                 = BehaviorSubject(value: false)
    let freezeForRequestLoading             : BehaviorSubject<Bool>                                 = BehaviorSubject(value: false)

    let showSignInVC                        : PublishSubject<Bool>                                  = PublishSubject()
    let goToPreviousVC                      : PublishSubject<Bool>                                  = PublishSubject()
    
    typealias alertType                     = (title: String?, message: String?,
                                            primaryBtnTitle: String?, primaryActionColor: UIColor?, primaryAction: (() -> ())?,
                                            secondaryBtnTitle: String?, secondaryActionColor: UIColor?, secondaryAction: (() -> ())?)
    let showAlert                           : PublishSubject<alertType> = PublishSubject()
    
    
    override init() {
        adjustForKeyboardHeightChange       = Observable
        .from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        return 0 }
        ])
        .merge()
        super.init()
    }

    func logoutUser() {
        let alert = (title: "Sign Out".localized(), message: "Signin out confirmation".localized(),
        primaryBtnTitle: "Sign Out".localized(), primaryActionColor: AppConfig.si.colorError, primaryAction: { [weak self] in
            UserAuth.si.logOut()
            self?.showSignInVC.onNext(true)
        },
        secondaryBtnTitle: nil, secondaryActionColor: nil, secondaryAction: nil) as alertType
        showAlert.on(.next(alert))
    }
    
    func logoutUserWithoutPermission() {
        UserAuth.si.logOut()
        self.showSignInVC.onNext(true)
    }
    
    // MARK: - UIViewController Life cycle
    func viewDidLoad() {
    }
    func viewWillLayoutSubviews() {
    }
    func viewDidLayoutSubviews() {
    }
    func viewWillAppear(animated: Bool) {
        self.setupTitleViewInViewWillAppear.onNext(true)
    }
    func viewDidAppear(animated: Bool) {
        self.setupTitleViewInViewDidAppear.onNext(true)
    }
    func viewWillDisappear(animated: Bool) {
        self.removeTitleViewInViewWillDisappear.onNext(true)
    }
    func viewDidDisappear(animated: Bool) {
        self.removeTitleViewInViewDidDisappear.onNext(true)
    }
    
    func backButtonTapped() {
        goToPreviousVC.onNext(true)
    }
    // MARK: - App Life cycle
    func didOpenTheApp() {
    }
    
    // MARK: - Network error handling
    func handleRestClientError(error: RestClientError, blockScreen: Bool? = false) {
        self.requestLoading.onNext(false)
        self.freezeForRequestLoading.onNext(false)
        switch error {
        case let .ServerError(code, message):
            self.handleServerError(code: code, message: message, blockScreen: blockScreen)
            break
        
        case let .AuthenticationError(_, _, message):
            self.handleAuthenticationError(message: message)
            break
            
        case let .AlamofireError(message):
            self.handleAlamofireError(message: message, blockScreen: blockScreen)
            break
            
        default:
            self.handleDefaultError(blockScreen: blockScreen)
            break
        }
    }
    
    func handleAlamofireError(message: String, blockScreen: Bool? = false) {
        let tupple = (message: "Cannot connect to Internet.".localized(), blockScreen: blockScreen!, completionHandler: {})
        self.errorMessage.onNext(tupple)
    }
    
    func handleServerError(code: Int, message: String, blockScreen: Bool? = false) {
        let tupple = (message: message, blockScreen: blockScreen!, completionHandler: {})
        self.errorMessage.onNext(tupple)
    }
    
    func handleAuthenticationError(message: String) {
        let tupple = (message: message, blockScreen: true, completionHandler: { [weak self] in
            UserAuth.si.logOut()
            self?.showSignInVC.onNext(true)
        })
        self.errorMessage.onNext(tupple)
    }
    
    func handleDefaultError(blockScreen: Bool? = false) {
        let tupple = (message: "Something went wrong.".localized(), blockScreen: blockScreen!, completionHandler: {})
        self.errorMessage.onNext(tupple)
    }
    
    
}
