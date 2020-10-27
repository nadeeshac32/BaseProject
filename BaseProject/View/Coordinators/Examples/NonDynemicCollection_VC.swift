//
//  NonDynemicCollection_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

class NonDynemicCollectionVC: BaseGridWithHeadersVC<Customer, NonDynemicCollectionVM, CustomerContactCVCell, BaseCVSectionHeader>, BaseMenuTabProtocol {
    
    @IBOutlet weak var _collectionView          : UICollectionView!
    
    var tabIndex                                : Int = 0
    
    deinit {
        print("deinit NonDynemicCollectionVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Phonebook contacts available."
    }
    
    override func customiseView() {
        super.customiseView(collectionView: _collectionView, multiSelectable: true)
    }
    
//    override func setupBindings() {
//        super.setupBindings()
//        if let viewModel = self.viewModel {
//
//            disposeBag.insert([
//                // MARK: - Outputs
//                syncBtn.rx.tap.bind(onNext: viewModel.performSync),
//                syncCancelBtn.rx.tap.bind(onNext: viewModel.cancelMultiSelection),
//
//                // MARK: - Inputs
//                viewModel.enableSyncButton.subscribe(onNext: { [weak self] (enable) in
//                    self?.syncBtn.isEnabled     = enable
//                })
//            ])
//        }
//    }
//
//
//    override func setMultiSelectableMode(multiSelectEnabled: Bool) {
//        super.setMultiSelectableMode(multiSelectEnabled: multiSelectEnabled)
//        if multiSelectEnabled {
//            syncBtn.alpha                       = 0
//            syncCancelBtn.alpha                 = 0
//            syncBtn.isHidden                    = false
//            syncCancelBtn.isHidden              = false
//            UIView.animate(withDuration: 0.5) { [weak self] in
//                self?.syncBtn.alpha             = 1
//                self?.syncCancelBtn.alpha       = 1
//            }
//
//        } else {
//            UIView.animate(withDuration: 0.5, animations: { [weak self] in
//                self?.syncBtn.alpha             = 0
//                self?.syncCancelBtn.alpha       = 0
//            }) { [weak self] (completed) in
//                self?.syncBtn.isHidden          = true
//                self?.syncCancelBtn.isHidden    = true
//            }
//        }
//    }
    
}
