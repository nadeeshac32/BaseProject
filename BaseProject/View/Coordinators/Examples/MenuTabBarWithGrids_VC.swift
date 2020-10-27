//
//  MenuTabBarWithGrid_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift

class MenuTabBarWithGridsVC: BaseMenuVC<BaseMenuVM, SwivelManuTabCell_Circle> {
    
    @IBOutlet weak var _menuBarView: UIView!
    
    var navBar                                                  : UINavigationBar?
    var addCustomerBtn                                          = NCUIMaker.getButtonWith(imageName: "icon_addContact")
    var menuTabs                                                : [BaseMenuTabProtocol] = [NonDynemicListVC]()
    
    deinit {
        print("deinit MenuTabBarWithGridsVC")
    }
    
    var nonDynemicGridVM                                        : NonDynemicCollectionVM?
    var dynemicGridVM                                           : DynemicCollectionVM?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func customiseView() {
        
        nonDynemicGridVM                                        = NonDynemicCollectionVM()
        let nonDynemicGridVC                                    = NonDynemicCollectionVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: nonDynemicGridVM!)
        menuTabs.append(nonDynemicGridVC)
        
        dynemicGridVM                                           = DynemicCollectionVM()
        let dynemicGridVC                                       = DynemicCollectionVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: dynemicGridVM!)
        menuTabs.append(dynemicGridVC)
        
        super.customiseView(menuBarView: _menuBarView)
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Outputs
                
                // MARK: - Inputs
                viewModel.setupTitleViewInViewDidAppear.subscribe(onNext: { [weak self] (_) in
                    self?.setupTitleView()
                }),
                viewModel.removeTitleViewInViewWillDisappear.subscribe(onNext: { [weak self] (_) in
                    self?.removeTitleView()
                })
            ])
        }
    }
    
    override func getTabNames() -> [MenuTabCellAttributes] {
        return [MenuTabCellAttributes(title: "Non Dynemic Grid", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary),
                MenuTabCellAttributes(title: "Dynemic Grid", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary)]
    }
    
    override func getMenuTabViewControllerFor(index: Int) -> BaseMenuTabProtocol? {
        if index >= menuTabs.count || index >= getTabNames().count { return nil }
        return menuTabs[index]
    }
    
    // MARK: - Class methods
    func setupTitleView() {
        self.navBar                                             = self.navigationController?.navigationBar
        self.navBar?.topItem?.titleView                         = nil
        self.navBar?.topItem?.title                             = "Grid Views"
        self.navBar?.topItem?.rightBarButtonItem                = UIBarButtonItem(customView: addCustomerBtn)
        self.removeLeftButton()
    }
    
    func removeTitleView() {
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.removeLeftButton()
        self.removeRightButton()
    }
    
}
