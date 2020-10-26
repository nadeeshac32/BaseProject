//
//  FileAPIProtocol.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Alamofire

enum DocumentDirectorySubFolder: String {
    case SubfolderPDFFolder     = "Subfolder/PDF Files"
    case SubfolderCSVFolder     = "Subfolder/CSV Files"
    case Subfolder              = "Subfolder"
}

enum FileFormat: String {
    case PDF = ".pdf"
    case CSV = ".csv"
}

// Confiming to this protocol enables you to upload and download files
protocol FileAPIProtocol {
    
    func uploadImageRequest(image: UIImage,
                            imageName: String,
                            onError: ErrorCallback?,
                            completionHandler: ((ImagePostData) -> Void)?)
    
    func downloadImage(imagePath: String, completion: ((UIImage?) -> Void)?)
    
    func downloadFile(fileName: String,
                      subFolder: DocumentDirectorySubFolder?,
                      removeAllExisting: Bool,
                      displayFileName: String,
                      fileFormat: FileFormat,
                      onError: ErrorCallback?,
                      completionHandler: ((URL) -> Void)?)
    
}
