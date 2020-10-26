//
//  BlogFeed_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

class BlogFeedVC: BaseListWithoutHeadersVC<BlogPost, BlogFeedVM, BlogPostTVCell> {

    @IBOutlet weak var _tableView   : UITableView!

    override var shouldSetRowHeight : Bool { get { return false } set {} }
    
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
                    self?.navigationController?.navigationBar.topItem?.title        = "Blog Feed"
                }),
                viewModel.removeTitleViewInViewWillDisappear.subscribe(onNext: { [weak self] (_) in
                    self?.navigationController?.navigationBar.topItem?.titleView    = nil
                })
                
            ])
        }
    }
    
    
}
