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
        let contentArray = blog.content?.map({ BlogContent(editable: false, mediaUrl: $0, image: nil) }) ?? []
        contentGridViewModel?.contentAdd(items: contentArray)
        
        enableImagePicker.onNext(blogCreateEditMode == .create)
    }
    
    func locationSelected(location: String?) {
        blog._location.onNext(location ?? "")
    }
    
    func contentSelected(content: [UIImage]) {
        guard self.blogCreateEditMode == .create else { return }
        let contentArray = content.map({ BlogContent(editable: true, mediaUrl: nil, image: $0) })
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
        if blog.blogId == "", contentGridViewModel?.isContentAdded() == true, let content = contentGridViewModel?.getContent() {
            print(content.count)
            
//            httpService.uploadImageRequest(image: image, imageName: "\(customer.customerId ?? "")-\(Date().millisecondsSince1970)", onError: { [weak self] (error) in
//                self?.handleRestClientError(error: error)
//            }) { [weak self] (imageResponse) in
//                self?.customer._imageUrl.onNext(imageResponse.imageUrl ?? "")
//                self?.createOrUpdateCustomerRequest(httpService: httpService)
//            }
            
            // TODO: - Upload media files
            // TODO: - Update blog.content with response.urls: [String]
            // TODO: - Call createOrUpdateCustomerRequest(httpService: httpService)
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
    
}
