//
//  BaseSuperVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/// This is the Root class of all the ViewControllers
/// All the classes that inherit this class will be Generic classes. Since this is not a generic class we can add extensions using this class.
class BaseSuperVC: UIViewController, StoryboardInitializable, SearchViewAnimateble {

    weak var baseViewModel          : BaseVM?
    let disposeBag                  = DisposeBag()
    var previousVCTitle             : String?
    var isDarkStatusBarContent: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.4) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return self.isDarkStatusBarContent ? .darkContent : .lightContent
        } else {
            print("Not available iOS 13.0, isDarkStatusBarContent: \(isDarkStatusBarContent)")
            return self.isDarkStatusBarContent ? .default : .lightContent
        }
    }
}

protocol SearchViewAnimateble : class { }
extension SearchViewAnimateble where Self: BaseSuperVC {

    func showSearchBar(searchBar : UISearchBar) {
        searchBar.alpha                                                 = 0
        searchBar.backgroundColor                                       = .white
        self.navigationController?.navigationBar.topItem?.setLeftBarButton(nil, animated: false)
        self.navigationController?.navigationBar.topItem?.setRightBarButton(nil, animated: false)
        self.navigationController?.navigationBar.topItem?.titleView     = searchBar
        self.isDarkStatusBarContent                                            = true
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.navigationController?.navigationBar.setGradientBackground(colors: [.white], direction: .leftToRight)
            self?.navigationController?.navigationBar.tintColor          = AppConfig.si.colorPrimary
            searchBar.alpha                                             = 1
            searchBar.becomeFirstResponder()
        }, completion: nil)
    }

    func hideSearchBar(leftBarButtonItem: UIBarButtonItem, searchBarButtonItem: UIBarButtonItem, titleView : UIView? = nil, text: String? = nil) {
        titleView?.alpha                                                = 0
        self.navigationController?.navigationBar.topItem?.titleView     = titleView
        self.navigationController?.navigationBar.topItem?.setLeftBarButton(leftBarButtonItem, animated: true)
        self.navigationController?.navigationBar.topItem?.setRightBarButton(searchBarButtonItem, animated: true)
        self.isDarkStatusBarContent                                            = false
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.navigationController?.navigationBar.setGradientBackground(colors: [AppConfig.si.colorGradient1, AppConfig.si.colorGradient2], direction: .leftToRight)
            self?.navigationController?.navigationBar.tintColor         = .white
            titleView?.alpha                                            = 1
        }, completion: nil)
    }
}
