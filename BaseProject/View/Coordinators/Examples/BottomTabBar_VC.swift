//
//  BottomTabBar_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BottomTabBarVC: SwivelTabBarController, StoryboardInitializable {

    private let disposeBag                      = DisposeBag()
    var viewModel                               : BottomTabBarVM?
    
    var blogCoordinator                         : BlogCoordinator!
    var listCoordinator                         : ListCoordinator!
    var gridCoordinator                         : GridCoordinator!
//    var profileCoordinator                      : ProfileCoordinator!
    
    deinit {
        print("deinit BottomTabBarVC")
    }
    
    var isDarkStatusBar: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.4) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let window = window, let nav = self.navigationController else { return }

        let blogFeedVM                          = BlogFeedVM()
        let manuTabBarWithListsVM               = BaseMenuVM()
        let menuTabBarWithGridsVM               = BaseMenuVM()
        
        blogCoordinator                         = BlogFeedVC.initCoordinatorFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogFeedVM, type: BlogCoordinator.self, window: window, nav: nav) as? BlogCoordinator
        blogCoordinator.initialiseVC()
        let blogFeedTabBarItem                  = SwivelTabBarItem(icon: UIImage(named: "icon_social_feed")!, selectedIcon: UIImage(named: "icon_social_feed_active")!, title: "Feed", viewController: blogCoordinator.rootVC!)

        listCoordinator                         = ManuTabBarWithListsVC.initCoordinatorFromStoryboard(name: Storyboards.example.rawValue, withViewModel: manuTabBarWithListsVM, type: ListCoordinator.self, window: window, nav: nav) as? ListCoordinator
        listCoordinator.initialiseVC()
        let listTabBarItem                      = SwivelTabBarItem(icon: UIImage(named: "icon_list")!, selectedIcon: UIImage(named: "icon_list_active")!, title: "List", viewController: listCoordinator.rootVC!)


        gridCoordinator                         = MenuTabBarWithGridsVC.initCoordinatorFromStoryboard(name: Storyboards.example.rawValue, withViewModel: menuTabBarWithGridsVM, type: GridCoordinator.self, window: window, nav: nav) as? GridCoordinator
        gridCoordinator.initialiseVC()
        let gridTabBarItem                      = SwivelTabBarItem(icon: UIImage(named: "icon_grid")!, selectedIcon: UIImage(named: "icon_grid_active")!, title: "Grid", viewController: gridCoordinator.rootVC!)


        // MARK: - Sample Navigation between coordinators
        disposeBag.insert([
//            // MARK: - Coordinator to Coordinator communication
//            manuTabBarWithListsVM.doWithSelectedItem.subscribe(onNext: { [weak self] (exampleModel) in
//                self?.gridCoordinator.goToExampleVC(exampleModel: exampleModel)
//            }),
//
//            listCoordinator.showExampleVC.subscribe(onNext: { [weak self] (exampleModel) in
//                self?.gridCoordinator.goToExampleVC(exampleModel: exampleModel)
//            }),
//            listCoordinator.showAnotherBottomTabBarItem.subscribe(onNext: { [weak self] (_) in
//                self?.navigationController?.popToRootViewController(animated: true)
//                self?.moveToTab(withIndex: 2)
//            }),

            // MARK: - Logout user mapped by Coordinator
            blogCoordinator.showSignInVC.subscribe(onNext: { [weak self] (_) in
                self?.viewModel?.gotoSignin.onNext(true)
            }),
            listCoordinator.showSignInVC.subscribe(onNext: { [weak self] (_) in
                self?.viewModel?.gotoSignin.onNext(true)
            }),
            gridCoordinator.showSignInVC.subscribe(onNext: { [weak self] (_) in
                self?.viewModel?.gotoSignin.onNext(true)
            })
        ])

        var tabBarItems                         = [SwivelTabBarItem]()
        tabBarItems.append(blogFeedTabBarItem)
        tabBarItems.append(listTabBarItem)
        tabBarItems.append(gridTabBarItem)
//        tabBarItems.append(profileTabBarItem)

        setupView(items: tabBarItems, normalColor: .darkGray, selectedColor: #colorLiteral(red: 0.3415962458, green: 0.3084948957, blue: 0.6030117869, alpha: 1))
        
    }
    
}
