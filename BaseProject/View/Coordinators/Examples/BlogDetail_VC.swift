//
//  BlogDetail_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import Agrume
import DropDown
import AVKit

class BlogDetailVC: BaseVC<BlogDetailVM>, BaseListDelagate, UIGestureRecognizerDelegate, UITextFieldDelegate {    //BaseFormVC<BlogDetailVM>, BaseListDelagate {
    
//    @IBOutlet public weak var _scrollView                   : BaseScrollView!
//    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
//    @IBOutlet public weak var _submitButton                 : UIButton!
//    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
    
    @IBOutlet public weak var _contentTV                    : UITableView!
    var contentTV                                           : BlogDetailTV?
    @IBOutlet weak var commentTxtFld                        : UITextField!
    @IBOutlet weak var sendBtn                              : UIButton!
    @IBOutlet weak var commentingVwBottomCons               : NSLayoutConstraint!
    
//    override var dynemicGapShouldCalculate                  : Bool { get { return false } set {} }
//    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 475 } set {} }
//    override var scrollViewMinimumDynemicGap                : CGFloat { get { return 50 } set {} }
//    override var scrollViewBottomConsRealValue              : CGFloat { get { return 34 } set {} }
 
    
    var customRightButton                                   = SwivelUIMaker.makeButtonWith(imageName: "icon_more")
    let dropDown                                            = DropDown()
    
    deinit { print("deinit BlogDetailVC") }
        
    override func customiseView() {
        super.customiseView()
        self.addBackButton(title: "Back")
        customRightButton.imageEdgeInsets                   = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let rightBarButtonItem                              = UIBarButtonItem(customView: self.customRightButton)
        self.navigationItem.rightBarButtonItem              = rightBarButtonItem
        customRightButton.addTarget(self, action: #selector(dropDownBtnTapped), for: .touchUpInside)
        
        dropDown.anchorView     = rightBarButtonItem
        dropDown.direction      = .bottom
        dropDown.width          = 100
        dropDown.bottomOffset   = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource     = ["Edit", "Delete"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.viewModel?.editBlogTapped.onNext(true)
            } else if index == 1 {
                self.viewModel?.deleteBtnTapped()
            }
        }
        
        if let contentTableViewModel = viewModel?.contentTableViewModel {
            self.contentTV                                  = BlogDetailTV(viewModel: contentTableViewModel, tableView: _contentTV, delegate: self)
            contentTV?.setupBindings()
        }
        
        let tap                     = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        tap.cancelsTouchesInView    = false
        self._contentTV.addGestureRecognizer(tap)
        
        commentTxtFld.delegate  = self
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        if commentingVwBottomCons.constant != 0 {
            self.viewModel?.contentTableViewModel?.endCommenting.onNext(true)
        }
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            disposeBag.insert([
                viewModel.adjustForKeyboardHeightChange.subscribe(onNext: { [weak self] (keyboardHeight) in
                    if keyboardHeight == 0 {
                        viewModel.contentTableViewModel?.setForNormalComment()
                    }
                    self?.commentingVwBottomCons.constant   = keyboardHeight
                    UIView.animate(withDuration: 1.5, animations: { [weak self] in
                         self?.view.layoutIfNeeded()
                    })
                })
            ])
        }
        
        if let tvViewModel = viewModel?.contentTableViewModel {
            disposeBag.insert([
                // MARK: - Outputs
                commentTxtFld.rx.text.orEmpty.bind(to: tvViewModel.comment),
                
                // MARK: - inputs
                sendBtn.rx.tap.bind(onNext: tvViewModel.performCommentRequest),
                tvViewModel.showShareBlogOptions.subscribe(onNext: { [weak self] (sharebles) in
                    let ac                                  = UIActivityViewController(activityItems: sharebles, applicationActivities: nil)
                    self?.present(ac, animated: true)
                }),
                tvViewModel.displayContent.subscribe(onNext: { [weak self] (url) in
                    self?.displayMediaFrom(url: url)
                }),
                tvViewModel.newCommentWithPlaceholder.subscribe(onNext: { [weak self] (placeholder) in
                    self?.commentTxtFld.placeholder         = placeholder
                    self?.commentTxtFld.becomeFirstResponder()
                }),
                tvViewModel.endCommentWithPlaceholder.subscribe(onNext: { [weak self] (placeHolder) in
                    self?.commentTxtFld.placeholder         = placeHolder
                    self?.commentTxtFld.text                = ""
                    self?.view.endEditing(true)
                }),
                tvViewModel.editCommentWithPlaceholder.subscribe(onNext: { [weak self] (customise) in
                    self?.commentTxtFld.text                = customise.comment
                    self?.commentTxtFld.placeholder         = customise.placeholder
                    self?.commentTxtFld.becomeFirstResponder()
                }),
                tvViewModel.isEnable.subscribe(onNext: { [weak self] (enable) in
                    self?.sendBtn.isEnabled                 = enable
                })
            ])
        }
    }
    
    @objc func dropDownBtnTapped() {
        dropDown.show()
    }
    
}
