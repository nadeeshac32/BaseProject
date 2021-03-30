//
//  OTPVerification_VM.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import RxSwift

enum OTPVerificationType {
    case SignUp
    case UpdateEmail
    case UpdateMobile
    case ResetPasswordViaMobile
    case ResetPasswordViaEmail
}

class OTPVerificationVM: BaseFormVM {
    
    let otpVerificationType                 : OTPVerificationType
    let userPostData                        : UserPostData?
    let user                                : User?
    let seconds                             = 60
    var secondsLeft                         = 60
    var timer                               = Timer()
    var isTimerRunning                      = BehaviorSubject<Bool>(value: false)

    // MARK: Inputs
    weak var showRootVC                     : PublishSubject<Bool>?
    let otp                                 = BehaviorSubject<String>(value: "")
    let openMailAppTapped                   : AnyObserver<Void>
    
    // MARK: Outputs
    let updateVerificationCodeText          : PublishSubject<NSAttributedString>    = PublishSubject()
    let updateCountDownText                 : PublishSubject<String>                = PublishSubject()
    let clearOTP                            : PublishSubject<Bool>                  = PublishSubject()
    var showResetPasswordVC                 : PublishSubject<Bool>                  = PublishSubject()
    var isResendEnabled                     : Observable<Bool>
    let openMailApp                         : Observable<Void>
    
    deinit {
        print("deinit OTPVerificationVM")
    }
    
    init(showRootVC: PublishSubject<Bool>, userPostData: UserPostData) {
        self.otpVerificationType            = .SignUp
        self.showRootVC                     = showRootVC
        self.userPostData                   = userPostData
        self.isResendEnabled                = isTimerRunning.map({ (running) -> Bool in return !running })
        self.user                           = nil
        
        let _openMailAppTapped              = PublishSubject<Void>()
        self.openMailAppTapped              = _openMailAppTapped.asObserver()
        self.openMailApp                    = _openMailAppTapped.asObservable()
        
        super.init()
    }
    
    init(user: User, otpVerificationType: OTPVerificationType) {
        self.otpVerificationType            = otpVerificationType
        self.user                           = user
        self.isResendEnabled                = isTimerRunning.map({ (running) -> Bool in return !running })
        self.showRootVC                     = nil
        self.userPostData                   = nil
        
        let _openMailAppTapped              = PublishSubject<Void>()
        self.openMailAppTapped              = _openMailAppTapped.asObserver()
        self.openMailApp                    = _openMailAppTapped.asObservable()
        
        super.init()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated: animated)
        let attributedString                : NSMutableAttributedString!
        if otpVerificationType == .UpdateMobile || otpVerificationType == .ResetPasswordViaMobile || otpVerificationType == .SignUp {
            let mobileNumberString          : String
            if userPostData != nil {
                mobileNumberString          = "\(userPostData?.mobileNo?.countryCode ?? "")\(userPostData?.mobileNo?.localNumber ?? "")"
            } else {
                if let mobileObject = self.getUserMobileNumber() {
                    mobileNumberString      = "\(mobileObject.countryCode ?? "")\(mobileObject.localNumber ?? "")"
                } else {
                    mobileNumberString      = "Your Mobile".localized()
                }
            }
            
            let text                        = "A verification code is sent to %@".localizeWithFormat(arguments: mobileNumberString)
            attributedString                = NSMutableAttributedString(string: text,
                                                                        attributes: [.font: UIFont.systemFont(ofSize: 21.0, weight: .regular),
                                                                                     .foregroundColor: UIColor(white: 56.0 / 255.0, alpha: 1.0)])
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 21.0, weight: .semibold), range: NSRange(location: text.count - mobileNumberString.count, length: mobileNumberString.count))
            
        } else {
            let emailString                 : String
            do {
                emailString                 = try user?._email.value() ?? "Your Email Address".localized()
            } catch let error {
                print("email retrieve error: \(error)")
                emailString                 = "Your Email Address".localized()
            }
            
            let text                        = "A verification code is sent to %@".localizeWithFormat(arguments: emailString)
            attributedString                = NSMutableAttributedString(string: text,
                                                                        attributes: [.font: UIFont.systemFont(ofSize: 21.0, weight: .regular),
                                                                                     .foregroundColor: UIColor(white: 56.0 / 255.0, alpha: 1.0)])
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 21.0, weight: .semibold), range: NSRange(location: text.count - emailString.count, length: emailString.count))
        }
        updateVerificationCodeText.onNext(attributedString)
        startTimer()
    }
    
    override func initialiseFormErrors() {
        self.isValid                        = otp.map({ (otp) -> Bool in
            return otp.count == 6
        })
    }
    
    override func backButtonTapped() {
        let alert = (title: "Go Back".localized(), message: "Are you sure?".localized(),
        primaryBtnTitle: "Yes".localized(), primaryActionColor: AppConfig.si.colorPrimary, primaryAction: { [weak self] in
            self?.user?.resetData()
            self?.goToPreviousVC.onNext(true)
            return
        },
        secondaryBtnTitle: "No".localized(), secondaryActionColor: nil, secondaryAction: nil) as alertType
        showAlert.on(.next(alert))
    }
    
    override func performSubmitRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !freezeForRequestLoading.value() else { return }

            // Bypassing OTP verification network request
            print("Bypassing OTP verification network request")
            let httpService                 = HTTPService()
            freezeForRequestLoading.onNext(true)
            self.handleOTPVerificationSuccess(httpService: httpService)
            
