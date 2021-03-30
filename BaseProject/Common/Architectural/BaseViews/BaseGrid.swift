//
//  BaseGrid.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/2/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

protocol BaseGridDelagate: class {
    func getItemsLoadingText(_ collectionView: UICollectionView) -> String
    func getNoItemsText(_ collectionView: UICollectionView) -> String
    func getNoItemsImageName(_ collectionView: UICollectionView) -> String?
    func getCellLayout(_ collectionView: UICollectionView, shouldSetCellSize: Bool) -> UICollectionViewFlowLayout
    func getItemSize(_ collectionView: UICollectionView) -> CGSize
    func getLayoutInsets() -> (columnsForRow: Int, sides: UIEdgeInsets, lineSpacing: CGFloat, interItemSpacing: CGFloat, widthToHeightPropotion: CGFloat)
    func getSectionHeaderHeight() -> CGFloat
}

extension BaseGridDelagate {
    // MARK: - override in subclasses as needed
    func getItemsLoadingText(_ collectionView: UICollectionView) -> String {
        return "Items Loading"
    }
    func getNoItemsText(_ collectionView: UICollectionView) -> String {
        return "No Items"
    }
    func getNoItemsImageName(_ collectionView: UICollectionView) -> String? {
        return nil
    }
    func getCellLayout(_ collectionView: UICollectionView, shouldSetCellSize: Bool) -> UICollectionViewFlowLayout {
        let layout                                  = UICollectionViewFlowLayout()
        layout.headerReferenceSize                  = CGSize(width: collectionView.frame.width, height: getSectionHeaderHeight())
        layout.sectionInset                         = getLayoutInsets().sides
        layout.minimumLineSpacing                   = getLayoutInsets().lineSpacing
        layout.minimumInteritemSpacing              = getLayoutInsets().interItemSpacing
        
        if shouldSetCellSize {
            layout.itemSize                         = getItemSize(collectionView)
        } else {
            layout.estimatedItemSize                = getItemSize(collectionView)
        }
        
        return layout
    }
    func getItemSize(_ collectionView: UICollectionView) -> CGSize {
        let layoutGuide                             = getLayoutInsets()
        let sides                                   = layoutGuide.sides.left + layoutGuide.sides.right
        let totalInterItemSpacing                   = CGFloat(layoutGuide.columnsForRow - 1) * layoutGuide.interItemSpacing
        let width                                   : CGFloat = (collectionView.frame.width - sides - totalInterItemSpacing) / CGFloat(layoutGuide.columnsForRow)
        return CGSize(width: width, height: width * layoutGuide.widthToHeightPropotion)
    }
    func getLayoutInsets() -> (columnsForRow: Int, sides: UIEdgeInsets, lineSpacing: CGFloat, interItemSpacing: CGFloat, widthToHeightPropotion: CGFloat) {
        return (columnsForRow: 3,
                sides: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                lineSpacing: 8,
                interItemSpacing: 8,
                widthToHeightPropotion: 1)
    }
    
    /// Override this method if you're using section headers
    func getSectionHeaderHeight() -> CGFloat {
        return 0
    }
}


