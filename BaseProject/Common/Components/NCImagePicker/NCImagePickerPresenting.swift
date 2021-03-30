//
//  NCImagePickerPresenting.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit

private var completionBlock: ((UIImage?) -> Void)?

protocol NCImagePickerPresenting: NCImagePickerControllerDelegate {
    func presentImagePicker(completion: @escaping (UIImage?) -> Void)
}

/// Image picker to open image browsing.
extension NCImagePickerPresenting where Self: UIViewController {
    
    func presentImagePicker(completion: @escaping (UIImage?) -> Void) {
        completionBlock                                         = completion
        let imagePickerViewController                           = NCImagePickerController()
        imagePickerViewController.imagePickerDelegate           = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerViewController.sourceType                = .camera
            imagePickerViewController.cameraDevice              = .rear
            imagePickerViewController.cameraCaptureMode         = .photo
            imagePickerViewController.showsCameraControls       = true
            
            let actionSheet                                     = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Take Photo".localized(), style: .default) { [weak self] (action) in
                imagePickerViewController.sourceType            = .camera
                self?.accessCameraWithReminderPrompt(completion: { [weak self] (accessGranted) in
                    DispatchQueue.main.async(execute: { [weak self] in
                        self?.present(imagePickerViewController, animated: true, completion: nil)
                    })
                })
                
            }
            let gallery = UIAlertAction(title: "Choose Photo".localized(), style: .default) { [weak self] (action) in
                imagePickerViewController.sourceType            = .photoLibrary
                self?.remindToGiveGalleryWithReminderPrompt(completion: { [weak self] (accessGranted) in
                    DispatchQueue.main.async(execute: { [weak self] in
                        self?.present(imagePickerViewController, animated: true, completion: nil)
                    })
                })
            }
            
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (action) in
                completionBlock                                 = nil
            }
            
            actionSheet.addAction(camera)
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            imagePickerViewController.sourceType                = .photoLibrary
            imagePickerViewController.imagePickerDelegate       = self
            imagePickerViewController.isNavigationBarHidden     = false
            imagePickerViewController.isToolbarHidden           = true
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidFinish(image: UIImage?, _ viewController: NCImagePickerController) {
        completionBlock?(image) //?.resizeImage(sizeOfImageNeeded_inMb: AppConfig.si.selectImageMaxSizeLimit))
        completionBlock                                         = nil
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func accessCameraWithReminderPrompt(completion:@escaping (_ accessGranted: Bool)->()) {
        let accessRight                                         = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch accessRight {
        case .authorized:
            completion(true)
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                if granted == true  {
                    completion(true)
                    return
                }
                self?.alertCameraAccessNeeded()
            })
            
        case .denied, .restricted:
            self.alertCameraAccessNeeded()
            break
            
        default:
            break
        }
    }
    
    func remindToGiveGalleryWithReminderPrompt(completion:@escaping (_ accessGranted: Bool)->()) {
        let accessRight                                         = PHPhotoLibrary.authorizationStatus()
        
        switch accessRight {
        case .authorized:
            completion(true)
            break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                if status == .authorized {
                    completion(true)
                    return
                }
                self?.alertPhotosAccessNeeded()
            }
            
        case .denied, .restricted:
            alertPhotosAccessNeeded()
            break
            
        default:
            break
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL                                      = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "TCO_camera_access",
            message: "TCO_camera_access_message",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "TCO_camera_access", style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsAppURL)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertPhotosAccessNeeded() {
        let settingsAppURL                                      = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "TCO_photos_access",
            message: "TCO_photos_access_message",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "TCO_photos_access", style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsAppURL)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
