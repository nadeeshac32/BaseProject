//
//  SwivelTabBarController.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

/// This is a base class for Bottom tab bar controller.
/// You only have to call `setupView` method from the subclass.
class SwivelTabBarController: UITabBarController {
    
    weak var window                         : UIWindow?
    var swivelTabBar                        : SwivelTabBar!
    var selectedColor                       = UIColor.darkGray
    var normalColor                         = UIColor.lightGray {
        didSet {
            swivelTabBar.tintColor          = normalColor
        }}
    
    private var swivelTabBarHeight: CGFloat = 84
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  tabBar.isHidden                 = true
        tabBar.alpha                        = 0
        view.backgroundColor                = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabBar.frame.size.height            = swivelTabBarHeight
        tabBar.frame.origin.y               = view.frame.height - swivelTabBarHeight
    }
    
    func setupView(items: [SwivelTabBarItem], normalColor: UIColor, selectedColor: UIColor) {
        
        self.selectedColor                  = selectedColor
        setTabBar(items: items)
        
        self.normalColor                    = normalColor
        let viewControllers                 = items.map { $0.viewController! }
        self.viewControllers                = viewControllers
    }

    private func setTabBar(items: [SwivelTabBarItem], height: CGFloat? = nil) {
        guard items.count > 0 else { return }

        swivelTabBar                        = SwivelTabBar(items: items)
        guard let bar                       = swivelTabBar else { return }
        
        swivelTabBar.tintColor              = normalColor
        swivelTabBar.tabItems.first?.color  = selectedColor
        
        view.addSubviews(views: bar)
        bar.horizontal(toView: view)
        bar.bottom(toView: view)
        swivelTabBarHeight                  = height ?? swivelTabBarHeight
        bar.height(swivelTabBarHeight)
        
        for i in 0 ..< items.count {
            items[i].tag = i
            items[i].addTarget(self, action: #selector(switchTab), for: .touchUpInside)
        }
    }

    @objc func switchTab(button: UIButton) {
        let newIndex                        = button.tag
        changeTab(from: selectedIndex, to: newIndex)
    }
    
    func moveToTab(withIndex: Int) {
        if swivelTabBar.tabItems.count > withIndex, selectedIndex != withIndex {
            changeTab(from: selectedIndex, to: withIndex)
        }
    }
    
    private var isAnimating = false
    private func changeTab(from fromIndex: Int, to toIndex: Int) {
        guard isAnimating == false else { return }
        swivelTabBar.tabItems[fromIndex].color      = normalColor
        swivelTabBar.tabItems[toIndex].color        = selectedColor
        swivelTabBar.tabItems[fromIndex].isForcused = false
        swivelTabBar.tabItems[toIndex].isForcused   = true
        animateSliding(from: fromIndex, to: toIndex)
    }
    
    func animateSliding(from fromIndex: Int, to toIndex: Int) {
        guard fromIndex                    != toIndex else { return }
        guard let fromController            = viewControllers?[fromIndex], let toController = viewControllers?[toIndex] else { return }
        let fromView                        = fromController.view!
        let toView                          = toController.view!
        let viewSize                        = fromView.frame
        let scrollRight                     = fromIndex < toIndex
        fromView.superview?.addSubview(toView)
        toView.frame                        = CGRect(x: scrollRight ? screenWidth : -screenWidth,
                                                     y: viewSize.origin.y,
                                                     width: screenWidth,
                                                     height: viewSize.height)
        
        func animate() {
            isAnimating                     = true
            fromView.frame                  = CGRect(x: scrollRight ? -screenWidth : screenWidth,
                                                     y: viewSize.origin.y,
                                                     width: screenWidth,
                                                     height: viewSize.height)
            toView.frame                    = CGRect(x: 0,
                                                     y: viewSize.origin.y,
                                                     width: screenWidth,
                                                     height: viewSize.height)
        }
        
        func finished(_ completed: Bool) {
            fromView.removeFromSuperview()
            selectedIndex = toIndex
            isAnimating                     = false
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: animate, completion: finished)
    }
    
}
