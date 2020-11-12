//
//  SwivelMultimediaView.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/12/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class SwivelMultimediaView: GenericView {
    
    fileprivate var player                      : AVPlayer?
    fileprivate var playerLayer                 : AVPlayerLayer?
    
    fileprivate let imageView                   : UIImageView = {
        let view                                = UIImageView()
        view.clipsToBounds                      = true
        view.contentMode                        = .scaleAspectFill
        return view
    }()
    
    open var asset: PHAsset? {
        didSet {
            guard let asset = self.asset else {
                imageView.image                 = nil
                return
            }
            
            if asset.mediaType == .image {
                previewPhoto(from: asset)
            } else {
                previewVideo(from: asset)
            }
        }
    }
    
    deinit {
        player?.pause()
    }
    
    override func configureView() {
        super.configureView()
        self.addAligned(imageView)
    }
        
    func fetchImage(for asset: PHAsset, canHandleDegraded: Bool = true, completion: @escaping ((UIImage?) -> Void)) {
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
    
    func previewVideo(from asset: PHAsset) {
        PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, audio, info) in
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
                    
                    player.play()
                } else {
                    self?.previewPhoto(from: asset)
                }
            }
        })
    }
    
    func previewPhoto(from asset: PHAsset) {
        fetchImage(for: asset, canHandleDegraded: false, completion: { self.imageView.image = $0 })
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
