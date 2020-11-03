//
//  BlogCreateContentGrid.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/2/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogCreateContentGrid: BaseGridWithoutHeaders<BlogContent, BlogCreateContentGridVM, BlogCreateImageCVCell> {
    deinit { print("deinit BlogCreateContentGrid") }
    
    override init(viewModel: BlogCreateContentGridVM, collectionView: UICollectionView!, delegate: BaseGridDelagate) {
        super.init(viewModel: viewModel, collectionView: collectionView, delegate: delegate)
        collectionView.backgroundColor      = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        collectionView.layer.cornerRadius   = 5
    }
}


extension BlogCreateContentGrid: BlogCreateImageCVCellDelegate {
    func removeContent(item: BlogContent, section: Int, row: Int) {
        self.viewModel?.contentRemove(item: item, section: section, row: row)
    }
}
