//
//  AdvancedBaseListVM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/6/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

/// This is used to pass data from child to parent. See belof imlementation
protocol AdvancedBaseListVMDataSource:class {
    typealias ModelTypeAlias = AdvancedAnimatableSectionModelTypeSupportedItem
    typealias SectionTypeAlias = AdvancedAnimatableSectionModelType
    func errorMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType)
    func successMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType)
    func warningMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType)
    func toastMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, message: String)
    func requestLoading<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, isLoading: Bool)
    func showSignInVC<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>)
}

///// This is used to pass data from child to parent. This methods are calling from child view
extension AdvancedBaseListVMDataSource where Self: BaseVM {
    func errorMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType) {
        self.errorMessage.onNext(detail)
    }
    func successMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType) {
        self.successMessage.onNext(detail)
    }
    func warningMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, detail: SuccessMessageDetailType) {
        self.warningMessage.onNext(detail)
    }
    func toastMessage<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, message: String) {
        self.toastMessage.onNext(message)
    }
    func requestLoading<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>, isLoading: Bool) {
        self.requestLoading.onNext(isLoading)
    }
    func showSignInVC<Model: ModelTypeAlias, SectionType: SectionTypeAlias>(listVM: AdvancedBaseListVM<Model, SectionType>) {
        self.showSignInVC.onNext(true)
    }
}

/// Base AdvancedBaseListVM that supports AdvancedBaseList
/// If you initialise a instance of this class in side another BaseVM instance you should add newly created instance to the parent BaseVM's childViewModels array.
class AdvancedBaseListVM<Model: AdvancedAnimatableSectionModelTypeSupportedItem, SectionType: AdvancedAnimatableSectionModelType>: BaseVM where Model == SectionType.Item {
    
    /**
     Support data source when AdvancedBaseListVM is used as a  VM of SubView in a ViewController.
     Used to bind BaseVM Observers to superVM Observers. See the AdvancedBaseListVMDataSource implementation
     */
    weak var dataSource     : AdvancedBaseListVMDataSource?
    
    /**
     This Variable is used to specify whether the data is loaded from API or not
     When this is set to true you have to override 'perfomrGetItemsRequest' in your subclass
     When this is set to false you have to 'addNewItems' method from your subclass with the relavent data set
     */
    var loadFromAPI         : Bool                  = true
    
    /**
     This variable is used when you load data from API.
     When this is set to false, pagination will repeate until it recieve all the data
     When this is set to true, pagination will happen when the user scroll to the bottom
     */
    var loadAsDynemic       : Bool                  = true
    
    var staticSectionCount  : Int                   = 0
    var sectionHeaderWhenStaticDataComesAsArray     = "Section_Header_When_Static_Data_Comes_As_Array"
    var sectionHeaderWhenDataComesAsArray           = "Section_Header_When_Data_Comes_As_Array"
    var apiDataDownloadedCount  : Int               = 0
    var apiDataTotalCount   : Int                   = 1
	var hasNextPage 		: Bool 					= true
    var requestPage         : Int                   = 0
    var limit               : Int                   = 200
    
    /// Data list can be sorted from key if you wanted. In the Data model you should override getSortKey method as you want.
    var shouldSortFromKey   : Bool                  = false
    
    /// Mention where in the ViewController lifecycle the data should load.
    var dataLoadIn          : DataLoadIn?           = .ViewDidLoad
    
    /// If multi selection enabled this is the maximum limit that user can select. You can override this in your subclass if you want.
    var multiSelectMax      : Int                   = 25
    var multiSelectable     : Bool                  = false {
        didSet {
            toSelectableMode.onNext(multiSelectable)
        }
    }
    var selectedItems       : [Model]               = []
    
    // MARK: - Inputs
    var searchText          : String = "" {
        didSet {
            reloadList()
        }
    }
    
    // MARK: - Outputs
    /// This is used when there are item headers in BaseListWithHeadersVC
    var itemsWithHeaders    : BehaviorSubject<[SectionType]>                    = BehaviorSubject(value: [])
    
