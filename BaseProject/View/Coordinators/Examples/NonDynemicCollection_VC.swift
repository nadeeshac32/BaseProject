//
//  NonDynemicCollection_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources

class NonDynemicCollectionVC: BaseGridWithHeadersVC<Customer, NonDynemicCollectionVM, CustomerContactCVCell, BaseCVSectionHeader>, BaseMenuTabProtocol {
    
    @IBOutlet weak var _collectionView          : UICollectionView!
    
    var tabIndex                                : Int = 0
    
    deinit {
        print("deinit NonDynemicCollectionVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Phonebook contacts available."
    }
    
    override func customiseView() {
        super.customiseView(collectionView: _collectionView, multiSelectable: false)
    }
    
    
}
