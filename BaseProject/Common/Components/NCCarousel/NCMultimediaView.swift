//
//  NCMultimediaView.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/12/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class NCMultimediaView: GenericView {
    
    fileprivate var player                      : AVPlayer?
    fileprivate var playerLayer                 : AVPlayerLayer?
    var autoPlay                                : Bool = false
    var soundOn                                 : Bool = false
    
    fileprivate let imageView                   : UIImageView = {
        let view                                = UIImageView()
        view.clipsToBounds                      = true
        view.contentMode                        = .scaleAspectFill
        return view
    }()
    
    var asset: PHAsset? {
        didSet {
            guard let asset = self.asset else { imageView.image = nil; return; }
            resetView()
            if asset.mediaType == .image {
                previewPhoto(from: asset)
            } else {
                previewVideo(from: asset)
            }
        }
    }
    
    var assetUrl: String? {
        didSet {
            guard let assetUrl = assetUrl else { imageView.image = nil; return; }
            resetView()
            previewPhoto(from: assetUrl)
        }
    }
    
    deinit {
        print("NCMultimediaView deinit")
        player?.pause()
    }
    
    override func configureView() {
        super.configureView()
        self.addAligned(imageView)
    }
        
    private func previewPhoto(from url: String) {
        let httpService                             = HTTPService()
        httpService.downloadImage(imagePath: url) { [weak self] (image) in
            if let image = image {
                self?.imageView.image               = image
            } else if let url = URL(string: url) {
                self?.previewVideo(from: url)
            }
        }
    }
    
    func setVideo(player: AVPlayer) {
        self.imageView.image                        = nil
        let playerLayer                             = AVPlayerLayer(player: player)
        playerLayer.videoGravity                    = AVLayerVideoGravity.resizeAspect
        playerLayer.masksToBounds                   = true
        playerLayer.frame                           = self.imageView.bounds
        self.imageView.layer.addSublayer(playerLayer)
        self.playerLayer                            = playerLayer
        self.player                                 = player
        player.isMuted                              = !(self.soundOn)
        if self.autoPlay == true { player.play() }
    }
    
    func setImage(image: UIImage) {
        player                                      = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer                                 = nil
        imageView.image                             = image
    }
    
    private func previewVideo(from url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let player                              = AVPlayer(url: url)
            let playerLayer                         = AVPlayerLayer(player: player)
            playerLayer.videoGravity                = AVLayerVideoGravity.resizeAspect
            playerLayer.masksToBounds               = true
            playerLayer.frame                       = self.imageView.bounds
            self.imageView.layer.addSublayer(playerLayer)
            self.playerLayer                        = playerLayer
            self.player                             = player
            player.isMuted                          = !(self.soundOn)
            if self.autoPlay == true { player.play() }
        }
    }
    
    private func previewVideo(from asset: PHAsset) {
        PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { [weak self] (avAsset, audio, info) in
            DispatchQueue.main.async { [weak self] in
                if let avAsset = avAsset {
                    let playerItem              = AVPlayerItem(asset: avAsset)
                    let player                  = AVPlayer(playerItem: playerItem)
                    let playerLayer             = AVPlayerLayer(player: player)
                    playerLayer.videoGravity    = AVLayerVideoGravity.resizeAspect
                    playerLayer.masksToBounds   = true
                    playerLayer.frame           = self?.imageView.bounds ?? .zero
                    
                    self?.imageView.layer.addSublayer(playerLayer)
                    self?.playerLayer           = playerLayer
                    self?.player                = player
                    
                    if self?.soundOn == true {
                        player.isMuted          = false
                    } else {
                        player.isMuted          = true
                    }
                    
                    if self?.autoPlay == true {
                        player.play()
                    }
                } else {
                    self?.previewPhoto(from: asset)
                }
            }
        })
    }
    
    private func previewPhoto(from asset: PHAsset) {
        fetchImage(for: asset, canHandleDegraded: false, completion: { [weak self] in self?.imageView.image = $0 })
    }
    
    private func fetchImage(for asset: PHAsset, canHandleDegraded: Bool = true, completion: @escaping ((UIImage?) -> Void)) {
        let options                             = PHImageRequestOptions()
        options.isNetworkAccessAllowed          = true
        options.deliveryMode                    = .opportunistic
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
            if !canHandleDegraded {
                if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool, isDegraded { return }
            }
            completion(image)
        })
    }
        
    func resetView() {
        imageView.image                         = nil
        player                                  = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer                             = nil
    }
    
    func getImage() -> UIImage? {
        return self.imageView.image
    }
    
    func getVideo() -> AVPlayer? {
        return self.player
    }
}


private extension UIView {
    func addAligned(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
