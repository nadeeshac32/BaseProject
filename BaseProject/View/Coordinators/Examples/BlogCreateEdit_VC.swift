//
//  BlogCreateEdit_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/27/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class BlogCreateEditVC: BaseFormVC<BlogCreateEditVM> {
    @IBOutlet weak var userImageVw                          : UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var titleTxtFld                          : NCNormalTextField!
    @IBOutlet weak var descTxtVw                            : NCNormalTextView!
    @IBOutlet weak var postItemsContainer                   : UIView!
    @IBOutlet weak var addPhotoBtn                          : UIButton!
    @IBOutlet weak var addLocationBtn                       : UIButton!
    @IBOutlet public weak var _contentCV                    : UICollectionView!
    var contentGrid                                         : BlogCreateContentGrid?
    
    @IBOutlet public weak var _scrollView                   : BaseScrollView!
    @IBOutlet public weak var _dynemicGapCons               : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewTopCons            : NSLayoutConstraint!
    @IBOutlet public weak var _scrollViewBottomCons         : NSLayoutConstraint!
    @IBOutlet public weak var _submitButton                 : UIButton!
    @IBOutlet public weak var _scrollViewBottomMargin       : NSLayoutConstraint!
    
    override var scrollViewContentHeightWithouDynemicGap    : CGFloat { get { return 660 } set {} }
    
    deinit { print("deinit BlogCreateEditVC") }
    
    override func customiseView() {
        initialise(scrollView: _scrollView, dynemicGapCons: _dynemicGapCons, scrollViewTopCons: _scrollViewTopCons, scrollViewBottomCons: _scrollViewBottomCons, submitButton: _submitButton, scrollViewBottomMargin: _scrollViewBottomMargin)
        super.customiseView()
        self.addBackButton(title: self.previousVCTitle ?? "Home")
        self.title                                          = "Create Blog"
        
        _scrollView.addBoarder(width: 0.5, cornerRadius: 8, color: .lightGray)
        userImageVw.layer.cornerRadius                      = userImageVw.frame.height / 2
        userImageVw.setImageWith(imagePath: User.si.imageUrl ?? "", completion: nil)
        
        titleTxtFld.fieldName                               = "Caption"
        titleTxtFld.validation                              = FormValidation.required
        
        postItemsContainer.addBoarder(width: 1, cornerRadius: 5, color: .lightGray)
        
        if let imageGridViewModel = viewModel?.contentGridViewModel {
            self.contentGrid                                = BlogCreateContentGrid(viewModel: imageGridViewModel, collectionView: _contentCV, delegate: self)
            contentGrid?.setupBindings()
        }
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.updateWithLocation.subscribe(onNext: { [weak self] (locationDetail) in
                    self?.usernameLbl.attributedText   = locationDetail.usernameString
                    self?.addLocationBtn.setImage(UIImage(named: locationDetail.isActiveLocationBtn ? "icon_location_active" : "icon_location"), for: .normal)
                }),
                viewModel.blog._title.bind(to: titleTxtFld.rx.text.orEmpty),
                viewModel.blog._desc.bind(to: descTxtVw.rx.text.orEmpty),
                viewModel.showImagePicker.subscribe(onNext: { [weak self] (_) in
                    var configure                       = TLPhotosPickerConfigure()
                    configure.maxSelectedAssets         = 10
                    let viewController                  = TLPhotosPickerViewController(withTLPHAssets: { [weak self] (assets) in self?.viewModel?.contentSelected(content: assets) }, didCancel: nil)
                    viewController.configure            = configure
                    self?.present(viewController, animated: true, completion: nil)
                }),
                viewModel.showLocationPicker.subscribe(onNext: { [weak self] (_) in
                    self?.showLocationPicker()
                }),
                viewModel.enableImagePicker.subscribe(onNext: { [weak self] (enable) in
                    self?.addPhotoBtn.isEnabled         = enable
                }),
                
                // MARK: - Outputs
                titleTxtFld.rx.text.orEmpty.bind(to: viewModel.blog._title),
                descTxtVw.rx.text.orEmpty.bind(to: viewModel.blog._desc),
                addPhotoBtn.rx.tap.bind(to: viewModel.addPhotosTapped),
                addLocationBtn.rx.tap.bind(to: viewModel.addLocationTapped)
            ])
            
            viewModel.contentGridViewModel?.doWithSelectedItem.subscribe(onNext: { [weak self] (blogContent) in
                if let asset = blogContent.asset, let phasset = asset.phAsset {
                    let previewVC   = TLAssetPreviewViewController()
                    previewVC.asset = phasset
                    self?.present(previewVC, animated: true, completion: nil)
                } else if let mediaUrl = blogContent.mediaUrl {
                    self?.displayMediaFrom(url: mediaUrl)
                }
            }).disposed(by: disposeBag)
        }
        descTxtVw.updatePlaceHolderLabel()
    }
    
    func showLocationPicker() {
        let alertController         = UIAlertController(title: "Enter Location", message: "TODO: Add proper location picker", preferredStyle: .alert)
        let action                  = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: {[weak self] (action) in
            if let textFields = alertController.textFields{
                let theTextFields   = textFields as [UITextField]
                let enteredText     = theTextFields[0].text
                self?.viewModel?.locationSelected(location: enteredText)
            }
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField!) in textField.placeholder = "Current location" })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension BlogCreateEditVC: BaseGridDelagate {
    func getNoItemsText(_ collectionView: UICollectionView) -> String {
        return "No content added"
    }
}