/// Base Grid (CollectionView) functionality.
/// You have to give the inherited subclasses of BaseModel, BaseGridVM, BaseCVCell types in the subclass which inherit this class or when you directly create an instance of this class.
///
/// The ViewModel you're gonna pass here should be a child of the ViewModel of the class you're initiating the instance of this class.
///
///
/// Initiating should be like defined below
/// let gridView1ViewModel: ExampleViewModel      = self.viewModel.gridView1ViewModel
/// gridView1                                                              = BaseGridWithoutHeaders<ExampleModel, ExampleViewModel, ExampleCVCell>(viewModel: gridView1ViewModel, collectionView: _collectionView, delegate: self)
/// gridView1?.customiseView(multiSelectable: true)                     <- This line is optional ->
/// gridView1?.setupBindings()
class BaseCollection<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: NSObject, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    var collectionView                              : UICollectionView!
    var itemCountLabel                              : UILabel?
    var itemCountString                             : String?
    var showActivityIndicator                       : Bool = false
    var scrollingEnableWhileItemsLoading            : Bool = false
    
    var multiSelectable                             : Bool = false
    
    /// If the CollectionViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib                             : Bool = false
    var shouldSetCellSize                           : Bool = true
    weak var delegate                               : BaseGridDelagate?
       
    let disposeBag                                  = DisposeBag()
    weak var viewModel                              : ViewModel?
    
    fileprivate init(viewModel: ViewModel, collectionView: UICollectionView!, delegate: BaseGridDelagate) {
        self.viewModel                              = viewModel
        self.delegate                               = delegate
        self.collectionView                         = collectionView
        self.collectionView.backgroundColor         = UIColor.clear
        self.collectionView.bounces                 = false
        if let layout = self.delegate?.getCellLayout(collectionView, shouldSetCellSize: self.shouldSetCellSize) {
            self.collectionView.collectionViewLayout    = layout
        }
    }
        
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(itemCountLabel: UILabel? = nil, itemCountString: String? = "Item".localized(), multiSelectable: Bool = false) {
        self.itemCountLabel                         = itemCountLabel
        self.itemCountString                        = itemCountString
        self.multiSelectable                        = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate               = self
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.ended {
            viewModel?.multiSelectable = true
        }
    }

    func setupBindings() {
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
            let isLoading = collectionView.rx.isLoading(loadingMessage: delegate?.getItemsLoadingText(collectionView) ?? "", noItemsMessage: delegate?.getNoItemsText(collectionView) ?? "", imageName: delegate?.getNoItemsImageName(collectionView), scrollingEnableWhileItemsLoading: scrollingEnableWhileItemsLoading)
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
            
            if showActivityIndicator {
                viewModel.requestLoading.asObservable().bind(to: collectionView.rx.isAnimating).disposed(by: disposeBag)
            }
        }
    }
    
    // MARK: - setup cell for collection view without headers
    func setupCell(section: Int, row: Int, element: Model, cell: CollectionViewCell) {
        cell.configureCell(item: element, section: section, row: row, selectable: viewModel?.multiSelectable ?? false)
        cell.delegate                           = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel?.getCalculatedItemsCount() ?? 0 > 0 else { return }
        let offset: CGFloat                         = 500
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal {
            let rightEdge                           = scrollView.contentOffset.x + scrollView.frame.size.width
            if (rightEdge + offset >= scrollView.contentSize.width) {
                viewModel?.paginateNext()
            }
        } else {
            let bottomEdge                          = scrollView.contentOffset.y + scrollView.frame.size.height
            if (bottomEdge + offset >= scrollView.contentSize.height) {
                viewModel?.paginateNext()
            }
        }
    }
    
    func setMultiSelectableMode(multiSelectEnabled: Bool) {
        self.collectionView.allowsMultipleSelection = multiSelectEnabled
        self.collectionView.reloadData()
    }
}

extension BaseCollection: BaseCVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}


/// This class is used to Implement Table VIews when there is not sections. Inherited from BaseGridVC
/// Basically this class is to bind proper configuration into collection view when there are no section headers.
class BaseGridWithoutHeaders<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: BaseCollection<Model, ViewModel, CollectionViewCell> {
    
    deinit { print("deinit BaseGridWithoutHeaders") }
    
    override init(viewModel: ViewModel, collectionView: UICollectionView!, delegate: BaseGridDelagate) {
        super.init(viewModel: viewModel, collectionView: collectionView, delegate: delegate)
    }
    
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


/// This class is used to Implement Table VIews with multiple Sections. Extends from BaseGrid
/// Basically this class is to bind proper datasource into collection view when there are section headers.
class BaseGridWithHeaders<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>, CollectionViewSectionHeder: BaseCVSectionHeader>: BaseCollection<Model, ViewModel, CollectionViewCell> {
    
    deinit { print("deinit BaseGridWithoutHeaders") }
    
    var dataSource                              : RxCollectionViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override init(viewModel: ViewModel, collectionView: UICollectionView!, delegate: BaseGridDelagate) {
        super.init(viewModel: viewModel, collectionView: collectionView, delegate: delegate)
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
            collectionViewCell.delegate         = self
            return collectionViewCell
        }

        return cell
    }
 
    func viewForHeaderInSection(dataSource: CollectionViewSectionedDataSource<SectionOfCustomData<Model>>, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = dataSource.sectionModels[indexPath.section].header
            if header.lowercased() == viewModel?.sectionHeaderWhenDataComesAsArray.lowercased() {
                return UICollectionReusableView()
            } else {
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionViewSectionHeder.self), for: indexPath) as! CollectionViewSectionHeder
                sectionHeader.configureCell(header: header)
                return sectionHeader
            }
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
}

