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
        viewModel?.handleRestClientError(error: restError) // TODO: - parent child binding
    }
    
    func shareTappedFor(blog: Blog) {
        print("shareTappedFor")
//        viewModel?.shareBlogHasTapped.onNext(blog)
    }
    
    func commentTappedFor(blog: Blog) {
//        viewModel?.commentBtnHasTapped.onNext(blog)
    }
    
    func tappedOnContentWith(url: String) {
//        let agrume = Agrume(url: URL(string: url)!)
//        agrume.download = { url, completion in
//            let httpService = HTTPService()
//            httpService.downloadImage(imagePath: url.absoluteString) { (image) in
//                guard let image = image else { return }
//                completion(image)
//            }
//        }
//        agrume.show(from: self)
    }
}

extension BlogDetailTV: BlogCommentTVCellDelegate {
    func replyForCommentTapped(commentId: String) {
        print("replyForCommentTapped commentId: \(commentId)")
    }
    
    func updateCellFor(indexPath: IndexPath, height: CGFloat) {
        if let cell = tableView.cellForRow(at: indexPath) as? BlogCommentTVCell {
            tableView.beginUpdates()
            cell.repliesTblVwHeightCons.constant = height
            //  tableView.reloadRows(at: [indexPath], with: .automatic)
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
