//
//  SwivelImagePickerController.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import UIKit

protocol SwivelImagePickerControllerDelegate: class {
    func imagePickerControllerDidFinish(image: UIImage?, _: SwivelImagePickerController)
}

final class SwivelImagePickerController: UIImagePickerController {
    weak var imagePickerDelegate: SwivelImagePickerControllerDelegate?
    
    deinit {
        print("deinit SwivelImagePickerController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

/// Used in SwivelImagePickerPresenting
// MARK: - UIImagePickerControllerDelegate
extension SwivelImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ pickder: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePickerDelegate?.imagePickerControllerDidFinish(image: pickedImage, self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerDelegate?.imagePickerControllerDidFinish(image: nil, self)
    }
}

