//
//  NCManuTab.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit

protocol MenuBarDelegate: class {
    func menuBarDidSelectItemAt(index: Int)
}

struct MenuTabCellAttributes {
    let title: String
    let titleColor: UIColor
    let highLighter: UIColor
}

/// Simple tab bar component. This is used to implement BaseManuVC
/// Currently support two tab highlight annimations. `NCManuTabCell_Underline` and  `NCManuTabCell_Circle`.
/// You can add another animation like `NCManuTabCell_Underline` by subclassing `NCManuTabCell`.
class NCManuTab<ManyTabCell: NCManuTabCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    lazy var collView               : UICollectionView = {
        let layOut                  = UICollectionViewFlowLayout()
        let cv                      = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layOut)
        cv.showsHorizontalScrollIndicator = false
        layOut.scrollDirection      = .horizontal
        cv.backgroundColor          = .white
        cv.delegate                 = self
        cv.dataSource               = self
        return cv
    }()
    var isSizeToFitCellsNeeded:Bool = false {
        didSet{
            self.collView.reloadData()
        }
    }
    var dataArray: [MenuTabCellAttributes] = [] {
        didSet{
            self.collView.reloadData()
        }
    }

    weak var menuDelegate           : MenuBarDelegate?
    private var cellId              = "BasicCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customIntializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customIntializer()
    }
    
    private func customIntializer () {
        collView.register(ManyTabCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collView)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: collView)
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: collView)
        backgroundColor             = .clear
    }
    
    //MARK: CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ManyTabCell {
            let data                = dataArray[indexPath.item]
            cell.titleLabel.text    = data.title
            cell.titleColor         = data.titleColor
            cell.highLighterColor   = data.highLighter
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isSizeToFitCellsNeeded {
            let sizeee              = CGSize.init(width: 500, height: self.frame.height)
            let options             = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let str                 = dataArray[indexPath.item].title
            let estimatedRect       = NSString.init(string: str).boundingRect(with: sizeee, options: options, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)], context: nil)
        
            return CGSize.init(width: estimatedRect.size.width, height: self.frame.height)
        }
        
        return CGSize.init(width: (self.frame.width)/CGFloat(dataArray.count), height: self.frame.height)
        //  return CGSize.init(width: (self.frame.width - 10)/CGFloat(dataArray.count), height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = Int(indexPath.item)
        menuDelegate?.menuBarDidSelectItemAt(index: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //  return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}


extension UIView {
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
