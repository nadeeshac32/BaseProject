//
//  BaseGridWithoutHeadersVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

/// This class is used to Implement Table VIews when there is not sections. Extends from BaseListVC
/// Basically this class is to bind proper configuration into table view when there are no section headers.
class BaseGridWithoutHeadersVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: BaseCollectionVC<Model, ViewModel, CollectionViewCell> {
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.items.asObservable().bind(to: collectionView.rx.items(cellIdentifier: String(describing: CollectionViewCell.self), cellType: CollectionViewCell.self)) { [weak self] (row, element, cell) in
                    self?.setupCell(section: 0, row: row, element: element, cell: cell)
                }
            ])
        }
    }
}
