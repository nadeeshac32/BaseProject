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
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel?.contentTableViewModel {
            disposeBag.insert([
                viewModel.showShareBlogOptions.subscribe(onNext: { [weak self] (sharebles) in
                    let ac                                  = UIActivityViewController(activityItems: sharebles, applicationActivities: nil)
                    self?.present(ac, animated: true)
                }),
                viewModel.displayContent.subscribe(onNext: { (url) in
                    let agrume = Agrume(url: URL(string: url)!)
                    agrume.download = { url, completion in
                        let httpService = HTTPService()
                        httpService.downloadImage(imagePath: url.absoluteString) { (image) in
                            guard let image = image else { return }
                            completion(image)
                        }
                    }
                    agrume.show(from: self)
                })
            ])
        }
    }
    
    @objc func dropDownBtnTapped() {
        dropDown.show()
    }
    
}
