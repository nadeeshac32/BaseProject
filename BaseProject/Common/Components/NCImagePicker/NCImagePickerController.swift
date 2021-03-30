//
//  NCImagePickerController.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit

protocol NCImagePickerControllerDelegate: class {
    func imagePickerControllerDidFinish(image: UIImage?, _: NCImagePickerController)
}

final class NCImagePickerController: UIImagePickerController {
    weak var imagePickerDelegate: NCImagePickerControllerDelegate?
    
    deinit {
        print("deinit NCImagePickerController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

/// Used in NCImagePickerPresenting
// MARK: - UIImagePickerControllerDelegate
extension NCImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ pickder: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePickerDelegate?.imagePickerControllerDidFinish(image: pickedImage, self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerDelegate?.imagePickerControllerDidFinish(image: nil, self)
    }
}

