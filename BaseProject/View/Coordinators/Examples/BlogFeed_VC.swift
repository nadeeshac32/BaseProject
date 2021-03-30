//
//  BlogFeed_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources
import Agrume

class BlogFeedVC: BaseListWithoutHeadersVC<Blog, BlogFeedVM, BlogTVCell> {

    @IBOutlet weak var _tableView                               : UITableView!
    override var shouldSetRowHeight                             : Bool { get { return false } set {} }
    override var cellLoadFromNib                                : Bool { get { return true } set {} }
    
    var customRightButton                                       = NCUIMaker.makeButtonWith(text: "Add", width: 100)
    var customLeftButton                                        = NCUIMaker.makeButtonWith(text: "Logout", width: 100)
    
    deinit { print("deinit BlogFeedVC") }
    
    override func getNoItemsText() -> String {
        return "No Posts Available."
    }
    
    override func customiseView() {
        super.customiseView(tableView: _tableView, multiSelectable: false)
    }
    
    override func getCellHeight() -> CGFloat {
        return 458
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.setupTitleViewInViewDidAppear.subscribe(onNext: { [weak self] (_) in
                    guard let self = `self` else { return }
                    self.navigationController?.navigationBar.topItem?.title                 = viewModel.blogFeedType == .home ? "Blog Feed" : "My Space"
                    let rightButton                                                         = UIBarButtonItem(customView: self.customRightButton)
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem    = rightButton
                    
                    let leftButton                                                          = UIBarButtonItem(customView: self.customLeftButton)
                    self.navigationController?.navigationBar.topItem?.leftBarButtonItem     = viewModel.blogFeedType == .home ? leftButton : nil
                }),
                viewModel.removeTitleViewInViewWillDisappear.subscribe(onNext: { [weak self] (_) in
                    self?.navigationController?.navigationBar.topItem?.titleView            = nil
                    self?.navigationController?.navigationBar.topItem?.rightBarButtonItem   = nil
                    self?.navigationController?.navigationBar.topItem?.leftBarButtonItem    = nil
                }),
                viewModel.showShareBlogOptions.subscribe(onNext: { [weak self] (items) in
                    let ac                                                                  = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    self?.present(ac, animated: true)
                }),
                
                // MARK: - Outputs
                customRightButton.rx.tap.bind(to: viewModel.addBlogHasTapped),
                customLeftButton.rx.tap.bind(onNext: viewModel.logoutUser)
            ])
        }
    }
    
}

extension BlogFeedVC: BlogTVCellDelegate {
    func likeError(restError: RestClientError) {
        viewModel?.handleRestClientError(error: restError)
    }
    
    func shareTappedFor(blog: Blog) {
        viewModel?.shareBlogHasTapped.onNext(blog)
    }
    
    func commentTappedFor(blog: Blog) {
        viewModel?.doWithSelectedItem.onNext(blog)
    }
    
    func tappedOnContentWith(url: String) {
        self.displayMediaFrom(url: url)
    }
}
