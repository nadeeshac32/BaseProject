//
//  BlogPostTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/25/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import AACarousel

protocol BlogDelegate: BaseTVCellDelegate {
    func shareTappedFor(blog: Blog)
    func likeError(restError: RestClientError)
}

class BlogPostTVCell: BaseTVCell<Blog>, AACarouselDelegate {
    
    @IBOutlet weak var profileImageVw           : UIImageView!
    @IBOutlet weak var userNameLbl              : UILabel!
    @IBOutlet weak var timeAgoLbl               : UILabel!
    @IBOutlet weak var captionLbl               : UILabel!
    @IBOutlet weak var carousel                 : AACarousel!
    @IBOutlet weak var postStatusLbl            : UILabel!
    @IBOutlet weak var likeBtn                  : UIButton!
    @IBOutlet weak var commentBtn               : UIButton!
    @IBOutlet weak var shareBtn                 : UIButton!
    
    var blogDelegate: BlogDelegate?
    override weak var delegate   : BaseTVCellDelegate? {
        get {
            return blogDelegate
        }
        set {
            if let newViewModel = newValue as? BlogDelegate {
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
        likeBtn.setImage(#imageLiteral(resourceName: "icon_like").withRenderingMode(.alwaysTemplate), for: .normal)
        commentBtn.setImage(#imageLiteral(resourceName: "icon_comment").withRenderingMode(.alwaysTemplate), for: .normal)
        shareBtn.setImage(#imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    override func configureCell(item: Blog, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        profileImageVw.image                    = UIImage(named: item.owner?.imageUrl ?? "")
        userNameLbl.text                        = item.owner?.name
        timeAgoLbl.text                         = item.createdDate?.displayText
        captionLbl.text                         = item.title!
        postStatusLbl.text                      = "\(item.totalLikes!) Likes  •  \(item.totalComments!) Comments" //  •  \(item.totalShares!) Shares"
        
        carousel.delegate                       = self
        carousel.setCarouselData(paths: item.content ?? [],  describedTitle: [], isAutoScroll: true, timer: 5.0, defaultImage: "defaultImage")
        //optional methods
        carousel.setCarouselOpaque(layer: true, describedTitle: false, pageIndicator: false)
        carousel.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
        
        likeBtn.tintColor                       = item.isLiked == true ? AppConfig.si.colorPrimary : .darkGray
        
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        print("\(index)")
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        imageView.setImageWith(imagePath: url.first ?? "", completion: nil)
    }
    
    func downloadImages(_ url: String, _ index: Int) {
        let httpService                         = HTTPService()
        httpService.downloadImage(imagePath: url) { [weak self](image) in
            if let image = image {
                self?.carousel.images[index]    = image
            } else {
                print("nil image")
            }
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
                (self?.delegate as? BlogDelegate)?.likeError(restError: error)
                self?.isNetworkCallGoing        = false
            }
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        if let item = self.item {
            (delegate as? BlogDelegate)?.shareTappedFor(blog: item)
        }
    }
    
}
