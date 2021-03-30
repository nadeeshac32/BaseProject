//
//  DynemicList_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/18/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources

class DynemicListVC: BaseListWithHeadersVC<Customer, DynemicListVM, ContactTVCell>, BaseMenuTabProtocol {
    
    @IBOutlet weak var _tableView               : UITableView!
    
    var tabIndex                                : Int = 0
    override var isDynemicSectionTitles         : Bool { get { return false } set {} }
    override var cellLoadFromNib                : Bool { get { return true } set {} }
    
    deinit {
        print("deinit DynemicListVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Backend contacts available."
    }
    
    override func customiseView() {
        super.customiseView(tableView: _tableView, multiSelectable: false)
    }
    
    override func getStaticSectionIndexTitles() -> [String] {
        var titles: [String] = ["#"]
        titles.append(contentsOf: (0..<26).map({String(Character(UnicodeScalar("A".unicodeScalars.first!.value + $0)!))}))
        return titles
    }
}
