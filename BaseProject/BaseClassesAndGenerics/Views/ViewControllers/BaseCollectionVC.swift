//
//  BaseCollectionVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

/// Base List View Controller functionality.
/// You have to give the inherited subclasses of BaseModel, BaseListVM, BaseTVCell types in the subclass which inherit this class
/// Search functionality is also enabled here.
class BaseCollectionVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: BaseVC<ViewModel>, UICollectionViewDelegate, UISearchBarDelegate, StoryboardInitializable, UIGestureRecognizerDelegate {
    
    var collectionView                              : UICollectionView!
    var itemCountLabel                              : UILabel?
    var itemCountString                             : String?
    
    var searchBar                                   = UISearchBar()
    var searchBtn                                   = SwivelUIMaker.makeButtonWith(imageName: "icon_search")
    var searchBarButtonItem                         : UIBarButtonItem?
    
    var multiSelectable                             : Bool = false
    
    /// If the CollectionViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib                             : Bool = false
    var shouldSetCellSize                           : Bool = true
    
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(collectionView: UICollectionView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item".localized(), multiSelectable: Bool = false) {
        self.collectionView                         = collectionView
        self.itemCountLabel                         = itemCountLabel
        self.itemCountString                        = itemCountString
        super.customiseView()
        
        self.collectionView.backgroundColor         = UIColor.clear
        self.collectionView.bounces                 = false
        self.collectionView.collectionViewLayout    = getCellLayout()
        
        self.multiSelectable                        = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate               = self
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
        
        self.searchBar.delegate                     = self
        self.searchBar.searchBarStyle               = .prominent
        self.searchBar.showsCancelButton            = true
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
                self.collectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
            }
            disposeBag.insert([
                // MARK: - Outputs
                collectionView.rx.setDelegate(self),
                
                // MARK: - Inputs
                collectionView.rx.modelSelected(Model.self).subscribe(onNext: { (item) in
                    let _ = viewModel.itemSelected(model: item)
                }),
                viewModel.refreshTableView.subscribe(onNext: { [weak self] (_) in
                    self?.collectionView.reloadData()
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
            let isLoading = collectionView.rx.isLoading(loadingMessage: getItemsLoadingText(), noItemsMessage: getNoItemsText(), imageName: getNoItemsImageName())
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
        }
    }
    
    
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
    
    func getCellLayout() -> UICollectionViewFlowLayout {
        let layout                                  = UICollectionViewFlowLayout()
        layout.sectionInset                         = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        if shouldSetCellSize {
            layout.itemSize                         = getItemSize()
        }
        layout.estimatedItemSize                    = getItemSize()
        layout.headerReferenceSize                  = CGSize(width: AppConfig.si.screenSize.width, height: 30)
        layout.minimumLineSpacing                   = 8
        layout.minimumInteritemSpacing              = 0
        return layout
    }
    
    func getItemSize() -> CGSize {
        let sideSize                                : CGFloat = AppConfig.si.screenSize.width / 3
        return CGSize(width: sideSize, height: sideSize)
    }
    // MARK: - setup cell for collection view without headers
    func setupCell(section: Int, row: Int, element: Model, cell: CollectionViewCell) {
        cell.configureCell(item: element, section: section, row: row, selectable: viewModel?.multiSelectable ?? false)
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
        self.collectionView.allowsMultipleSelection = multiSelectEnabled
        self.collectionView.reloadData()
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

extension BaseCollectionVC: BaseCVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}
