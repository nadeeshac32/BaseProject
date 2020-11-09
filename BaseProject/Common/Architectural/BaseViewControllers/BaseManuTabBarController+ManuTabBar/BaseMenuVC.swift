//
//  BaseMenuVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

/*
    @IBOutlet weak var _menuBarView                         : NCMenuTab!
*/
protocol BaseMenuTabProtocol: class {
    var tabIndex: Int { get set }
}

/// Base tab bar controller functionality.
/// You only have to override `getTabNames` and `getMenuTabViewControllerFor` functions.
class BaseMenuVC<ViewModel: BaseMenuVM, ManuTabCell: SwivelManuTabCell>: BaseVC<ViewModel>, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    /// Actual tab bar showing the tabs are changing.
    var menuBarView                                         : SwivelManuTab<ManuTabCell>!
    
    var currentIndex                                        = 0
    var tabs                                                : [MenuTabCellAttributes] = []
    var pageController                                      : UIPageViewController!
    
    /// Bind the actual UI MenuBarView with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(menuBarView: UIView!) {
        self.menuBarView                                    = SwivelManuTab<ManuTabCell>(frame: CGRect(x: 0, y: 0, width: menuBarView.frame.width, height: menuBarView.frame.height))
        menuBarView.addSubview(self.menuBarView)
        super.customiseView()
        self.tabs                                           = getTabNames()
        self.menuBarView.dataArray                          = self.tabs
        self.menuBarView.isSizeToFitCellsNeeded             = true
        self.menuBarView.collView.backgroundColor           = UIColor.init(white: 1, alpha: 1)
        
        self.presentPageVCOnView()
        
        self.menuBarView.menuDelegate                       = self
        pageController.delegate                             = self
        pageController.dataSource                           = self
        
        //For Intial Display
        self.menuBarView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        if let vc = viewController(At: 0) {
            self.pageController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // thise two methods should be implemented in your subclasses.
    func getTabNames() -> [MenuTabCellAttributes] {
        fatalError("This method must be overriden by the subclass")
    }
    
    func getMenuTabViewControllerFor(index: Int) -> BaseMenuTabProtocol? {
        fatalError("This method must be overriden by the subclass")
    }
    
    func presentPageVCOnView() {
        self.pageController                                 = SwivelPageViewController.initFromStoryboard(name: Storyboards.common.rawValue)
        self.pageController.view.frame                      = CGRect.init(x: 0,
                                                                          y: menuBarView.frame.height,
                                                                          width: self.view.frame.width,
                                                                          height: self.view.frame.height - menuBarView.frame.maxY)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
    }
    
    // Present viewController at the given index
    func viewController(At index: Int) -> UIViewController? {
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            return nil
        }
        
        let vc                                              = getMenuTabViewControllerFor(index: index)
        let contentVC                                       = vc // as! BaseMenuTabProtocol
        contentVC?.tabIndex                                 = index
        currentIndex                                        = index
        return vc as? UIViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         var index = (viewController as! BaseMenuTabProtocol).tabIndex
         
         if (index == 0) || (index == NSNotFound) {
             return nil
         }
         
         index -= 1
         return self.viewController(At: index)
    }
     
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         var index = (viewController as! BaseMenuTabProtocol).tabIndex
         
         if (index == tabs.count) || (index == NSNotFound) {
             return nil
         }
         
         index += 1
         return self.viewController(At: index)
         
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
         if finished {
            if completed {
                let cvc = pageViewController.viewControllers!.first as! BaseMenuTabProtocol
                let newIndex        = cvc.tabIndex
                self.currentIndex   = cvc.tabIndex
                menuBarView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
}

extension BaseMenuVC: MenuBarDelegate {

    func menuBarDidSelectItemAt(index: Int) {
        // If selected Index is not the selected Selected one, by comparing with current index, page controller goes either forward or backward.
        if index != currentIndex {
            if index > currentIndex {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .reverse, animated: true, completion: nil)
            }
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}
