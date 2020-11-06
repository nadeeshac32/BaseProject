//
//  BlogDetail_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogDetailVC: BaseFormVC<BlogDetailVM> {
    
    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
    
    override var dynemicGapShouldCalculate                  : Bool { get { return false } set {} }
    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 475 } set {} }
    override var scrollViewMinimumDynemicGap                : CGFloat { get { return 50 } set {} }
    override var scrollViewBottomConsRealValue              : CGFloat { get { return 34 } set {} }
 
    deinit { print("deinit BlogDetailVC") }
        
    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        self.addBackButton(title: self.previousVCTitle?.localized() ?? "Back")
        
        //  if let imageGridViewModel = viewModel?.contentGridViewModel {
        //      self.contentGrid                                = BlogCreateContentGrid(viewModel: imageGridViewModel, collectionView: _contentCV, delegate: self)
        //      contentGrid?.setupBindings()
        //  }
    }
    
    override func setupBindings() {
        super.setupBindings()
        //  if let viewModel = self.viewModel { disposeBag.insert([]) }
    }
}


extension BlogDetailVC: BaseGridDelagate {
    func getNoItemsText(_ collectionView: UICollectionView) -> String {
        return ""
    }
}
