//
//  BlogCommentTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxSwift
import DropDown

protocol BlogCommentTVCellDelegate: BaseTVCellDelegate {
    func replyForCommentTapped(commentId: String, commentOwner: String)
    func updateCell(update: (_ tableView: UITableView) -> Void)
    func handleRestClientError(error: RestClientError)
    func commentDelete(commentId: String, item: Comment)
    func editComment(isChildComment: Bool, commentId: String, comment: String, parentCommentOwner: String?)
}

class BlogCommentTVCell: BaseTVCell<Comment>, UITableViewDelegate {

    @IBOutlet weak var profileImageVw: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var viewRepliesBtn: UIButton!
    @IBOutlet weak var repliesTableView: UITableView!
    @IBOutlet weak var repliesTblVwHeightCons: NSLayoutConstraint!
    
    let dropDown                                        = DropDown()
    
    let _disposeBag = DisposeBag()
    weak var blogCommentDelegate: BlogCommentTVCellDelegate?
    override weak var delegate   : BaseTVCellDelegate? {
        get {
            return blogCommentDelegate
        }
        set {
            if let newViewModel = newValue as? BlogCommentTVCellDelegate {
                blogCommentDelegate = newViewModel
            } else {
                print("incorrect BaseVM type for BaseVC")
            }
        }
    }
    
