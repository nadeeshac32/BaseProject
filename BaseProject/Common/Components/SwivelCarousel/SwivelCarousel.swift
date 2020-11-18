//
//  SwivelCarousel.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/18/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit

public protocol SwivelCarouselDelegate: class {
    func didSelectCarouselView(_ view: SwivelCarousel, _ index: Int, _ mediaUrl: String)
}

public enum SwivelPageControlPosition                   : Int {
    case top = 0, center = 1, bottom = 2, topLeft = 3, bottomLeft = 4, topRight = 5, bottomRight = 6
}

struct SwivelCarouselConfig {
    var isAutoScroll                                    : Bool = false
    var timer                                           : Double? = 5.0
    var defaultImage                                    : String? = AppConfig.si.default_ImageName
    var isDescLayerHidden                               : Bool = true
    var isDescribedTitleHidden                          : Bool = true
    var isPageIndicatorHidden                           : Bool = false
    var displayStyle                                    : Int = 0
    var pageIndicatorPositon                            : SwivelPageControlPosition = .bottom
    var pageIndicatorColor                              : UIColor? = .white
    var describedTitleColor                             : UIColor? = .white
    var layerColor                                      : UIColor? = .white
    var videoAutoPlay                                   : Bool = true
    var videoSoundOn                                    : Bool = false
}

public class SwivelCarousel: UIView, UIScrollViewDelegate {
    public weak var delegate                            : SwivelCarouselDelegate?
    public var mediaUrls                                = [String]()
    public enum direction                               : Int { case left = -1, none, right }
    public enum displayModel                            : Int { case full = 0, halfFull = 1 }
    
    //MARK:- private property
    private var scrollView                              : UIScrollView!
    
    /// To show small discription
    private var layerView                               : UIView!
    private var describedLabel                          : UILabel!
    private var describedString                         = [String]()
    
    /// Page indicator
    private var pageControl                             : UIPageControl!
    private var indicatorPosition                       : SwivelPageControlPosition = SwivelPageControlPosition.bottom
    
    /// Display views
    private var beforeMediaView                         : SwivelMultimediaView!
    private var currentMediaView                        : SwivelMultimediaView!
    private var afterMediaView                          : SwivelMultimediaView!
    private var defaultImg                              : String?
    
    /// Current showing index
    private var currentIndex:NSInteger!
    
    /// Auto scroll timer
    private var timer                                   : Timer?
    private var timerInterval                           : Double?
    private var isAutoScrollEnabled                     : Bool?
    
