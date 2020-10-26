//
//  Onboarding_PVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

protocol OnboardingPVCDelegate: class {
    /**
     Called when the number of pages is updated.
     - parameter count: the total number of pages.
     */
    func onboardingPVC(didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     - parameter index: the index of the currently visible page.
     */
    func onboardingPVC(didUpdatePageIndex index: Int)

}

class OnboardingPVC: UIPageViewController, StoryboardInitializable {

    weak var onboardingPVCDelegate: OnboardingPVCDelegate?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        
        let viewController1     = OnboardingImageVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        let screen1part1        = "onboarding screen 1 text Part1\n".localized()
        let screen1part2        = "onboarding screen 1 text Part2".localized()
        let attributedString1   = NSMutableAttributedString(string: "\(screen1part1)\(screen1part2)")
        attributedString1.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .regular), range: NSRange(location: 0, length: screen1part1.count))
        viewController1.setImage(withName: "image_onboarding1", attributedString: attributedString1)
        
        let viewController2     = OnboardingImageVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        let screen2part1        = "onboarding screen 2 text Part1\n".localized()
        let screen2part2        = "onboarding screen 2 text Part2".localized()
        let attributedString2   = NSMutableAttributedString(string: "\(screen2part1)\(screen2part2)")
        attributedString2.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .regular), range: NSRange(location: 0, length: screen2part1.count))
        viewController2.setImage(withName: "image_onboarding2", attributedString: attributedString2)
        
        
        let viewController3     = OnboardingImageVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        let screen3part1        = "onboarding screen 3 text Part1\n".localized()
        let screen3part2        = "onboarding screen 3 text Part2".localized()
        let attributedString3   = NSMutableAttributedString(string: "\(screen3part1)\(screen3part2)")
        attributedString3.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .regular), range: NSRange(location: 0, length: screen3part1.count))
        viewController3.setImage(withName: "image_onboarding3", attributedString: attributedString3)
        
        
        let viewController4     = OnboardingImageVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        let screen4part1        = "onboarding screen 4 text Part1\n".localized()
        let screen4part2        = "onboarding screen 4 text Part2".localized()
        let attributedString4   = NSMutableAttributedString(string: "\(screen4part1)\(screen4part2)")
        attributedString4.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .regular), range: NSRange(location: 0, length: screen4part1.count))
        viewController4.setImage(withName: "image_onboarding4", attributedString: attributedString4)
        
        return [viewController1, viewController2, viewController3, viewController4]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource              = self
        delegate                = self
        
        onboardingPVCDelegate?.onboardingPVC(didUpdatePageCount: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func moveForwarToPageWith(index: Int) {
        if index < orderedViewControllers.count {
            let destinationPageViewController   = orderedViewControllers[index]
            setViewControllers([destinationPageViewController], direction: .forward, animated: true) { (completed) in
                self.onboardingPVCDelegate?.onboardingPVC(didUpdatePageIndex: index)
            }
        }
    }

}

// MARK: UIPageViewControllerDataSource
extension OnboardingPVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex           = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex                       = viewControllerIndex - 1
        
        // the last view controller.
        guard previousIndex >= 0 else {
            //  return orderedViewControllers.last      // User is on the first view controller and swiped left to loop again
            return nil                                  // stop looping
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex           = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex                           = viewControllerIndex + 1
        let orderedViewControllersCount         = orderedViewControllers.count
        
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //  return orderedViewControllers.first         // User is on the last view controller and swiped right to loop again
            return nil                                      // stop looping
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}


extension OnboardingPVC: UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first, let index = orderedViewControllers.firstIndex(of: firstViewController) {
            onboardingPVCDelegate?.onboardingPVC(didUpdatePageIndex: index)
        }
    }
}
