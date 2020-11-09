//
//  BlogDetailTV.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 11/9/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import Foundation
import Agrume

class BlogDetailTV: AdvancedBaseList<BlogDetailTVCellType, BlogDetailTableViewSection, BlogDetailTVVM> {
    deinit { print("deinit BlogDetailTV") }
    
    override var cellLoadFromNib: Bool { get { return true } set {} }
}

extension BlogDetailTV: BlogTVCellDelegate {
    
    func likeError(restError: RestClientError) {
        viewModel?.handleRestClientError(error: restError)
    }
    
    func shareTappedFor(blog: Blog) {
        print("shareTappedFor")
//        viewModel?.shareBlogHasTapped.onNext(blog)
    }
    
    func commentTappedFor(blog: Blog) {
//        viewModel?.commentBtnHasTapped.onNext(blog)
    }
    
    func tappedOnContentWith(url: String) {
//        let agrume = Agrume(url: URL(string: url)!)
//        agrume.download = { url, completion in
//            let httpService = HTTPService()
//            httpService.downloadImage(imagePath: url.absoluteString) { (image) in
//                guard let image = image else { return }
//                completion(image)
//            }
//        }
//        agrume.show(from: self)
    }
}
