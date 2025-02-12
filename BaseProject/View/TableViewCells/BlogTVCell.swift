//
//  BlogTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/3/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import ActiveLabel

protocol BlogTVCellDelegate: BaseTVCellDelegate {
    func shareTappedFor(blog: Blog)
    func commentTappedFor(blog: Blog)
    func likeError(restError: RestClientError)
    func tappedOnContentWith(url: String)
}

class BlogTVCell: BaseTVCell<Blog>, NCCarouselDelegate {
    
    @IBOutlet weak var profileImageVw           : UIImageView!
    @IBOutlet weak var userNameLbl              : UILabel!
    @IBOutlet weak var timeAgoLbl               : UILabel!
    @IBOutlet weak var titleLbl                 : UILabel!
    @IBOutlet weak var captionLbl               : ActiveLabel!
    @IBOutlet weak var carousel                 : NCCarousel!
    @IBOutlet weak var postStatusLbl            : UILabel!
    @IBOutlet weak var likeBtn                  : UIButton!
    @IBOutlet weak var commentBtn               : UIButton!
    @IBOutlet weak var shareBtn                 : UIButton!
    
    
    weak var blogDelegate                       : BlogTVCellDelegate?
    override weak var delegate                  : BaseTVCellDelegate? {
        get {
            return blogDelegate
        }
        set {
            if let newViewModel = newValue as? BlogTVCellDelegate {
                blogDelegate = newViewModel
            } else {
                print("incorrect BaseVM type for BaseVC")
            }
        }
    }
    
    var isNetworkCallGoing                      = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle                     = .none
        self.backgroundColor                    = .white
        self.hideSeparator()
        self.profileImageVw.layer.cornerRadius  = self.profileImageVw.frame.width / 2
        userNameLbl.text                        = ""
        timeAgoLbl.text                         = ""
        titleLbl.text                           = ""
        
        captionLbl.text                         = ""
        captionLbl.hashtagColor                 = AppConfig.si.colorPrimary
        
        postStatusLbl.text                      = ""
        
        likeBtn.setImage(#imageLiteral(resourceName: "icon_like").withRenderingMode(.alwaysTemplate), for: .normal)
        commentBtn.setImage(#imageLiteral(resourceName: "icon_comment").withRenderingMode(.alwaysTemplate), for: .normal)
        shareBtn.setImage(#imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageVw.image                    = UIImage(named: AppConfig.si.defaultAvatar_ImageName)
        userNameLbl.text                        = ""
        timeAgoLbl.text                         = ""
        titleLbl.text                           = ""
        captionLbl.text                         = ""
        carousel.reset()
        postStatusLbl.text                      = ""
    }
    
    override func configureCell(item: Blog, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        profileImageVw.setImageWith(imagePath: item.owner?.imageUrl ?? "", completion: nil)
        userNameLbl.attributedText              = getUsername(username: item.owner?.name ?? "", location: item.location ?? "")
        timeAgoLbl.text                         = item.createdDate?.displayText ?? ""
        titleLbl.text                           = item.title
        captionLbl.text                         = item.desc
        postStatusLbl.text                      = "\(item.totalLikes!) Likes  •  \(item.totalComments!) Comments"
        
        carousel.delegate                       = self
        carousel.configCarousel(mediaUrls: item.content ?? [])
        
        likeBtn.tintColor                       = item.isLiked == true ? AppConfig.si.colorPrimary : .darkGray
        
    }
    
    func didSelectCarouselView(_ view: NCCarousel, _ index: Int, _ mediaUrl: String) {
        blogDelegate?.tappedOnContentWith(url: mediaUrl)
    }
    
    func getUsername(username: String, location: String) -> NSAttributedString {
        if location == "" {
            let attributedString                    = NSMutableAttributedString(string: username)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: 0, length: username.count))
            return attributedString
        } else {
            let is_in_string                        = " is in "
            let attributedString                    = NSMutableAttributedString(string: "\(username)\(is_in_string)\(location)")
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: username.count, length: is_in_string.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: 0, length: username.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: username.count + is_in_string.count, length: location.count))
            return attributedString
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        guard !isNetworkCallGoing else { return }
        isNetworkCallGoing                      = true
        if let blog = self.item, let blogId = blog.blogId {
            let httpService                     = HTTPService()
            httpService.likeBlog(blogId: blogId, isLike: !(blog.isLiked ?? false), onSuccess: { [weak self] in
                self?.item?.isLiked             = !(blog.isLiked ?? false)
                self?.likeBtn.tintColor         = self?.item?.isLiked == true ? AppConfig.si.colorPrimary : .darkGray
                self?.isNetworkCallGoing        = false
            }) { [weak self] (error) in
                self?.blogDelegate?.likeError(restError: error)
                self?.isNetworkCallGoing        = false
            }
        }
    }
    
    @IBAction func commentBtnTapped(_ sender: Any) {
        if let item = self.item {
            blogDelegate?.commentTappedFor(blog: item)
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        if let item = self.item {
            blogDelegate?.shareTappedFor(blog: item)
        }
    }
    
}