    private var carouselMode                            : displayModel = displayModel.full
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setSubViewFrames()
    }
     
    //MARK:- Interface Builder(Xib,StoryBoard)
    override public func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
     
    //MARK:- initialize method
    fileprivate func initSubViews() {
        // Initialise scroll view
        scrollView                                      = UIScrollView()
        scrollView.showsVerticalScrollIndicator         = false
        scrollView.showsHorizontalScrollIndicator       = false
        scrollView.isPagingEnabled                      = true
        scrollView.bounces                              = false
        scrollView.delegate                             = self
        addSubview(scrollView)
         
        // Initialise main display views
        beforeMediaView                                 = SwivelMultimediaView(frame: self.bounds)
        currentMediaView                                = SwivelMultimediaView(frame: self.bounds)
        afterMediaView                                  = SwivelMultimediaView(frame: self.bounds)
        beforeMediaView.clipsToBounds                   = true
        currentMediaView.clipsToBounds                  = true
        afterMediaView.clipsToBounds                    = true
        scrollView.addSubview(beforeMediaView)
        scrollView.addSubview(currentMediaView)
        scrollView.addSubview(afterMediaView)
        
        // Initialise description view
        layerView                                       = UIView()
        layerView.backgroundColor                       = .black
        layerView.alpha                                 = 0.6
        describedLabel                                  = UILabel()
        describedLabel.textAlignment                    = NSTextAlignment.left
        describedLabel.font                             = UIFont.boldSystemFont(ofSize: 18)
        describedLabel.numberOfLines                    = 2
        describedLabel.textColor                        = .white
        scrollView.addSubview(layerView)
        layerView.addSubview(describedLabel)
        
        // Initialise Page controller
        pageControl                                     = UIPageControl()
        pageControl.hidesForSinglePage                  = true
        pageControl.currentPageIndicatorTintColor       = .white
        pageControl.pageIndicatorTintColor              = .gray
        addSubview(pageControl)
        
        // Initialise Tap gesture
        let singleFinger                                = UITapGestureRecognizer(target: self, action: #selector(didSelectMediaView(_:)))
        addGestureRecognizer(singleFinger)
        
        setNeedsDisplay()
    }
     
    //MARK:- UITapGestureRecognizer
    @objc fileprivate func didSelectMediaView(_ sender: UITapGestureRecognizer) {
        if mediaUrls.count > currentIndex {
            delegate?.didSelectCarouselView(self, currentIndex, mediaUrls[currentIndex])
        }
    }
    
    //MARK:- frame method
    fileprivate func setSubViewFrames() {
        scrollView.contentInset                         = UIEdgeInsets.zero
        scrollView.frame                                = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        scrollView.contentSize                          = CGSize.init(width: frame.size.width * 5, height:0)
        scrollView.contentOffset                        = CGPoint.init(x: frame.size.width * 2, y: 0)
        
        beforeMediaView.frame                           = CGRect.init(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        currentMediaView.frame                          = CGRect.init(x: scrollView.frame.size.width * 2, y: 0, width: scrollView.frame.size.width , height: scrollView.frame.size.height)
        afterMediaView.frame                            = CGRect.init(x: scrollView.frame.size.width * 3, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        layerView.frame                                 = CGRect.init(x: 0, y: scrollView.frame.size.height - 80, width: scrollView.frame.size.width * 5, height: 80)
        layerView.isUserInteractionEnabled              = false
        let labelX                                      = scrollView.frame.size.width * 2 + 10
        let labelY                                      = layerView.frame.size.height - 75
        describedLabel.frame                            = CGRect.init(x: labelX, y: labelY, width: scrollView.frame.size.width - 20, height: 70)
        
        switch indicatorPosition {
        case .top           : pageControl.center        = CGPoint.init(x: scrollView.frame.size.width / 2, y: 10);                                              break;
        case .center        : pageControl.center        = CGPoint.init(x: scrollView.frame.size.width / 2, y: scrollView.frame.size.height / 2);                break;
        case .topLeft       : pageControl.frame         = CGRect.init(x: 8 * mediaUrls.count, y: 5, width: 0, height: 10);                                      break;
        case .bottomLeft    : pageControl.frame         = CGRect.init(x: 8 * mediaUrls.count, y: Int(scrollView.frame.size.height - 10), width: 0, height: 0);  break;
        case .topRight      : pageControl.frame         = CGRect.init(x: Int(scrollView.frame.size.width) - 8 * mediaUrls.count, y: 5, width: 0, height: 10);   break;
        case .bottomRight   : pageControl.frame         = CGRect.init(x: Int(scrollView.frame.size.width) - 8 * mediaUrls.count,
                                                                      y: Int(scrollView.frame.size.height - 10), width: 0, height: 0);                          break;
        default: pageControl.center                     = CGPoint.init(x: scrollView.frame.size.width / 2, y: scrollView.frame.size.height - 10);               break;
        }
    }
    
    func configCarousel(configs: SwivelCarouselConfig = SwivelCarouselConfig(), mediaUrls: [String] = [], describedTitle: [String] = []) {
        isAutoScrollEnabled                             = configs.isAutoScroll
        timerInterval                                   = configs.timer
        defaultImg                                      = configs.defaultImage
        layerView.isHidden                              = configs.isDescLayerHidden
        describedLabel.isHidden                         = configs.isDescribedTitleHidden
        pageControl.isHidden                            = configs.isPageIndicatorHidden
        indicatorPosition                               = configs.pageIndicatorPositon
        pageControl.currentPageIndicatorTintColor       = configs.pageIndicatorColor
        describedLabel.textColor                        = configs.describedTitleColor
        layerView.backgroundColor                       = configs.layerColor
        currentMediaView.autoPlay                       = configs.videoAutoPlay
        currentMediaView.soundOn                        = configs.videoSoundOn
        setNeedsLayout()
        
        setCarouselData(mediaUrls: mediaUrls, describedTitle: describedTitle)
    }
    
    //MARK:- set data method
    public func setCarouselData(mediaUrls: [String], describedTitle: [String] = []) {
        if mediaUrls.count == 0 { return }
        self.currentIndex                               = 0
        self.mediaUrls                                  = mediaUrls
        
        // get all describeString
        var copyDescribedTitle: [String]                = describedTitle
        if describedTitle.count < mediaUrls.count {
            for _ in 0 ..< (mediaUrls.count - describedTitle.count) {
                copyDescribedTitle.append("")
            }
        }
        describedString                                 = copyDescribedTitle
        setMedia(urls: mediaUrls, curIndex: currentIndex)
        setLabel(describedTitle: describedTitle, curIndex: currentIndex)
        setScrollEnabled(url: mediaUrls, isAutoScroll: isAutoScrollEnabled ?? false)
    }
    
    //MARK:- set first display view
    fileprivate func setMedia(urls: [String], curIndex: NSInteger) {
        if urls.count == 0 { return }
    
        var beforeIndex                                 = curIndex - 1
        let currentIndex                                = curIndex
        var afterIndex                                  = curIndex + 1
        
        if beforeIndex < 0 { beforeIndex = urls.count - 1 }
        if afterIndex > urls.count - 1 { afterIndex  = 0 }
        
        currentMediaView.assetUrl                       = urls[curIndex]
        // if more than one
        if urls.count > 1 {
            beforeMediaView.assetUrl                    = urls[beforeIndex]
            afterMediaView.assetUrl                     = urls[afterIndex]
        }
        pageControl.numberOfPages                       = urls.count
        pageControl.currentPage                         = currentIndex
        layoutSubviews()
    }
    
    fileprivate func setLabel(describedTitle: [String], curIndex:NSInteger) {
        if describedTitle.count == 0 { return }
        describedLabel.text                             = describedTitle[curIndex]
    }
    
    //MARK:- set scroll method
    fileprivate func setScrollEnabled(url: [String], isAutoScroll:Bool) {
        stopAutoScroll()
        if isAutoScroll && url.count > 1 {
            scrollView.isScrollEnabled                  = true
            startAutoScroll()
        } else if url.count == 1 {
            scrollView.isScrollEnabled                  = false
        }
    }
    
    fileprivate func startAutoScroll() {
        timer                                           = Timer()
        timer                                           = Timer.scheduledTimer(timeInterval: timerInterval ?? 5, target: self, selector: #selector(autoScrollToNextImageView), userInfo: nil, repeats: true)
    }
    
    fileprivate func stopAutoScroll() {
        timer?.invalidate()
        timer                                           = nil
    }
    
    @objc fileprivate func autoScrollToNextImageView() {
        scrollView.setContentOffset(CGPoint.init(x: frame.size.width * 3, y: 0), animated: true)
    }
    
    //MARK:- UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mediaUrls.count == 0  { return }
        
        let width                                       = scrollView.frame.width
        let currentPage                                 = ((scrollView.contentOffset.x - width / 2) / width) - 1.5
        let scrollDirect                                = direction.init(rawValue: Int(currentPage))
        
        switch scrollDirect! {
        case .none:
            break
        default:
            updateCurrentIndex(scrollDirect!)
            scrollToImageView(scrollDirect!)
            break
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScrollEnabled == true {
            startAutoScroll()
        }
    }
    
    //MARK:- Update current index
    fileprivate func updateCurrentIndex(_ scrollDirect: direction) {
        switch scrollDirect {
        case .none: break;
        case .right:
            currentIndex                                = currentIndex + 1
            if currentIndex == mediaUrls.count {
                currentIndex                            = 0
            }
            break
        case .left:
            currentIndex                                = currentIndex - 1
            if currentIndex < 0 { currentIndex          = mediaUrls.count - 1 }
            break
        }
        pageControl.currentPage                         = currentIndex
    }
    
    //MARK:- change display view
    fileprivate func scrollToImageView(_ scrollDirect: direction) {
        if mediaUrls.count == 0  { return }

        switch scrollDirect {
        case .none:
            break
        case .right:
            copyAsset(from: currentMediaView, to: beforeMediaView)
            copyAsset(from: afterMediaView, to: currentMediaView)
            if currentIndex + 1 > mediaUrls.count - 1 {
                afterMediaView.assetUrl                 = mediaUrls[0]
            } else {
                afterMediaView.assetUrl                 = mediaUrls[currentIndex + 1]
            }
            break
        case .left:
            copyAsset(from: currentMediaView, to: afterMediaView)
            copyAsset(from: beforeMediaView, to: currentMediaView)
            if currentIndex - 1 < 0 {
                beforeMediaView.assetUrl                = mediaUrls[mediaUrls.count - 1]
            } else {
                beforeMediaView.assetUrl                = mediaUrls[currentIndex - 1]
            }
            break
        }

        describedLabel.text                             = describedString[currentIndex]
        scrollView.contentOffset                        = CGPoint.init(x: frame.size.width * 2, y: 0)
    }
    
    fileprivate func copyAsset(from: SwivelMultimediaView, to: SwivelMultimediaView) {
        if let image = from.getImage() {
            to.setImage(image: image)
        } else if let player = from.getVideo() {
            to.setVideo(player: player)
        } else {
            to.assetUrl                                 =  mediaUrls[currentIndex]
        }
    }
    
    //MARK:- public control method
    public func startScrollImageView() {
        startAutoScroll()
    }
    
    public func stopScrollImageView() {
        stopAutoScroll()
    }
    
    public func reset() {
        beforeMediaView.resetView()
        currentMediaView.resetView()
        afterMediaView.resetView()
    }
}













