//
//  BlogDetail_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogDetailVC: BaseVC<BlogDetailVM>, BaseListDelagate {    //BaseFormVC<BlogDetailVM>, BaseListDelagate {
    
//    @IBOutlet public weak var _scrollView                   : BaseScrollView!
//    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
//    @IBOutlet public weak var _submitButton                 : UIButton!
//    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
    
    @IBOutlet public weak var _contentTV                    : UITableView!
    var contentTV                                           : BlogDetailTV?
    
//    override var dynemicGapShouldCalculate                  : Bool { get { return false } set {} }
//    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 475 } set {} }
//    override var scrollViewMinimumDynemicGap                : CGFloat { get { return 50 } set {} }
//    override var scrollViewBottomConsRealValue              : CGFloat { get { return 34 } set {} }
 
    deinit { print("deinit BlogDetailVC") }
        
    override func customiseView() {
        super.customiseView()
        self.addBackButton(title: "Back")
        
          if let contentTableViewModel = viewModel?.contentTableViewModel {
              self.contentTV                                = BlogDetailTV(viewModel: contentTableViewModel, tableView: _contentTV, delegate: self)
              contentTV?.setupBindings()
          }
    }
    
    override func setupBindings() {
        super.setupBindings()
        //  if let viewModel = self.viewModel { disposeBag.insert([]) }
    }
}
