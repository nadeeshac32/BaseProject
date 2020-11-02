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


//class BlogCreateEditVM: BaseCollectionVM<BlogContent> {
class BlogCreateEditVM: BaseFormVM, BaseCollectionVMDataSource {

    var blog                                            : Blog
    var imageGridViewModel                              : BlogCreateEditGridVM?
    
    // MARK: - Inputs
    let addPhotosTapped                                 : AnyObserver<Void>
    let addLocationTapped                               : AnyObserver<Void>
    
    // MARK: - Outputs
    let showImagePicker                                 : Observable<Void>
    let showLocationPicker                              : Observable<Void>
    let updateWithLocation                              : Observable<(usernameString: NSAttributedString, isActiveLocationBtn: Bool)>
    
    deinit {
        print("deinit BlogCreateEditVM")
    }
    
    init(blog: Blog) {
        self.blog                                       = blog
        
        updateWithLocation = blog._location.asObservable().map({ (location) -> (usernameString: NSAttributedString, isActiveLocationBtn: Bool) in
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
        imageGridViewModel                              = BlogCreateEditGridVM(dataSource: self)
        childViewModels.append(imageGridViewModel!)
    }
    
    func locationSelected(location: String?) {
        blog._location.onNext(location ?? "")
    }
    
    func imagesSelected(image: [UIImage]) {
        print("Images Selected")
    }
    
    
    // MARK: - Network request
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }
            freezeForRequestLoading.onNext(true)
        } catch let error { print("Fetal error: \(error)") }
        
        let httpService                                 = HTTPService()
        if blog.blogId == "", blog.imageHasEdited(), let images = blog.editedValues()?.images {
            print(images.count)
//            httpService.uploadImageRequest(image: image, imageName: "\(customer.customerId ?? "")-\(Date().millisecondsSince1970)", onError: { [weak self] (error) in
//                self?.handleRestClientError(error: error)
//            }) { [weak self] (imageResponse) in
//                self?.customer._imageUrl.onNext(imageResponse.imageUrl ?? "")
//                self?.createOrUpdateCustomerRequest(httpService: httpService)
//            }
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
