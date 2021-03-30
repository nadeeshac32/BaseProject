//
//  OnboardingImage_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class OnboardingImageVC: UIViewController, StoryboardInitializable {

    @IBOutlet weak var imageVw      : UIImageView!
    @IBOutlet weak var descLbl      : UILabel!
    
    private var imageName           : String?
    private var desc                : NSMutableAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = self.imageName {
            imageVw.image           = UIImage(named: imageName)
        }
        
        if let desc = self.desc {
            descLbl.attributedText  = desc
        }
    }
    
    func setImage(withName: String, attributedString: NSMutableAttributedString) {
        self.imageName              = withName
        self.desc                   = attributedString
    }

}
