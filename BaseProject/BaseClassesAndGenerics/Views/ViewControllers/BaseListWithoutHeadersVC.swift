//
//  BaseListWithoutHeadersVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

/// This class is used to Implement Table VIews when there is not sections. Extends from BaseListVC
/// Basically this class is to bind proper configuration into table view when there are no section headers.
class BaseListWithoutHeadersVC<Model:BaseModel, ViewModel: BaseListVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseListVC<Model, ViewModel, TableViewCell> {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: String(describing: TableViewCell.self), cellType: TableViewCell.self)) { [weak self] (row, element, cell) in
                    self?.setupCell(row: row, element: element, cell: cell)
                }
            ])
        }
    }
}
