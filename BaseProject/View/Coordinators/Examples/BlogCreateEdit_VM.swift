//
//  BlogCreateEdit_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Photos
import TLPhotoPicker

enum BlogCreateEditMode {
    case edit, create
}

class BlogCreateEditVM: BaseFormVM, BaseCollectionVMDataSource {

    var blog                                            : Blog
    var contentGridViewModel                            : BlogCreateContentGridVM?
    var blogCreateEditMode                              : BlogCreateEditMode
    
    // MARK: - Inputs
    let addPhotosTapped                                 : AnyObserver<Void>
    let addLocationTapped                               : AnyObserver<Void>
    
    // MARK: - Outputs
    let showImagePicker                                 : Observable<Void>
    let showLocationPicker                              : Observable<Void>
    let updateWithLocation                              : Observable<(usernameString: NSAttributedString, isActiveLocationBtn: Bool)>
    let enableImagePicker                               = BehaviorSubject<Bool>(value: false)
    
    deinit {
        print("deinit BlogCreateEditVM")
    }
    
    init(blog: Blog, blogCreateEditMode: BlogCreateEditMode = .create) {
        self.blog                                       = blog
        self.blogCreateEditMode                         = blogCreateEditMode
        
        updateWithLocation                              = blog._location.asObservable().map({ (location) -> (usernameString: NSAttributedString, isActiveLocationBtn: Bool) in
            if location == "" {
                let username                            = User.si.fullName ?? ""
                let attributedString                    = NSMutableAttributedString(string: username)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: 0, length: username.count))
                return (usernameString: attributedString, isActiveLocationBtn: false)
            } else {
                let username                            = User.si.fullName ?? ""
                let is_in_string                        = " is in "
                let attributedString                    = NSMutableAttributedString(string: "\(username)\(is_in_string)\(location)")
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: username.count, length: is_in_string.count))
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: 0, length: username.count))
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSRange(location: username.count + is_in_string.count, length: location.count))
                return (usernameString: attributedString, isActiveLocationBtn: true)
            }
        })
        
        let _addPhotosBtnTapped                         = PublishSubject<Void>()
        addPhotosTapped                                 = _addPhotosBtnTapped.asObserver()
        showImagePicker                                 = _addPhotosBtnTapped.asObservable()
        
        let _addLocationTapped                          = PublishSubject<Void>()
        addLocationTapped                               = _addLocationTapped.asObserver()
        showLocationPicker                              = _addLocationTapped.asObservable()
        
        super.init()
        contentGridViewModel                              = BlogCreateContentGridVM(dataSource: self)
        childViewModels.append(contentGridViewModel!)
        
        enableImagePicker.onNext(blogCreateEditMode == .create)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentArray = blog.content?.map({ BlogContent(editable: false, mediaUrl: $0, asset: nil) }) ?? []
        contentGridViewModel?.contentAdd(items: contentArray)
    }
    
    func locationSelected(location: String?) {
        blog._location.onNext(location ?? "")
    }
    
    func contentSelected(content: [TLPHAsset]) {
        guard self.blogCreateEditMode == .create else { return }
        let contentArray = content.map({ BlogContent(editable: true, mediaUrl: nil, asset: $0) })
        contentGridViewModel?.contentAdd(items: contentArray)
    }
    
    // MARK: - Network request
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }
            freezeForRequestLoading.onNext(true)
        } catch let error { print("Fetal error: \(error)") }
        
        let httpService                                 = HTTPService()
        if blog.blogId == "", contentGridViewModel?.isContentAdded() == true, let content = contentGridViewModel?.getNewContent() {
            guard let assets = content.filter({ $0.asset != nil}).map({ $0.asset }) as? [TLPHAsset] else { return }
            getUrlsFrom(_assets: assets, _urls: []) { (multimediaPostDataArray) in
                httpService.uploadFilesRequest(files: multimediaPostDataArray, onError: { [weak self] (error) in
                    self?.handleRestClientError(error: error)
                    FileManager.default.clearTmpDirectory()
                }, progressHandler: { (progress) in
                    print("progress: \(progress)")
                }) { [weak self] (uploadResponse) in
                    if let items = uploadResponse.data?.items, let urlsArray = items.filter({ $0.url != nil }).map({ $0.url }) as? [String] {
                        self?.blog.content  = urlsArray
                        self?.createOrUpdateCustomerRequest(httpService: httpService)
                        FileManager.default.clearTmpDirectory()
                    }
                }
            }
        } else {
            createOrUpdateCustomerRequest(httpService: httpService)
        }
    }
    
    func createOrUpdateCustomerRequest(httpService: HTTPService) {
        if blog.blogId == "" {
            httpService.createBlog(blog: self.blog.copy() as? Blog, onSuccess: { [weak self] in
                self?.handleSuccessResponse(added: true)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } else {
            httpService.updateBlog(blog: self.blog.copy() as? Blog, onSuccess: { [weak self] in
                self?.handleSuccessResponse(added: false)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        }
    }
    
    func handleSuccessResponse(added: Bool) {
        self.freezeForRequestLoading.onNext(false)
        self.blog.updateSaved()
        let message             = added ? "Post successful." : "Successfully updated post."
        let tupple              = (message: message, blockScreen: true, completionHandler: { [weak self] in self?.goToPreviousVC.onNext(true) })
        self.successMessage.onNext(tupple)
    }
    
    func getUrlsFrom(_assets: [TLPHAsset], _urls: [MultimediaPostData], completionHandler: @escaping ((_ urls: [MultimediaPostData]) -> Void)) {
        var assets  = _assets
        var urls    = _urls
        if let asset = assets.popLast() {
            if asset.type == .video {
                asset.exportVideoFile { [weak self] (url, mimeType) in
                    urls.append(MultimediaPostData(url: url, image: nil, mimeType: mimeType))
                    if assets.count > 0 {
                        self?.getUrlsFrom(_assets: assets, _urls: urls, completionHandler: completionHandler)
                    } else {
                        completionHandler(urls)
                    }
                }
            } else if let image = asset.fullResolutionImage {
                urls.append(MultimediaPostData(url: nil, image: image, mimeType: nil))
                if assets.count > 0 {
                    getUrlsFrom(_assets: assets, _urls: urls, completionHandler: completionHandler)
                } else {
                    completionHandler(urls)
                }
            } else {
                if assets.count > 0 {
                    getUrlsFrom(_assets: assets, _urls: urls, completionHandler: completionHandler)
                } else {
                    completionHandler(urls)
                }
            }
        } else {
            completionHandler(urls)
        }
    }
    
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