    var isNetworkCallGoing                              = false
    var _children: BehaviorSubject<[BlogChildComment]>  = BehaviorSubject<[BlogChildComment]>(value: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                     = .none
        self.backgroundColor                    = .white
        self.profileImageVw.layer.cornerRadius  = self.profileImageVw.frame.width / 2
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        usernameLbl.text                        = ""
        commentLbl.text                         = ""
        dateLbl.text                            = ""
        viewRepliesBtn.isHidden                 = true
        
        // MARK: - Configure tableView
        repliesTableView.tableHeaderView        = UIView(frame: CGRect.zero)
        repliesTableView.tableFooterView        = UIView(frame: CGRect.zero)
        repliesTableView.bounces                = false
        repliesTableView.backgroundColor        = UIColor.clear
        repliesTableView.estimatedRowHeight     = 44
        repliesTableView.register(UINib(nibName: String(describing: BlogCommentReplyTVCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BlogCommentReplyTVCell.self))
        
        dropDown.anchorView     = moreBtn
        dropDown.direction      = .bottom
        dropDown.width          = 100
        dropDown.bottomOffset   = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource     = ["Edit", "Delete"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                if let comment = self.item?.parent?.comment, let commentId = self.item?.parent?.id {
                    self.blogCommentDelegate?.editComment(isChildComment: false, commentId: commentId, comment: comment, parentCommentOwner: nil)
                }
            } else if index == 1 {
                if let id = self.item?.parent?.id, let item = self.item {
                    self.blogCommentDelegate?.commentDelete(commentId: id, item: item)
                }
            }
        }
        
        _disposeBag.insert([
            repliesTableView.rx.setDelegate(self),
            self._children.bind(to: repliesTableView.rx.items(cellIdentifier: String(describing: BlogCommentReplyTVCell.self), cellType: BlogCommentReplyTVCell.self)) { [unowned self] (row, element, cell) in
                cell.configureCell(item: element, row: row, selectable: false)
                cell.replyCommentCellDelegate       = self
            }
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        usernameLbl.text                        = ""
        commentLbl.text                         = ""
        dateLbl.text                            = ""
        viewRepliesBtn.setTitle("View Replies", for: .normal)
        viewRepliesBtn.isHidden                 = true
        repliesTblVwHeightCons.constant         = 0
        item?.isExpanded                        = false
        _children.onNext([])
    }
    
    override func configureCell(item: Comment, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        if let parent = item.parent {
            profileImageVw.setImageWith(imagePath: item.parent?.owner?.imageUrl ?? "", completion: nil)
            usernameLbl.text                    = parent.owner?.name ?? ""
            dateLbl.text                        = parent.createdDate?.displayDate ?? ""
            parent._comment.bind(to: commentLbl.rx.text).disposed(by: disposeBag)
        }
        viewRepliesBtn.isHidden                 = item.children.count == 0
    }
    
    @IBAction func replyBtnTapped(_ sender: Any) {
        blogCommentDelegate?.replyForCommentTapped(commentId: item?.id ?? "", commentOwner: item?.parent?.owner?.name ?? "")
    }
    
    @IBAction func viewRepliesBtnTapped(_ sender: Any) {
        let commentLblHeightCons                = commentLbl.heightAnchor.constraint(equalToConstant: commentLbl.frame.height)
        commentLblHeightCons.priority           = UILayoutPriority(rawValue: 999)
        let constraints                         = [commentLblHeightCons]
        NSLayoutConstraint.activate(constraints)
        
        if item?.isExpanded == false {
            _children.onNext(item?.children ?? [])
            viewRepliesBtn.setTitle("Hide Replies", for: .normal)
        } else if item?.isExpanded == true {
            _children.onNext([])
            viewRepliesBtn.setTitle("View Replies", for: .normal)
        }
        item?.isExpanded = !(item?.isExpanded ?? true)
        
        blogCommentDelegate?.updateCell(update: { [weak self] (tv) in
            tv.beginUpdates()
            self?.repliesTblVwHeightCons.constant = self?.repliesTableView.contentSize.height ?? 0
            UIView.animate(withDuration: 0.3) { self?.layoutIfNeeded() }
            tv.endUpdates()
        })
        NSLayoutConstraint.deactivate(constraints)
    }
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        dropDown.show()
    }
    
    var ongoingNetworkCall                          = false
    func deleteChildComment(commentId: String) {
        if ongoingNetworkCall { return }
        let httpService                             = HTTPService()
        ongoingNetworkCall                          = true
        // Show activity indicator
        httpService.deleteCommentWithId(commentId: commentId, onSuccess: { [unowned self] in
            self.ongoingNetworkCall                 = false
            // Hide activity indicator
            
            let commentLblHeightCons                = self.commentLbl.heightAnchor.constraint(equalToConstant: self.commentLbl.frame.height)
            commentLblHeightCons.priority           = UILayoutPriority(rawValue: 999)
            let constraints                         = [commentLblHeightCons]
            NSLayoutConstraint.activate(constraints)
            
            let replyComments = self.item?.children.filter({ $0.id != commentId }) ?? []
            self.item?.children = replyComments
            self._children.onNext(self.item?.children ?? [])
            
            self.viewRepliesBtn.setTitle((self.item?.children.count ?? 0) > 0 ? "Hide Replies" : "View Replies", for: .normal)
            self.item?.isExpanded                   = (self.item?.children.count ?? 0) > 0 ? true : false
            self.viewRepliesBtn.isHidden            = (self.item?.children.count ?? 0) == 0
            self.blogCommentDelegate?.updateCell(update: { [weak self] (tv) in
                tv.beginUpdates()
                self?.repliesTblVwHeightCons.constant = self?.repliesTableView.contentSize.height ?? 0
                UIView.animate(withDuration: 0.3) { self?.layoutIfNeeded() }
                tv.endUpdates()
            })
            
            NSLayoutConstraint.deactivate(constraints)
            
        }) { [weak self] (error) in
            self?.ongoingNetworkCall    = false
            // Hide activity indicator
            self?.blogCommentDelegate?.handleRestClientError(error: error)
        }
    }
}


extension BlogCommentTVCell: BlogCommentReplyTVCellDelegate {
    func replyCommentEdit(comment: String, commentId: String) {
        if let ownerName = self.item?.parent?.owner?.name {
            self.blogCommentDelegate?.editComment(isChildComment: true, commentId: commentId, comment: comment, parentCommentOwner: ownerName)
        }
    }
    
    func replyCommentDelete(commentId: String) {
        deleteChildComment(commentId: commentId)
    }
}
