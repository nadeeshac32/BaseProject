//
//  BlogCreateEdit_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

//class BlogCreateEditVC: BaseGridWithoutHeadersVC<BlogContent, BlogCreateEditVM, BlogCreateImageCVCell> {
class BlogCreateEditVC: BaseFormVC<BlogCreateEditVM> {

//    @IBOutlet weak var _collectionView  : UICollectionView!
//    override var shouldSetCellSize      : Bool { get { return false } set {} }
    
    deinit { print("deinit BlogCreateEditVC") }
    
//    override func getNoItemsText() -> String {
//        return "No Content added."
//    }
//
//    override func customiseView() {
//        super.customiseView(collectionView: _collectionView, multiSelectable: true)
//    }
//
//    override func getItemSize() -> CGSize {
//        super.getItemSize()
//    }
    
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
