//
//  StoryboardInitializable.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

extension StoryboardInitializable where Self: SwivelTabBarController {

    // For Bottom Navigation Bar
    static func initFromStoryboardEmbedInNav(name: String = "Main", window: UIWindow?) -> UINavigationController {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let nctbc           = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        nctbc.window        = window
        return UINavigationController(rootViewController: nctbc)
    }
}

extension StoryboardInitializable where Self: BaseSuperVC {
    
    static func initCoordinatorFromStoryboard(name: String = "Main", withViewModel: BaseVM, type: BaseTabItemCoordinator.Type, window: UIWindow, nav: UINavigationController) -> BaseTabItemCoordinator {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let vc              = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        vc.baseViewModel    = withViewModel
        return type.init(window: window, navigationController: nav, rootVC: vc)
    }
    
    static func initFromStoryboardEmbedInNVC(name: String = "Main", withViewModel: BaseVM) -> UINavigationController {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let vc              = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        vc.baseViewModel    = withViewModel
        
        return UINavigationController(rootViewController: vc)
    }
    
    static func initFromStoryboard(name: String = "Main", withViewModel: BaseVM) -> Self {
        let storyboard      = UIStoryboard(name: name, bundle: Bundle.main)
        let vc              = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        vc.baseViewModel    = withViewModel
        
        return vc
    }
    
}

extension StoryboardInitializable where Self: UIPageViewController {

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}

extension StoryboardInitializable where Self: UITableViewController {

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}
