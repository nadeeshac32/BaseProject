//
//  BlogDetail_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/5/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

class BlogDetailVC: BaseVC<BlogDetailVM>, BaseListDelagate {    //BaseFormVC<BlogDetailVM>, BaseListDelagate {
    
//    @IBOutlet public weak var _scrollView                   : BaseScrollView!
//    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
//    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
//    @IBOutlet public weak var _submitButton                 : UIButton!
//    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
    
    @IBOutlet public weak var _contentTV                    : UITableView!
    var contentTV                                           : BlogDetailTV?
    
//    override var dynemicGapShouldCalculate                  : Bool { get { return false } set {} }
//    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 475 } set {} }
//    override var scrollViewMinimumDynemicGap                : CGFloat { get { return 50 } set {} }
//    override var scrollViewBottomConsRealValue              : CGFloat { get { return 34 } set {} }
 
    deinit { print("deinit BlogDetailVC") }
        
    override func customiseView() {
        super.customiseView()
        self.addBackButton(title: "Back")
        
          if let contentTableViewModel = viewModel?.contentTableViewModel {
              self.contentTV                                = BlogDetailTV(viewModel: contentTableViewModel, tableView: _contentTV, delegate: self)
              contentTV?.setupBindings()
          }
    }
    
    override func setupBindings() {
        super.setupBindings()
        //  if let viewModel = self.viewModel { disposeBag.insert([]) }
    }
}

enum BlogDetailTVCellType: AdvancedAnimatableSectionModelTypeSupportedItem {
    typealias Identity              = String
    
    case blog(blog: Blog)
    case comment(comment: BlogComment)
    
    init?(model: BaseModel) {
        if      let blog            = model as? Blog        { self = .blog(blog: blog) }
        else if let comment         = model as? BlogComment { self = .comment(comment: comment) }
        else                                                { return nil }
    }
    
    var identity                    : Identity {
        switch self {
        case let .blog(blog)        : return blog.blogId ?? ""
        case let .comment(comment)  : return comment.blogCommentId ?? ""
        }
    }
    
    static func == (lhs: BlogDetailTVCellType, rhs: BlogDetailTVCellType) -> Bool {
        return lhs.identity == rhs.identity
    }

    func getCellIdentifier() -> String {
        switch self {
        case .blog                  : return String(describing: BlogTVCell.self)
        case .comment               : return String(describing: BlogCommentTVCell.self) }
    }
    
    func getConfiguredTableCellType(cell: UITableViewCell, row: Int, selectable: Bool, cellDelegate: BaseTVCellDelegate) {
        switch self {
        case let .blog(blog)        :
            if let tableViewCell    = cell as? BlogTVCell {
                tableViewCell.configureCell(item: blog, row: row, selectable: false)
                tableViewCell.delegate = cellDelegate

            }
        case let .comment(comment)  :
            if let tableViewCell    = cell as? BlogCommentTVCell {
                tableViewCell.configureCell(item: comment, row: row, selectable: false)
                tableViewCell.delegate = cellDelegate
            }
        }
        
    }
    
    func setSelected(isSelected: Bool) {
        switch self {
        case let .blog(blog)        : blog.isSelected       = isSelected; break;
        case let .comment(comment)  : comment.isSelected    = isSelected; break;
        }
    }
    
    static func getCellIdentifiers() -> [String] {
        return [String(describing: BlogTVCell.self), String(describing: BlogCommentTVCell.self)]
    }
}

struct BlogDetailTableViewSection: AdvancedAnimatableSectionModelType {
    typealias Item                  = BlogDetailTVCellType
    var header                      : String
    var items                       : [Item]
    
    var identity: String {
        return header
    }
    
    init(header: String, items: [Item]) {
        self.header                 = header
        self.items                  = items
    }
    
    init(original: Self, items: [Self.Item]) {
        self                        = original
        self.items                  = items
    }
}
