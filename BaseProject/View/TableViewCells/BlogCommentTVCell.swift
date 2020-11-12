//
//  BlogCommentTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift

protocol BlogCommentTVCellDelegate: BaseTVCellDelegate {
    func replyForCommentTapped(commentId: String, indexPath: IndexPath)
    func updateCellFor(indexPath: IndexPath, height: CGFloat)
}

class BlogCommentTVCell: BaseTVCell<Comment>, UITableViewDelegate {

    @IBOutlet weak var profileImageVw: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var viewRepliesBtn: UIButton!
    @IBOutlet weak var repliesTableView: UITableView!
    @IBOutlet weak var repliesTblVwHeightCons: NSLayoutConstraint!
    
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
        //  repliesTableView.separatorInset         = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        repliesTableView.estimatedRowHeight     = 44
        repliesTableView.register(UINib(nibName: String(describing: BlogCommentReplyTVCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BlogCommentReplyTVCell.self))
        
        _disposeBag.insert([
            repliesTableView.rx.setDelegate(self)
        ])
        self._children.bind(to: repliesTableView.rx.items(cellIdentifier: String(describing: BlogCommentReplyTVCell.self), cellType: BlogCommentReplyTVCell.self)) { (row, element, cell) in
            cell.configureCell(item: element, row: row, selectable: false)
        }.disposed(by: _disposeBag)
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
        // TODO: - This hard coded section index need to be dynamic. ConfigureCell method -> change row into indexpath
        blogCommentDelegate?.replyForCommentTapped(commentId: item?.id ?? "", indexPath: IndexPath(row: row ?? 0, section: 1))
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
        
        // TODO: - This hard coded section index need to be dynamic. ConfigureCell method -> change row into indexpath
        blogCommentDelegate?.updateCellFor(indexPath: IndexPath(row: row ?? 0, section: 1), height: repliesTableView.contentSize.height)
        
        NSLayoutConstraint.deactivate(constraints)
    }
    
    
}

