//
//  AdvancedBaseList.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/6/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

protocol CellIdentifiable { func getConfiguredTableCellType(cell: UITableViewCell, row: Int, selectable: Bool) -> BaseTVCell<BaseModel> }

protocol AdvancedAnimatableSectionModelTypeSupportedItem: IdentifiableType, CellIdentifiable, Equatable {
    init(model: BaseModel)
}

protocol AdvancedAnimatableSectionModelType: AnimatableSectionModelType where Item: CellIdentifiable, Item: BaseModel {
    var header: String { get }
    var items: [Item] { get set }
    init(header: String, items: [Item])
}

class AdvancedBaseList<Model:AdvancedAnimatableSectionModelTypeSupportedItem, SectionType: AdvancedAnimatableSectionModelType, ViewModel: AdvancedBaseListVM<Model, SectionType>>: NSObject, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var tableView                               : UITableView!
    var itemCountLabel                          : UILabel?
    var itemCountString                         : String?
    var isDynemicSectionTitles                  : Bool = true
    var shouldSetRowHeight                      : Bool = false {
        didSet {
            if shouldSetRowHeight {
                self.tableView.rowHeight        = self.delegate?.getCellHeight(self.tableView) ?? 70
            }
        }
    }
       
    var multiSelectable                         : Bool = false
    
    /// If the TableViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib                         : Bool = false
       
    weak var delegate                           : BaseListDelagate?
       
    let disposeBag                              = DisposeBag()
    weak var viewModel                          : ViewModel?
    
    
    var dataSource : RxTableViewSectionedAnimatedDataSource<SectionType>?
    
    fileprivate init(viewModel: ViewModel, tableView: UITableView!, delegate: BaseListDelagate) {
        super.init()
        self.viewModel                          = viewModel
        self.delegate                           = delegate
        self.tableView                          = tableView
        self.tableView.tableHeaderView          = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView          = UIView(frame: CGRect.zero)
        self.tableView.bounces                  = false
        self.tableView.backgroundColor          = UIColor.clear
        self.tableView.separatorInset           = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if shouldSetRowHeight {
            self.tableView.rowHeight            = self.delegate?.getCellHeight(self.tableView) ?? 70
        }
        self.tableView.estimatedRowHeight       = self.delegate?.getCellHeight(self.tableView) ?? 70
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionType>(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                                             reloadAnimation: .none,
                                                                                                                             deleteAnimation: .left),
                                                                              configureCell: { [weak self] (ds, tv, ip, item) -> UITableViewCell in
                                                                                    (self?.setupCell(dataSource: ds, tableView: tv, indexPath: ip, dataModel: item) ?? UITableViewCell())
                                                                              },
                                                                              titleForHeaderInSection: { dataSource, index in
                                                                                    return dataSource.sectionModels[index].header
                                                                              })
        dataSource.sectionIndexTitles           = { [weak self] dataSource in
            if (self?.viewModel?.getCalculatedItemsCount() ?? 0) > 0 {
                if self?.isDynemicSectionTitles == true {
                    return dataSource.sectionModels.map { $0.header }
                } else {
                    return self?.delegate?.getStaticSectionIndexTitles() ?? []
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
    
    func setupCell(dataSource: TableViewSectionedDataSource<SectionType>, tableView: UITableView, indexPath: IndexPath, dataModel: SectionType.Item) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        let configuredCell                      = dataModel.getConfiguredTableCellType(cell: cell, row: indexPath.row, selectable: viewModel?.multiSelectable ?? false)
        configuredCell.delegate                 = self
        return configuredCell
    }
    
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(itemCountLabel: UILabel? = nil, itemCountString: String? = "Item", multiSelectable: Bool = false) {
        self.itemCountLabel                     = itemCountLabel
        self.itemCountString                    = itemCountString
        self.multiSelectable                    = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate           = self
            self.tableView.addGestureRecognizer(longPressGesture)
        }
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.ended {
            viewModel?.multiSelectable = true
        }
    }
    
    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.viewForHeaderInSection(tableView, sectionTitle: self.dataSource?[section].header ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeaderInSection(tableView, section: section) ?? 24
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat                     = 100
        let bottomEdge                          = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            viewModel?.paginateNext()
        }
    }
    
    func setMultiSelectableMode(multiSelectEnabled: Bool) {
        self.tableView.allowsMultipleSelection = multiSelectEnabled
        self.tableView.reloadData()
    }
    
    func setupBindings() {
        if let viewModel = self.viewModel {
            if cellLoadFromNib {
                //  tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableViewCell.self))
            }
            disposeBag.insert([
                // MARK: - Outputs
                tableView.rx.setDelegate(self),
                
                // MARK: - Inputs
                tableView.rx.modelSelected(Model.self).subscribe(onNext: { (item) in
                    let _ = viewModel.itemSelected(model: item)
                }),
                viewModel.refreshTableView.subscribe(onNext: { [weak self] (_) in
                    self?.tableView.reloadData()
                }),
                viewModel.toSelectableMode.subscribe(onNext: { [weak self] (multiSelectableMode) in
                    self?.setMultiSelectableMode(multiSelectEnabled: multiSelectableMode)
                }),
                viewModel.totalItemsCount.subscribe(onNext: { [weak self] (total) in
                    if total > 0 {
                        self?.itemCountLabel?.text  = "\(total) \(self?.itemCountString ?? "Item".localized())"
                    } else {
                        self?.itemCountLabel?.text  = ""
                    }
                })
            ])
            let isLoading = tableView.rx.isLoading(loadingMessage: delegate?.getItemsLoadingText(tableView) ?? "", noItemsMessage: delegate?.getNoItemsText(tableView) ?? "", imageName: delegate?.getNoItemsImageName(tableView))
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
            
            disposeBag.insert([
                // MARK: - Inputs
                  viewModel.itemsWithHeaders.asObservable().bind(to: tableView.rx.items(dataSource: self.dataSource!))
            ])
        }
    }
    
}


extension AdvancedBaseList: BaseTVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        return viewModel?.itemSelected(model: Model(model: model))
    }
}
