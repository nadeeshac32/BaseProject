//
//  DynemicCollection_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/7/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxDataSources

class DynemicCollectionVC: BaseGridWithHeadersVC<Customer, DynemicCollectionVM, ContactCVCell, BaseCVSectionHeader>, BaseMenuTabProtocol {
    
    @IBOutlet weak var _collectionView          : UICollectionView!
    
    var tabIndex                                : Int = 0
    override var cellLoadFromNib                : Bool { get { return true } set {} }
    
    deinit {
        print("deinit DynemicCollectionVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Backend contacts available."
    }
    
    override func customiseView() {
        super.customiseView(collectionView: _collectionView, multiSelectable: tabIndex == 0 ? false : true)
    }
    
}
