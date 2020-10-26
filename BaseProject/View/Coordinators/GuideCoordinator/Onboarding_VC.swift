//
//  Onboarding_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingVC: UIViewController, StoryboardInitializable {

    @IBOutlet weak var containerView                        : UIView!
    @IBOutlet weak var pageControllerDots                   : UIPageControl!
    @IBOutlet weak var skipBtn                              : UIButton!
    @IBOutlet weak var nextBtn                              : UIButton!
    @IBOutlet weak var endOnboardingBtn                     : UIButton!
    
    private let disposeBag                                  = DisposeBag()
    var viewModel                                           : OnboardingVM!
    var pageViewController                                  : OnboardingPVC?
    
    deinit {
        print("deinit OnboardingVC")
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden    = true
        pageViewController                                  = OnboardingPVC.initFromStoryboard(name: Storyboards.signup.rawValue)
        pageViewController!.onboardingPVCDelegate           = self
        self.containerView.setConstraintsFor(contentView: pageViewController!.view, left: true, top: true, right: true, bottom: true)
        self.addChild(pageViewController!)
        pageViewController!.didMove(toParent: self)
        
        skipBtn.setTitleColor(AppConfig.si.colorPrimary, for: .normal)
        nextBtn.setTitleColor(AppConfig.si.colorPrimary, for: .normal)
        
        endOnboardingBtn.addBoarder(width: 1, cornerRadius: 3, color: AppConfig.si.colorPrimary)
        endOnboardingBtn.backgroundColor                    = AppConfig.si.colorPrimary
        endOnboardingBtn.setTitleColor(.white, for: .normal)
        endOnboardingBtn.alpha                              = 0.0
    }
    
    private func setupBindings() {
        // MARK: - Outputs
        endOnboardingBtn.rx.tap
            .bind(to: viewModel.endOnboarding)
            .disposed(by: disposeBag)
        
        skipBtn.rx.tap
            .bind(to: viewModel.skip)
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind(to: viewModel.next)
            .disposed(by: disposeBag)
        
        // MARK: - inputs
        viewModel.appearGetStartedBtn.subscribe(onNext: { [weak self] (appearGetStartedBtn) in
                UIView.animate(withDuration: 0.4, animations: { [weak self] in
                    self?.endOnboardingBtn.alpha            = appearGetStartedBtn ? 1.0 : 0.0
                    self?.nextBtn.alpha                     = appearGetStartedBtn ? 0.0 : 1.0
                    self?.skipBtn.alpha                     = appearGetStartedBtn ? 0.0 : 1.0
                })
            }).disposed(by: disposeBag)
        
        viewModel.moveToPageWithIndex.subscribe(onNext: { (toIndex) in
                if let toIndex = toIndex {
                    self.pageViewController?.moveForwarToPageWith(index: toIndex)
                }
            }).disposed(by: disposeBag)
    }
}

extension OnboardingVC: OnboardingPVCDelegate {
    func onboardingPVC(didUpdatePageCount count: Int) {
        pageControllerDots.numberOfPages                    = count
    }
    
    func onboardingPVC(didUpdatePageIndex index: Int) {
        pageControllerDots.currentPage                      = index
        viewModel.pageChangeToIndex.onNext(pageControllerDots.currentPage)
    }
}
