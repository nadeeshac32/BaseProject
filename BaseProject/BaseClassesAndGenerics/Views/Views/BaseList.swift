//
//  BaseList.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/29/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

protocol BaseListDelagate: class {
    func getItemsLoadingText(_ tableView: UITableView) -> String
    func getNoItemsText(_ tableView: UITableView) -> String
    func getNoItemsImageName(_ tableView: UITableView) -> String?
    func getCellHeight(_ tableView: UITableView) -> CGFloat
    
    // Used in BaseListWithHeaders
    func getStaticSectionIndexTitles() -> [String]
    func viewForHeaderInSection(_ tableView: UITableView, sectionTitle: String) -> UIView?
    func heightForHeaderInSection(_ tableView: UITableView, section: Int) -> CGFloat
}

extension BaseListDelagate {
    // MARK: - override in subclasses as needed
    func getItemsLoadingText(_ tableView: UITableView) -> String {
        return "Items Loading".localized()
    }
    func getNoItemsText(_ tableView: UITableView) -> String {
        return "No Items".localized()
    }
    func getNoItemsImageName(_ tableView: UITableView) -> String? {
        return nil
    }
    func getCellHeight(_ tableView: UITableView) -> CGFloat {
        return 100
    }
    func getStaticSectionIndexTitles() -> [String] {
        return []
    }
    func viewForHeaderInSection(_ tableView: UITableView, sectionTitle: String) -> UIView? {
        let frame                               = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24)
        let headerView                          = UIView(frame: frame)
        headerView.backgroundColor              = #colorLiteral(red: 0.9137254902, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        
        let sectionLabelFrame                   = CGRect(x: 16, y: 0, width: tableView.frame.width - 32, height: 24)
        let sectionLabel                        = UILabel(frame: sectionLabelFrame)
        sectionLabel.text                       = sectionTitle
        sectionLabel.textColor                  = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        sectionLabel.font                       = UIFont.systemFont(ofSize: 12)
        
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func heightForHeaderInSection(_ tableView: UITableView, section: Int) -> CGFloat {
        return 24
    }
}


/// Base List  functionality.
/// You have to give the inherited subclasses of BaseModel, BaseListVM, BaseTVCell types in the subclass which inherit this class or when you directly create an instance of this class.
///
/// The ViewModel you're gonna pass here should be a child of the ViewModel of the class you're initiating the instance of this class.
///  
///
/// Initiating should be like defined below
/// let listView1ViewModel: ExampleViewModel   = self.viewModel.listView1ViewModel
/// listView1                                                           = BaseListWithoutHeaders<ExampleModel, ExampleViewModel, ExampleTVCell>(viewModel: listView1ViewModel, tableView: _tableView, delegate: self)
/// listView1?.customiseView(multiSelectable: true)                     <- This line is optional ->
/// listView1?.setupBindings()
class BaseList<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: NSObject, UITableViewDelegate, UIGestureRecognizerDelegate {
    
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
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: - setup cell for table view without headers
    func setupCell(row: Int, element: Model, cell: TableViewCell) {
        cell.configureCell(item: element, row: row, selectable: viewModel?.multiSelectable ?? false)
        cell.delegate                           = self
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
                tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableViewCell.self))
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
        }
    }
}

extension BaseList: BaseTVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}


/// This class is used to Implement Table VIews when there is no sections. Inherited from BaseListVC
/// Basically this class is to bind proper configuration into table view when there are no section headers.
class BaseListWithoutHeaders<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseList<Model, ViewModel, TableViewCell> {
    
    deinit { print("deinit BaseListWithoutHeaders") }
    
    override init(viewModel: ViewModel, tableView: UITableView!, delegate: BaseListDelagate) {
        super.init(viewModel: viewModel, tableView: tableView, delegate: delegate)
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


/// This class is used to Implement Table VIews with multiple Sections. Inherited from BaseList
/// Basically this class is to bind proper datasource into table view when there are section headers.
class BaseListWithHeaders<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseList<Model, ViewModel, TableViewCell> {
    
    var dataSource                              : RxTableViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override init(viewModel: ViewModel, tableView: UITableView!, delegate: BaseListDelagate) {
        super.init(viewModel: viewModel, tableView: tableView, delegate: delegate)
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
        return delegate?.viewForHeaderInSection(tableView, sectionTitle: self.dataSource?[section].header ?? "")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.heightForHeaderInSection(tableView, section: section) ?? 24
    }
}
