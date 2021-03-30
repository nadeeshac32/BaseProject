//
//  NonDynemicList_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/18/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources

class NonDynemicListVC: BaseListWithHeadersVC<Customer, NonDynemicListVM, CustomerContactTVCell>, BaseMenuTabProtocol {
    
    @IBOutlet weak var syncBtn                  : UIButton!
    @IBOutlet weak var syncCancelBtn            : UIButton!
    @IBOutlet weak var _tableView               : UITableView!
    
    var tabIndex                                : Int = 0
    override var isDynemicSectionTitles         : Bool { get { return false } set {} }
    
    deinit {
        print("deinit NonDynemicListVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Phonebook contacts available."
    }
    
    override func customiseView() {
        super.customiseView(tableView: _tableView, multiSelectable: true)
        syncCancelBtn.isHidden                  = true
        syncCancelBtn.layer.cornerRadius        = syncCancelBtn.frame.height / 2
        syncCancelBtn.setImage(#imageLiteral(resourceName: "icon_cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        syncCancelBtn.tintColor                 = AppConfig.si.colorPrimary
        syncCancelBtn.addShadow()

        syncBtn.isHidden                        = true
        syncBtn.layer.cornerRadius              = syncBtn.frame.height / 2
        syncBtn.setImage(#imageLiteral(resourceName: "icon_sync").withRenderingMode(.alwaysTemplate), for: .normal)
        syncBtn.tintColor                       = AppConfig.si.colorPrimary
        syncBtn.addShadow()
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Outputs
                syncBtn.rx.tap.bind(onNext: viewModel.performSync),
                syncCancelBtn.rx.tap.bind(onNext: viewModel.cancelMultiSelection),

                // MARK: - Inputs
                viewModel.enableSyncButton.subscribe(onNext: { [weak self] (enable) in
                    self?.syncBtn.isEnabled     = enable
                })
            ])
        }
    }
    
    override func getStaticSectionIndexTitles() -> [String] {
        var titles: [String] = ["#"]
        titles.append(contentsOf: (0..<26).map({String(Character(UnicodeScalar("A".unicodeScalars.first!.value + $0)!))}))
        return titles
    }
    
    override func setMultiSelectableMode(multiSelectEnabled: Bool) {
        super.setMultiSelectableMode(multiSelectEnabled: multiSelectEnabled)
        if multiSelectEnabled {
            syncBtn.alpha                       = 0
            syncCancelBtn.alpha                 = 0
            syncBtn.isHidden                    = false
            syncCancelBtn.isHidden              = false
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.syncBtn.alpha             = 1
                self?.syncCancelBtn.alpha       = 1
            }

        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.syncBtn.alpha             = 0
                self?.syncCancelBtn.alpha       = 0
            }) { [weak self] (completed) in
                self?.syncBtn.isHidden          = true
                self?.syncCancelBtn.isHidden    = true
            }
        }
    }
}