    var totalItemsCount     : BehaviorSubject<Int>                              = BehaviorSubject(value: 0)
    let doWithSelectedItem  : PublishSubject<Model>                             = PublishSubject()
    let toSelectableMode    : PublishSubject<Bool>                              = PublishSubject()
    let refreshTableView    : PublishSubject<Bool>                              = PublishSubject()
    
    var updateScrollPropertion     : BehaviorSubject<CGFloat>                   = BehaviorSubject(value: 0)
    
    private override init() {
        super.init()
    }
    
    /// If you initialise a instance of this class inside another BaseVM instance you should add newly created instance to the parent BaseVM's childViewModels array.
    init(dataSource: AdvancedBaseListVMDataSource?) {
        super.init()
        self.dataSource     = dataSource
        
        disposeBag.insert([
            errorMessage.subscribe(onNext: { [weak self] (SuccessMessageDetailType) in
                guard let `self` = self else { return }
                self.dataSource?.errorMessage(listVM: self, detail: SuccessMessageDetailType)
            }),
            successMessage.subscribe(onNext: { [weak self] (SuccessMessageDetailType) in
                guard let `self` = self else { return }
                self.dataSource?.successMessage(listVM: self, detail: SuccessMessageDetailType)
            }),
            warningMessage.subscribe(onNext: { [weak self] (SuccessMessageDetailType) in
                guard let `self` = self else { return }
                self.dataSource?.warningMessage(listVM: self, detail: SuccessMessageDetailType)
            }),
            toastMessage.subscribe(onNext: { [weak self] (message) in
                guard let `self` = self else { return }
                self.dataSource?.toastMessage(listVM: self, message: message)
            }),
            requestLoading.subscribe(onNext: { [weak self] (isLoading) in
                guard let `self` = self else { return }
                self.dataSource?.requestLoading(listVM: self, isLoading: isLoading)
            }),
            showSignInVC.subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.dataSource?.showSignInVC(listVM: self)
            })
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataLoadIn == .ViewDidLoad {
            paginateNext()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated: animated)
        if dataLoadIn == .ViewWillAppear {
            reloadList()
        }
    }
    
    // Class Methods
    func getMaxSelectedItemsCountWarning() -> String {
        return "You have selected maximum"
    }
    
