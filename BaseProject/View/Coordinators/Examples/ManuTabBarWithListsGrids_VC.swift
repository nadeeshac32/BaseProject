//
//  ManuTabBarWithListsGrids_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/18/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift

class ManuTabBarWithListsGridsVC: BaseMenuVC<BaseMenuVM, NCManuTabCell_Circle> {
    
    @IBOutlet weak var _menuBarView                             : UIView!
    
    var navBar                                                  : UINavigationBar?
    var menuTabs                                                : [BaseMenuTabProtocol] = [NonDynemicListVC]()
    
    deinit {
        print("deinit ManuTabBarWithListsGridsVC")
    }
    
    var nonDynemicListVM                                        : NonDynemicListVM?
    var dynemicListVM                                           : DynemicListVM?
    var nonDynemicGridVM                                        : NonDynemicCollectionVM?
    var dynemicGridVM                                           : DynemicCollectionVM?
    
    // MARK: - Overrides
    override func customiseView() {
        nonDynemicListVM                                        = NonDynemicListVM()
        let nonDynemicListVC                                    = NonDynemicListVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: nonDynemicListVM!)
        nonDynemicListVM!.doWithSelectedItem.subscribe(onNext: { (customer) in
            print("pass to the `ManuTabBarVM` viewmodel")
        }).disposed(by: disposeBag)
        menuTabs.append(nonDynemicListVC)
        
        
        dynemicListVM                                           = DynemicListVM()
        let dynemicListVC                                       = DynemicListVC.initFromStoryboard(name: Storyboards.example.rawValue, withViewModel: dynemicListVM!)
        dynemicListVM!.doWithSelectedItem.subscribe(onNext: { (customer) in
            print("pass to the `ManuTabBarVM` viewmodel")
        }).disposed(by: disposeBag)
        menuTabs.append(dynemicListVC)
        
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
        return [
            MenuTabCellAttributes(title: "List Static", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary),
            MenuTabCellAttributes(title: "List Dynemic", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary),
            MenuTabCellAttributes(title: "Non Dynemic Grid", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary),
            MenuTabCellAttributes(title: "Dynemic Grid", titleColor: AppConfig.si.colorPrimary, highLighter: AppConfig.si.colorPrimary)
        ]
    }
    
    override func getMenuTabViewControllerFor(index: Int) -> BaseMenuTabProtocol? {
        if index >= menuTabs.count || index >= getTabNames().count { return nil }
        return menuTabs[index]
    }
    
    // MARK: - Class methods
    func setupTitleView() {
        self.navBar                                             = self.navigationController?.navigationBar
        self.navBar?.topItem?.titleView                         = nil
        self.navBar?.topItem?.title                             = "List & Grids"
        self.removeRightButton()
        self.removeLeftButton()
    }
    
    func removeTitleView() {
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.removeLeftButton()
        self.removeRightButton()
    }
    
}