//            let otp                         = try self.otp.value()
//            let httpService                 = HTTPService()
//            freezeForRequestLoading.onNext(true)
            
//            if otpVerificationType == .SignUp || otpVerificationType == .UpdateMobile || otpVerificationType == .ResetPasswordViaMobile {
//                httpService.verifyOTP(otp: otp, mobile: userPostData?.mobileNo ?? self.getUserMobileNumber(), onSuccess: { [weak self] in
//                    self?.handleOTPVerificationSuccess(httpService: httpService)
//                }) { [weak self] (error) in
//                    self?.handleRestClientError(error: error)
//                }
//            } else {
//                let emailString: String
//                do {
//                    emailString = try user?._email.value() ?? ""
//                } catch let error {
//                    print("Fetal error: \(error)")
//                    emailString = ""
//                }
//
//                httpService.verifyOTP(otp: otp, email: emailString, onSuccess: { [weak self] in
//                    self?.handleOTPVerificationSuccess(httpService: httpService)
//                }) { [weak self] (error) in
//                    self?.handleRestClientError(error: error)
//                }
//            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
    // MARK: - Class methods
    private func getUserMobileNumber() -> MobileNumber? {
        return user?.mobileNo?.hasEdited() == true ? user?.mobileNo?.copy() as? MobileNumber : user?.mobileNo
    }
    
    private func startTimer() {
        do {
            let isTimerRunning              = try self.isTimerRunning.value()
            if !isTimerRunning {
                secondsLeft                 = seconds
                runTimer()
                self.isTimerRunning.onNext(true)
            }
        } catch {
            print("Fetal Error: \(error)")
        }
    }
    
    private func runTimer() {
        let defaults                            = UserDefaults.standard
        defaults.set(Date().millisecondsSince1970, forKey: "lastOTPSentTime")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        let defaults                        = UserDefaults.standard
        let lastOTPSentTime                 = defaults.integer(forKey: "lastOTPSentTime")
        let currentTime                     = Date().millisecondsSince1970
        let duration                        = (currentTime - lastOTPSentTime) / 1000

        secondsLeft                         = 60 - duration
        if secondsLeft < 0 {
            secondsLeft                     = 0
        }
        
        updateCountDownText.onNext("It will expire in %@ second(s)".localizeWithFormat(arguments: "\(secondsLeft)"))
        if secondsLeft <= 0 {
            timer.invalidate()
            secondsLeft                     = seconds
            isTimerRunning.onNext(false)
            updateCountDownText.onNext("Verification code has expired.".localized())
            defaults.set(0, forKey: "lastOTPSentTime")
        }
    }
    
    func handleOTPVerificationSuccess(httpService: HTTPService) {
        switch self.otpVerificationType {
        case .SignUp:
            self.performSignUpUserRequest(httpService: httpService)
            break
        case .UpdateEmail:
            self.performUpdateUserEmailRequest(httpService: httpService)
            break
        case .UpdateMobile:
            self.performUpdateUserMobileRequest(httpService: httpService)
            break
        case .ResetPasswordViaEmail, .ResetPasswordViaMobile:
            self.freezeForRequestLoading.onNext(false)
            self.showResetPasswordVC.onNext(true)
            break
        }
    }
    
    // MARK: - Network request
    func performResendRequest() {
        hideKeyBoard.onNext(true)
        do {
            guard try !requestLoading.value() else { return }
            
            // Bypassing OTP Generate network request
            print("Bypassing Resend OTP network request")
            self.clearOTP.onNext(true)
            self.startTimer()
            
//            let httpService                 = HTTPService()
//            requestLoading.onNext(true)
//            if otpVerificationType == .UpdateMobile || otpVerificationType == .ResetPasswordViaMobile || otpVerificationType == .SignUp {
//                let mobileObject            = userPostData?.mobileNo ?? self.getUserMobileNumber()
//                httpService.generateOTP(mobile: mobileObject, onSuccess: { [weak self] in
//                    self?.requestLoading.onNext(false)
//                    self?.clearOTP.onNext(true)
//                    self?.startTimer()
//                }) { [weak self] (error) in
//                    self?.handleRestClientError(error: error)
//                }
//            } else {
//                let email                   : String
//                do {
//                    email                   = try user?._email.value() ?? ""
//                } catch let error {
//                    print("user?._email.value() error: \(error)")
//                    email                   = ""
//                }
//                httpService.generateOTP(email: email, onSuccess: { [weak self] in
//                    self?.requestLoading.onNext(false)
//                    self?.clearOTP.onNext(true)
//                    self?.startTimer()
//                }) { [weak self] (error) in
//                    self?.handleRestClientError(error: error)
//                }
//            }
        } catch let error {
            print("Fetal error: \(error)")
        }
    }
    
    func performSignUpUserRequest(httpService: HTTPService) {
//        httpService.signup(fullname: userPostData?.fullName, email: nil, password: userPostData?.password, mobileNo: userPostData?.mobileNo, onSuccess: { [weak self] (user) in
        
        httpService.signup(userPostData: userPostData, onSuccess: { [weak self] (user) in
            self?.freezeForRequestLoading.onNext(false)
            let tupple = (message: "Registered successfully".localized(), blockScreen: true, completionHandler: {  [weak self] in
                self?.showRootVC?.onNext(true)
            })
            self?.successMessage.onNext(tupple)
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }
    
    func performUpdateUserEmailRequest(httpService: HTTPService) {
        let emailString: String
        do {
            emailString = try user?._email.value() ?? ""
        } catch let error {
            print("Fetal error: \(error)")
            emailString = ""
        }
        httpService.updateEmail(email: emailString, onSuccess: { [weak self] (user) in
            self?.freezeForRequestLoading.onNext(false)
            let tupple = (message: "Email changed successfully".localized(), blockScreen: true, completionHandler: { [weak self] in
                self?.logoutUserWithoutPermission()
            })
            self?.successMessage.onNext(tupple)
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }
    
    func performUpdateUserMobileRequest(httpService: HTTPService) {
        if let mobileNumber = self.getUserMobileNumber() {
            httpService.updateMobile(mobileNo: mobileNumber, onSuccess: { [weak self] (user) in
                self?.freezeForRequestLoading.onNext(false)
                let tupple = (message: "Mobile No changed successfully".localized(), blockScreen: true, completionHandler: { [weak self] in
                    self?.logoutUserWithoutPermission()
                })
                self?.successMessage.onNext(tupple)
            }) { [weak self] (error) in
                self?.handleRestClientError(error: error)
            }
        } else {
            self.freezeForRequestLoading.onNext(false)
        }
    }
}