    /// Get item for index path
    func getItemForIndexPath(indexPath: IndexPath) -> Model? {
        do {
            let sections                        = try itemsWithHeaders.value()
            if sections.count > 0, sections.count > indexPath.section {
                let section                     = sections[indexPath.section]
                if section.items.count > indexPath.row {
                    return section.items[indexPath.row]
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print("error: \(error)")
            return nil
        }
    }
    
    /// Network request to fetch data from the Rest API.
    /// You have to override this methis in your subclass.
    func performGetItemsRequest(loadPage: Int, limit: Int) {
        fatalError("This method must be overriden by the subclass")
    }
    
    /// Network request to fetch data from the Rest API when you have a search key.
    /// You have to override this methis in your subclass.
    func performSearchItemsRequest(searchText: String, loadPage: Int, limit: Int) {
        fatalError("This method must be overriden by the subclass")
    }
    
    /// Reset pagination and reload data
    func reloadList() {
        apiDataTotalCount                           = 1
		hasNextPage 								= true
        requestPage                                 = 0
        removeAllAPIItems()                         //replaced emptying table itemsWithHeaders.onNext([])
        apiDataDownloadedCount                      = 0
        paginateNext()
    }
    
    /// Paginate next data set from the Rest API.
    /// This method will be called the view has scroll to the bottom
    func paginateNext() {
        if loadFromAPI && (apiDataTotalCount > apiDataDownloadedCount || hasNextPage == true) && searchText == "" {
            self.apiDataTotalCount                  = 0
			self.hasNextPage 						= false
            performGetItemsRequest(loadPage: requestPage, limit: limit)
        } else if loadFromAPI && (apiDataTotalCount > apiDataDownloadedCount || hasNextPage == true) && searchText != "" {
            self.apiDataTotalCount                  = 0
			self.hasNextPage 						= false
            performSearchItemsRequest(searchText: searchText, loadPage: requestPage, limit: limit)
        }
    }
    
    /// Show spiner while the network call
    func showSpiner() {
        // Showing spiner in first 4 requests when loading the data recursively or loading data with paginate according to scrolling
        if (loadFromAPI && !loadAsDynemic && requestPage < 4) || (loadFromAPI && loadAsDynemic) {
            requestLoading.onNext(true)
        } else {
            requestLoading.onNext(false)
        }
    }
    
    /// You override the `perfomrGetItemsRequest(loadPage: Int, limit: Int)` method in you subclass.
    /// Then you can pass the response array you get there to this method, so this method will handle the rest.
	func handleResponse(items: [BaseModel], total: Int, page: Int, size: Int, hasNextPage: Bool = false) {
        self.apiDataTotalCount                      = total
		self.hasNextPage 							= hasNextPage
        self.totalItemsCount.onNext(self.apiDataTotalCount)
        self.requestPage                            = page + 1
        self.addNewItems(items: items)
        self.apiDataDownloadedCount                 = apiDataDownloadedCount + size     // items.count
        self.requestLoading.onNext(false)
        if loadFromAPI && !loadAsDynemic && searchText == "" {
            paginateNext()
        }
    }
    
    /// You override the `perfomrGetItemsRequest(loadPage: Int, limit: Int)` method in you subclass.
    /// Then you can pass the response map you get there to this method, so this method will handle the rest.
	func handleResponse(items: [String: [BaseModel]], total: Int, page: Int, size: Int, hasNextPage: Bool = false) {
        self.apiDataTotalCount                      = total
		self.hasNextPage 							= hasNextPage
        self.totalItemsCount.onNext(self.apiDataTotalCount)
        self.requestPage                            = page + 1
        self.addNewItems(items: items)
        //  let itemsCount                          = items.map({ $0.value.count }).reduce(0, { (result, nextValue) in result + nextValue })
        self.apiDataDownloadedCount                 = self.apiDataDownloadedCount + size    //  itemsCount
        self.requestLoading.onNext(false)
        if loadFromAPI && !loadAsDynemic && searchText == ""  {
            paginateNext()
        }
    }
    
    /// You override the `performSearchItemsRequest(searchText: String, loadPage: Int, limit: Int)` method in you subclass.
    /// Then you can pass the response array you get there to this method, so this method will handle the rest.
	func handleSearchResponse(searchTextOfData: String, items: [BaseModel], total: Int, page: Int, size: Int, hasNextPage: Bool = false) {
        self.apiDataTotalCount                      = total
		self.hasNextPage 							= hasNextPage
        self.totalItemsCount.onNext(self.apiDataTotalCount)
        self.requestPage                            = page + 1
        self.addNewItems(items: items)
        self.apiDataDownloadedCount                 = self.apiDataDownloadedCount + size    //  items.count
        self.requestLoading.onNext(false)
        if loadFromAPI && !loadAsDynemic && searchTextOfData == searchText {
            paginateNext()
        }
    }
    
    /// You override the `performSearchItemsRequest(searchText: String, loadPage: Int, limit: Int)` method in you subclass.
    /// Then you can pass the response map you get there to this method, so this method will handle the rest.
	func handleSearchResponse(searchTextOfData: String, items: [String: [BaseModel]], total: Int, page: Int, size: Int, hasNextPage: Bool = false) {
        self.apiDataTotalCount                      = total
		self.hasNextPage 							= hasNextPage
        self.totalItemsCount.onNext(self.apiDataTotalCount)
        self.requestPage                            = page + 1
        self.addNewItems(items: items)
        //  let itemsCount                          = items.map({ $0.value.count }).reduce(0, { (result, nextValue) in result + nextValue })
        self.apiDataDownloadedCount                 = self.apiDataDownloadedCount + size    //  itemsCount
        self.requestLoading.onNext(false)
        if loadFromAPI && !loadAsDynemic && searchTextOfData == searchText {
            paginateNext()
        }
    }
    
    /// Appending static data to the data array
    func addNewStaticItems(items: [BaseModel]) {
        addNewItems(items: [sectionHeaderWhenStaticDataComesAsArray : items])
    }
    
    /// Appending data to the data array
    func addNewItems(items: [BaseModel]) {
        addNewItems(items: [sectionHeaderWhenDataComesAsArray : items])
    }
    
    /// Appending data to the data map in views with sections
    func addNewItems(items: [String: [BaseModel]]) {
        let sections: [SectionType]!
        if shouldSortFromKey {
            sections = items.sorted(by: { $0.0 < $1.0 }).map { (key, value) -> SectionType in
                let sortedItems = value.sorted(by: { $0.getSortKey().lowercased() < $1.getSortKey().lowercased() })
                let cellItems   = sortedItems.map { Model(model: $0) }.filter { $0 != nil } as! [Model]
                return SectionType(header: key.uppercased(), items: cellItems)
            }
        } else {
            sections = items.map { (key, value) -> SectionType in
                let cellItems   = value.map { Model(model: $0) }.filter { $0 != nil } as! [Model]
                return SectionType(header: key.uppercased(), items: cellItems)
            }
        }

        var currentSections                         : [SectionType]   = []
        do {
            currentSections                         = try self.itemsWithHeaders.value()
        } catch {
            print("error: \(error)")
        }

        for section in sections {
            if let index = currentSections.firstIndex(where: { (currentSection) -> Bool in
                currentSection.header == section.header
            }) {
                currentSections[index].items.append(contentsOf: section.items)
            } else {
                currentSections.append(section)
            }
        }

        self.itemsWithHeaders.onNext(currentSections)
    }
    
    /// Removing data from the data array
    func removeExistingItems(items: [Model]) {
        var currentSections                         : [SectionType]   = []
        do {
            currentSections                         = try self.itemsWithHeaders.value()
        } catch {
            print("error: \(error)")
        }

        var updatedSections                         : [SectionType]   = []
        for var currentSection in currentSections {
            let updatedItems: [Model]               = currentSection.items.filter { (existingItem) -> Bool in
                return !items.contains(existingItem)
            }
            currentSection.items                    = updatedItems
            if updatedItems.count > 0 {
                updatedSections.append(currentSection)
            }
        }
        self.itemsWithHeaders.onNext(updatedSections)
    }
    
    /// Removing data from the data array
    func removeAllAPIItems() {
        var currentSections                         : [SectionType]   = []
        do {
            currentSections                         = try self.itemsWithHeaders.value()
        } catch {
            print("error: \(error)")
        }

        let updatedSections: [SectionType]          = currentSections.filter { [weak self] (existingSection) -> Bool in
            guard let `self` = self else { return false }
            return existingSection.header.lowercased() == self.sectionHeaderWhenStaticDataComesAsArray.lowercased()
        }
        self.itemsWithHeaders.onNext(updatedSections)
    }
    
    //MARK: - Cell Selection
    /// Cancel multi selection mode
    func cancelMultiSelection() {
        multiSelectable                             = false
        for item in selectedItems {
            item.setSelected(isSelected: false)
        }
        selectedItems.removeAll()
        refreshTableView.onNext(true)
    }
    
    /// Handle selection of items
    func itemSelected(model: Model) -> Bool? {
        if multiSelectable {
            if let index = selectedItems.firstIndex(of: model) {
                model.setSelected(isSelected: false)
                selectedItems.remove(at: index)
                return false
            } else if multiSelectMax > selectedItems.count {
                model.setSelected(isSelected: true)
                selectedItems.append(model)
                return true
            } else {
                model.setSelected(isSelected: false)
                let tupple                          = (message: getMaxSelectedItemsCountWarning(), blockScreen: false, completionHandler: { })
                warningMessage.onNext(tupple)
                return false
            }
        } else {
            doWithSelectedItem.onNext(model)
            return nil
        }
    }
}


