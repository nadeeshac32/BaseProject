//
//  BlogFeed_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

class BlogFeedVC: BaseListWithoutHeadersVC<Blog, BlogFeedVM, BlogPostTVCell> {

    @IBOutlet weak var _tableView   : UITableView!
    override var shouldSetRowHeight : Bool { get { return false } set {} }
    
    var customRightButton                                       = SwivelUIMaker.makeButtonWith(text: "Add", width: 100)
    var customLeftButton                                        = SwivelUIMaker.makeButtonWith(text: "Logout", width: 100)
    
    deinit { print("deinit BlogFeedVC") }
    
    override func getNoItemsText() -> String {
        return "No Posts Available."
    }
    
    override func customiseView() {
        super.customiseView(tableView: _tableView, multiSelectable: false)
    }
    
    override func getCellHeight() -> CGFloat {
        return 435
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.setupTitleViewInViewDidAppear.subscribe(onNext: { [weak self] (_) in
                    guard let self = `self` else { return }
                    self.navigationController?.navigationBar.topItem?.title                 = "Blog Feed"
                    let rightButton                                                         = UIBarButtonItem(customView: self.customRightButton)
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem    = rightButton
                    
                    let leftButton                                                          = UIBarButtonItem(customView: self.customLeftButton)
                    self.navigationController?.navigationBar.topItem?.leftBarButtonItem     = leftButton
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

extension BlogFeedVC: BlogDelegate {
    func likeError(restError: RestClientError) {
        viewModel?.handleRestClientError(error: restError)
    }
    
    func shareTappedFor(blog: Blog) {
        viewModel?.shareBlogHasTapped.onNext(blog)
    }
}
