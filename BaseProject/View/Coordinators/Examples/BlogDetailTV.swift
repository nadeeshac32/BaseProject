//
//  BlogDetailTV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import Agrume

class BlogDetailTV: AdvancedBaseList<BlogDetailTVCellType, BlogDetailTableViewSection, BlogDetailTVVM> {
    deinit { print("deinit BlogDetailTV") }
    
    override var isDynemicSectionTitles: Bool { get { return false } set {} }
    override var cellLoadFromNib: Bool { get { return true } set {} }
    
    override init(viewModel: BlogDetailTVVM, tableView: UITableView!, delegate: BaseListDelagate) {
        super.init(viewModel: viewModel, tableView: tableView, delegate: delegate)
        self.tableView.bounces = true
    }
}

extension BlogDetailTV: BlogTVCellDelegate {
    
    func likeError(restError: RestClientError) {
        viewModel?.handleRestClientError(error: restError)
    }
    
    func shareTappedFor(blog: Blog) {
        viewModel?.shareBtnTapped(blog: blog)
    }
    
    func commentTappedFor(blog: Blog) {
        viewModel?.typeCmmentForBlog.onNext(true)
    }
    
    func tappedOnContentWith(url: String) {
        viewModel?.viewContent(url: url)
    }
}

extension BlogDetailTV: BlogCommentTVCellDelegate {
    func replyForCommentTapped(commentId: String, indexPath: IndexPath) {
        viewModel?.typeReplyCommentFor.onNext((commentId: commentId, commentIndexPath: indexPath))
    }
    
    func updateCellFor(indexPath: IndexPath, height: CGFloat) {
        if let cell = tableView.cellForRow(at: indexPath) as? BlogCommentTVCell {
            tableView.beginUpdates()
            cell.repliesTblVwHeightCons.constant = height
            UIView.animate(withDuration: 0.3) { cell.layoutIfNeeded() }
            tableView.endUpdates()
        }
    }
}

enum BlogDetailTVCellType: AdvancedAnimatableSectionModelTypeSupportedItem {
    typealias Identity              = String
    
    case blog(blog: Blog)
    case comment(comment: Comment)
    
    init?(model: BaseModel) {
        if      let blog            = model as? Blog        { self = .blog(blog: blog) }
        else if let comment         = model as? Comment     { self = .comment(comment: comment) }
        else                                                { return nil }
    }
    
    var identity                    : Identity {
        switch self {
        case let .blog(blog)        : return blog.blogId ?? ""
        case let .comment(comment)  : return comment.id ?? ""
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
                tableViewCell.delegate                      = cellDelegate
            }
        case let .comment(comment)  :
            if let tableViewCell    = cell as? BlogCommentTVCell {
                tableViewCell.configureCell(item: comment, row: row, selectable: false)
                tableViewCell.delegate                      = cellDelegate
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
