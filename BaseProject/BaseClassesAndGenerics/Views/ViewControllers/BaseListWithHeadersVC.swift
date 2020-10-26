//
//  BaseListWithHeadersVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxDataSources

/// This class is used to pass data array for Table Views with sections
struct SectionOfCustomData<Model: BaseModel>: AnimatableSectionModelType {
    var header                                  : String
    var items                                   : [Model]
    
    typealias Item = Model

    var identity: String {
        return header
    }
    
    init(header: String, items: [Item]) {
        self.header                             = header
        self.items                              = items
    }
    
    init(original: SectionOfCustomData, items: [Item]) {
        self                                    = original
        self.items                              = items
    }
}


/// This class is used to Implement Table VIews with multiple Sections. Extends from BaseListVC
/// Basically this class is to bind proper datasource into table view when there are section headers.
class BaseListWithHeadersVC<Model:BaseModel, ViewModel: BaseListVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseListVC<Model, ViewModel, TableViewCell> {
    
    var dataSource                              : RxTableViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override func customiseView(tableView: UITableView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item".localized(), multiSelectable: Bool = false) {
        super.customiseView(tableView: tableView, itemCountLabel: itemCountLabel, itemCountString: itemCountString, multiSelectable: multiSelectable)
            
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                                                           reloadAnimation: .none,
                                                                                                                                           deleteAnimation: .left),
                                                                                            configureCell: { [weak self] (ds, tv, ip, item) -> UITableViewCell in
                                                                                                (self?.setupCell(dataSource: ds, tableView: tv, indexPath: ip, dataModel: item) ?? UITableViewCell())
                                                                                            },
                                                                                            titleForHeaderInSection: { [weak self] (ds, index) -> String? in
                                                                                                self?.getHeaderTitle(dataSource: ds, index: index)
                                                                                            })

        dataSource.sectionIndexTitles           = { [weak self] dataSource in
            if (self?.viewModel?.getCalculatedItemsCount() ?? 0) > 0 {
                if self?.isDynemicSectionTitles == true {
                    return dataSource.sectionModels.map { $0.header }
                } else {
                    return self?.getStaticSectionIndexTitles()
                }
            } else {
                return nil
            }
        }
        dataSource.sectionForSectionIndexTitle  = { (dataSource, title, index) in
            return dataSource.sectionModels.map { $0.header }.firstIndex(of: title) ?? 0
        }
        self.dataSource                         = dataSource
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
                
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.itemsWithHeaders.asObservable().bind(to: tableView.rx.items(dataSource: self.dataSource!))
            ])
        }
    }
    
    // MARK: - setup cell for table view with headers
    func getStaticSectionIndexTitles() -> [String] {
        return []
    }
    
    func getHeaderTitle(dataSource: TableViewSectionedDataSource<SectionOfCustomData<Model>>, index: Int) -> String {
        return dataSource.sectionModels[index].header
    }
    
    func setupCell(dataSource: TableViewSectionedDataSource<SectionOfCustomData<Model>>, tableView: UITableView, indexPath: IndexPath, dataModel: Model) -> UITableViewCell {
        let cell                                = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if let tableViewCell = cell as? TableViewCell {
            tableViewCell.configureCell(item: dataModel, row: indexPath.row, selectable: viewModel?.multiSelectable ?? false)
            tableViewCell.delegate              = self
            return tableViewCell
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame                               = CGRect(x: 0, y: 0, width: view.bounds.width, height: 24)
        let headerView                          = UIView(frame: frame)
        headerView.backgroundColor              = #colorLiteral(red: 0.9137254902, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        
        let sectionLabelFrame                   = CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: 24)
        let sectionLabel                        = UILabel(frame: sectionLabelFrame)
        sectionLabel.text                       = self.dataSource?[section].header ?? ""
        sectionLabel.textColor                  = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        sectionLabel.font                       = UIFont.systemFont(ofSize: 12)
        
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
