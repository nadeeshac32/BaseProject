//
//  BaseListVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

/// Base List View Controller functionality.
/// You have to give the inherited subclasses of BaseModel, BaseListVM, BaseTVCell types in the subclass which inherit this class
/// Search functionality is also enabled here.
class BaseListVC<Model:BaseModel, ViewModel: BaseListVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseVC<ViewModel>, UITableViewDelegate, UISearchBarDelegate, StoryboardInitializable, UIGestureRecognizerDelegate {
    
    var tableView                               : UITableView!
    var itemCountLabel                          : UILabel?
    var itemCountString                         : String?
    var isDynemicSectionTitles                  : Bool = true
    var shouldSetRowHeight                      : Bool = true
    
    var searchBar                               = UISearchBar()
    var searchBtn                               = SwivelUIMaker.makeButtonWith(imageName: "icon_search")
    var searchBarButtonItem                     : UIBarButtonItem?
    
    var multiSelectable                         : Bool = false
    
    /// If the TableViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib: Bool = false
    
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(tableView: UITableView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item".localized(), multiSelectable: Bool = false) {
        self.tableView                          = tableView
        self.itemCountLabel                     = itemCountLabel
        self.itemCountString                    = itemCountString
        super.customiseView()
        
        self.tableView.tableHeaderView          = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView          = UIView(frame: CGRect.zero)
        self.tableView.bounces                  = false
        self.tableView.backgroundColor          = UIColor.clear
        self.tableView.separatorInset           = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if shouldSetRowHeight {
            self.tableView.rowHeight            = getCellHeight()
        }
        self.tableView.estimatedRowHeight       = getCellHeight()
        
        self.multiSelectable                    = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate           = self
            self.tableView.addGestureRecognizer(longPressGesture)
        }
        
        self.searchBar.delegate                 = self
        self.searchBar.searchBarStyle           = .prominent
        self.searchBar.showsCancelButton        = true
        self.searchBtn.addTarget(self, action: #selector(searchButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.ended {
            viewModel?.multiSelectable = true
        }
    }

    override func setupBindings() {
        super.setupBindings()
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
            let isLoading = tableView.rx.isLoading(loadingMessage: getItemsLoadingText(), noItemsMessage: getNoItemsText(), imageName: getNoItemsImageName())
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
        }
    }
    
    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return getCellHeight()
//    }
    
    // MARK: - override in subclasses as needed
    func getItemsLoadingText() -> String {
        return "Items Loading".localized()
    }
    
    func getNoItemsText() -> String {
        return "No Items".localized()
    }
    
    func getNoItemsImageName() -> String? {
        return nil
    }
    
    func getCellHeight() -> CGFloat {
        return 70
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
    
    //MARK: - Search bar methods
    @objc func searchButtonPressed(sender: AnyObject) {
        showSearchBar(searchBar: searchBar)
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                   = ""
        searchBar.text                          = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                   = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}

extension BaseListVC: BaseTVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}
