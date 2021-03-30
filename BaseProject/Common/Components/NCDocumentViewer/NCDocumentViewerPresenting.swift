//
//  NCDocumentViewerPresenting.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit

struct AssociatedKeys {
    static var documentInteractionController: UIDocumentInteractionController?
}

protocol NCDocumentViewerPresenting: UIDocumentInteractionControllerDelegate {
    var documentInteractionController: UIDocumentInteractionController? { get set }
    
    func previewDocument(url: URL)
    func openDocument(anchor: UIView, url: URL)
    func openDocumentOption(anchor: UIView, url: URL)
    
    // Since this method is a objc functions from the delegate we cannot give a default implementation. And we have implement this in the actual concrete viewcontroller. In that method implementation we just have to 'return self' as the return value
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
}

/// Implementation of  `NCDocumentViewerPresenting`. Enables ViewControllers to display documents.
extension NCDocumentViewerPresenting where Self: UIViewController {

    var documentInteractionController: UIDocumentInteractionController? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.documentInteractionController) as? UIDocumentInteractionController else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.documentInteractionController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func previewDocument(url: URL) {
        self.documentInteractionController                      = UIDocumentInteractionController(url: url)
        self.documentInteractionController?.delegate            = self
        self.documentInteractionController?.presentPreview(animated: true)
    }
    
    func openDocument(anchor: UIView, url: URL) {
        self.documentInteractionController                      = UIDocumentInteractionController(url: url)
        self.documentInteractionController?.delegate            = self
        self.documentInteractionController?.presentOpenInMenu(from: anchor.frame, in: self.view, animated: true)
    }
    
    func openDocumentOption(anchor: UIView, url: URL) {
        self.documentInteractionController                      = UIDocumentInteractionController(url: url)
        self.documentInteractionController?.delegate            = self
        self.documentInteractionController?.presentOptionsMenu(from: anchor.frame, in: self.view, animated: true)
    }
}
