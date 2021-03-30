//
//  NCDocumentPicker.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/11/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import MobileCoreServices

public enum SourceType: Int {
    case files
    case folder
}

public enum ResultType: Int {
    case documents
    case urls
}

/// Document picker to open file browser.
class NCDocumentPicker: NSObject {
    private var pickerController            : UIDocumentPickerViewController?
    private weak var presentationController : UIViewController?
    
    /// Specifying whether to pick forlder or files
    private var sourceType                  : SourceType!
    private var documents                   = [NCDocument]()
    private var urls                        = [URL]()
    
    private var didPickDocuments            : ((_ documents: [NCDocument]) -> Void)?
    private var didPickDocument             : ((_ document: NCDocument) -> Void)?
    private var didPickURLs                 : ((_ documentUrls: [URL]) -> Void)?
    private var didPickURL                  : ((_ documentUrl: URL) -> Void)?
    private var didCancel                   : (() -> Void)?
    
    /// Enable multi selection
    private var multiSelection              : Bool?
    private var resultType                  : ResultType = .documents
    
    /// Retrieving file types
    private var retrievingFormats           : [String]?
    
    
    /// Initialiser
    /// - Parameters:
    ///   - presentationController: ViewController that is showing picker
    ///   - multiSelection: Whether multi selection is enabled or not
    ///   - documentTypes: Retrieving file types
    init(presentationController: UIViewController, multiSelection: Bool?, documentTypes: [String]?) {
        self.presentationController         = presentationController
        self.multiSelection                 = multiSelection
        self.retrievingFormats              = documentTypes
        super.init()
    }
    
    
    /// Present to pick documents
    /// - Parameters:
    ///   - sourceView: Anchor view of picker
    ///   - didPickDocuments: Call back with multiple documents
    ///   - didPickDocument: Call back with single document
    ///   - didCancel: Call back when picker canceled.
    func presentToPickDocuments(from sourceView: UIView,
                 didPickDocuments: ((_ documents: [NCDocument]) -> Void)? = nil,
                 didPickDocument: ((_ document: NCDocument) -> Void)? = nil,
                 didCancel: (() -> Void)? = nil) {
        
        self.resultType                     = .documents
        self.didPickDocuments               = didPickDocuments
        self.didPickDocument                = didPickDocument
        self.didCancel                      = didCancel
        
        let alertController                 = UIAlertController(title: "Select From".localized(), message: nil, preferredStyle: .actionSheet)
        
        let actionForFilePicker = UIAlertAction(title: "Files".localized(), style: .default) { [unowned self] _ in
            self.pickerController           = UIDocumentPickerViewController(documentTypes: self.retrievingFormats ?? [kUTTypeMovie as String, kUTTypeImage as String, kUTTypePDF as String] , in: .open)
            self.pickerController!.delegate                                         = self
            self.pickerController!.allowsMultipleSelection                          = self.multiSelection ?? true
            self.sourceType                                                         = .files
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        alertController.addAction(actionForFilePicker)
        
        
        let actionForFolderPicker = UIAlertAction(title: "Folder".localized(), style: .default) { [unowned self] _ in
            self.pickerController           = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
            self.pickerController!.delegate = self
            self.sourceType                 = .folder
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        alertController.addAction(actionForFolderPicker)
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView               = sourceView
            alertController.popoverPresentationController?.sourceRect               = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    func presentToPickFolder(from sourceView: UIView,
                 didPickURLs: ((_ documentUrls: [URL]) -> Void)? = nil,
                 didPickURL: ((_ documentUrl: URL) -> Void)? = nil,
                 didCancel: (() -> Void)? = nil) {
        
        self.resultType                     = .urls
        self.didPickURLs                    = didPickURLs
        self.didPickURL                     = didPickURL
        self.didCancel                      = didCancel
        
        self.pickerController               = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
        self.pickerController!.delegate     = self
        self.sourceType                     = .folder
        self.presentationController?.present(self.pickerController!, animated: true)
    }
    
    func presentToPickFiles(from sourceView: UIView, subfolder: URL?,
                 didPickURLs: ((_ documentUrls: [URL]) -> Void)? = nil,
                 didPickURL: ((_ documentUrl: URL) -> Void)? = nil,
                 didCancel: (() -> Void)? = nil) {
        
        self.resultType                     = .urls
        self.didPickURLs                    = didPickURLs
        self.didPickURL                     = didPickURL
        self.didCancel                      = didCancel
        
        self.pickerController               = UIDocumentPickerViewController(documentTypes: self.retrievingFormats ?? [kUTTypeContent as String, kUTTypePDF as String] , in: .open)
        self.pickerController!.delegate                                         = self
        if #available(iOS 13.0, *), let subfolder = subfolder {
            self.pickerController?.directoryURL                                 = subfolder
        }
        
        self.pickerController!.allowsMultipleSelection                          = self.multiSelection ?? true
        self.sourceType                                                         = .files
        self.presentationController?.present(self.pickerController!, animated: true)
    }
    
}

extension NCDocumentPicker: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        documentFromURL(pickedURLs: urls)
        
        if self.resultType == .documents {
            if documents.count > 0, let document = documents.first {
                didPickDocuments?(documents)
                didPickDocument?(document)
            } else {
                didCancel?()
            }
        } else if self.resultType == .urls {
            if self.urls.count > 0, let url = self.urls.first {
                didPickURLs?(urls)
                didPickURL?(url)
            } else {
                didCancel?()
            }
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        didCancel?()
    }
    
    private func documentFromURL(pickedURLs: [URL]) {
        if let pickedURL                        = pickedURLs.first {
            let shouldStopAccessing             = pickedURL.startAccessingSecurityScopedResource()
            
            defer {
                if shouldStopAccessing {
                    pickedURL.stopAccessingSecurityScopedResource()
                }
            }
            
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                let keys: [URLResourceKey]      = [.nameKey, .isDirectoryKey]
                let fileList                    = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                
                switch sourceType {
                case .files:
                    for fileUrl in pickedURLs {
                        let document            = NCDocument(fileURL: fileUrl)
                        documents.append(document)
                        urls.append(fileUrl)
                    }
                
                case .folder:
                    for case let fileURL as URL in fileList! {
                        if !fileURL.isDirectory {
                            let document        = NCDocument(fileURL: fileURL)
                            documents.append(document)
                            urls.append(fileURL)
                        }
                    }
                case .none:
                    break
                }
            }
        }
    }
    
}

extension NCDocumentPicker: UINavigationControllerDelegate {}

