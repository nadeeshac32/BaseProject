//
//  BaseGridWithHeadersVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//


import Foundation
import RxDataSources


/// This class is used to Implement Table VIews with multiple Sections. Extends from BaseListVC
/// Basically this class is to bind proper datasource into table view when there are section headers.
class BaseGridWithHeadersVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>, CollectionViewSectionHeder: BaseCVSectionHeader>: BaseCollectionVC<Model, ViewModel, CollectionViewCell> {
    
    var dataSource                              : RxCollectionViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override func customiseView(collectionView: UICollectionView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item".localized(), multiSelectable: Bool = false) {
        super.customiseView(collectionView: collectionView, itemCountLabel: itemCountLabel, itemCountString: itemCountString, multiSelectable: multiSelectable)
            
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                                                           reloadAnimation: .none,
                                                                                                                                           deleteAnimation: .left),
            configureCell: { [weak self] (ds, cv, ip, item) -> UICollectionViewCell in
                (self?.setupCell(dataSource: ds, collectionView: cv, indexPath: ip, dataModel: item) ?? UICollectionViewCell())
            },
            configureSupplementaryView: { [weak self] (ds, cv, kind, ip) -> UICollectionReusableView in
                (self?.viewForHeaderInSection(dataSource: ds, collectionView: cv, kind: kind, indexPath: ip) ?? UICollectionReusableView())
            })
        
        self.dataSource                         = dataSource
    }
    
    override func setupBindings() {
        super.setupBindings()
        self.collectionView.register(CollectionViewSectionHeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CollectionViewSectionHeder.self))
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.itemsWithHeaders.asObservable().bind(to: collectionView.rx.items(dataSource: self.dataSource!))
            ])
        }
    }
    
    // MARK: - setup cell for table view with headers
    func setupCell(dataSource: CollectionViewSectionedDataSource<SectionOfCustomData<Model>>, collectionView: UICollectionView, indexPath: IndexPath, dataModel: Model) -> UICollectionViewCell {
        let cell                                = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        
        if let collectionViewCell = cell as? CollectionViewCell {
            collectionViewCell.configureCell(item: dataModel, section: indexPath.section, row: indexPath.row, selectable: viewModel?.multiSelectable ?? false)
            collectionViewCell.delegate              = self
            return collectionViewCell
        }

        return cell
    }
 
    func viewForHeaderInSection(dataSource: CollectionViewSectionedDataSource<SectionOfCustomData<Model>>, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionViewSectionHeder.self), for: indexPath) as! CollectionViewSectionHeder
            sectionHeader.configureCell(header: dataSource.sectionModels[indexPath.section].header)
            return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
}

