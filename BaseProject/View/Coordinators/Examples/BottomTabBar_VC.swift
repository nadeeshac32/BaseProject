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
    
    var blogHomeCoordinator                     : BlogCoordinator!
    var listGridCoordinator                     : ListGridCoordinator!
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
        let manuTabBarWithListsGridsVM          = BaseMenuVM()
        
        blogHomeCoordinator                     = BlogFeedVC.initCoordinatorFromStoryboard(name: Storyboards.example.rawValue, withViewModel: blogFeedVM, type: BlogCoordinator.self, window: window, nav: nav) as? BlogCoordinator
        blogHomeCoordinator.initialiseVC()
        let blogFeedTabBarItem                  = SwivelTabBarItem(icon: UIImage(named: "icon_social_feed")!, selectedIcon: UIImage(named: "icon_social_feed_active")!, title: "Feed", viewController: blogHomeCoordinator.rootVC!)

        listGridCoordinator                     = ManuTabBarWithListsGridsVC.initCoordinatorFromStoryboard(name: Storyboards.example.rawValue, withViewModel: manuTabBarWithListsGridsVM, type: ListGridCoordinator.self, window: window, nav: nav) as? ListGridCoordinator
        listGridCoordinator.initialiseVC()
        let listTabBarItem                      = SwivelTabBarItem(icon: UIImage(named: "icon_list")!, selectedIcon: UIImage(named: "icon_list_active")!, title: "List & Grid", viewController: listGridCoordinator.rootVC!)


        
        // MARK: - Sample Navigation between coordinators
        disposeBag.insert([
//            // MARK: - Coordinator to Coordinator communication
//            manuTabBarWithListsGridsVM.doWithSelectedItem.subscribe(onNext: { [weak self] (exampleModel) in
//                self?.gridCoordinator.goToExampleVC(exampleModel: exampleModel)
//            }),
//
//            listGridCoordinator.showExampleVC.subscribe(onNext: { [weak self] (exampleModel) in
//                self?.gridCoordinator.goToExampleVC(exampleModel: exampleModel)
//            }),
//            listCoordinator.showAnotherBottomTabBarItem.subscribe(onNext: { [weak self] (_) in
//                self?.navigationController?.popToRootViewController(animated: true)
//                self?.moveToTab(withIndex: 2)
//            }),

            // MARK: - Logout user mapped by Coordinator
            blogHomeCoordinator.showSignInVC.subscribe(onNext: { [weak self] (_) in
                self?.viewModel?.gotoSignin.onNext(true)
            }),
            listGridCoordinator.showSignInVC.subscribe(onNext: { [weak self] (_) in
                self?.viewModel?.gotoSignin.onNext(true)
            })
        ])

        var tabBarItems                         = [SwivelTabBarItem]()
        tabBarItems.append(blogFeedTabBarItem)
        tabBarItems.append(listTabBarItem)
//        tabBarItems.append(profileTabBarItem)

        setupView(items: tabBarItems, normalColor: .darkGray, selectedColor: #colorLiteral(red: 0.3415962458, green: 0.3084948957, blue: 0.6030117869, alpha: 1))
        
    }
    
}
