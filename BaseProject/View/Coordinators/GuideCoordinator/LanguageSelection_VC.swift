//
//  LanguageSelection_VC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Swivel Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageSelectionVC: BaseVC<LanguageSelectionVM> {
    
    @IBOutlet weak var englishContainerVw                   : UIView!
    @IBOutlet weak var englishLbl                           : UILabel!
    @IBOutlet weak var bahasaContainerVw                    : UIView!
    @IBOutlet weak var bahasaLbl                            : UILabel!
    @IBOutlet weak var continueBtn                          : UIButton!

    let englishTapGesture                                   = UITapGestureRecognizer()
    let bahasaTapGesture                                    = UITapGestureRecognizer()
    
    deinit {
        print("deinit LanguageSelectionVC")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func customiseView() {
        super.customiseView()
        self.navigationController?.isNavigationBarHidden    = true
        
        englishContainerVw.addGestureRecognizer(englishTapGesture)
        bahasaContainerVw.addGestureRecognizer(bahasaTapGesture)
        
        continueBtn.addBoarder(width: 1, cornerRadius: 3, color: AppConfig.si.colorPrimary)
        continueBtn.backgroundColor                         = AppConfig.si.colorPrimary
        continueBtn.setTitleColor(.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden    = true
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: - Outputs
                englishTapGesture.rx.event.bind(onNext: { (_) in
                    viewModel.selectEnglish()
                }),
                bahasaTapGesture.rx.event.bind(onNext: { (_) in
                    viewModel.selectBhasha()
                }),
                continueBtn.rx.tap
                    .bind(to: viewModel.continueTapped),
                
                // MARK: - inputs
                viewModel.toggleToEnglish.subscribe(onNext: { [weak self] (_) in
                    self?.englishContainerVw.backgroundColor    = #colorLiteral(red: 0.3019607843, green: 0.2509803922, blue: 0.5176470588, alpha: 0.15)
                    self?.englishLbl.textColor                  = AppConfig.si.colorPrimary
                    
                    self?.bahasaContainerVw.backgroundColor     = .white
                    self?.bahasaLbl.textColor                   = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
                }),
                viewModel.toggleToBahasa.subscribe(onNext: { [weak self] (_) in
                    self?.bahasaContainerVw.backgroundColor     = #colorLiteral(red: 0.3019607843, green: 0.2509803922, blue: 0.5176470588, alpha: 0.15)
                    self?.bahasaLbl.textColor                   = AppConfig.si.colorPrimary
                    
                    self?.englishContainerVw.backgroundColor    = .white
                    self?.englishLbl.textColor                  = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
                })
            ])
        }
    }
}

