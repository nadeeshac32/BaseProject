//
//  SceneDelegate.swift
//  BaseProject
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import FBSDKCoreKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()
    let manager                                 = NetworkReachabilityManager(host: "www.apple.com")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene                   = (scene as? UIWindowScene) else { return }
        self.window                             = UIWindow(windowScene: windowScene)
        
        // keep the spash screen for bit more
        let storyboard                          = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let splashScreen                        = storyboard.instantiateViewController(withIdentifier: "LaunchScreen")
        window?.rootViewController              = splashScreen
        window?.makeKeyAndVisible()
        sleep(UInt32(AppConfig.si.splashScreenDuration))
        
        //  Network listner. This doen't do any network call canceling or restarting. But just showing a dialog saying Can't connect at the moment.
        manager?.startListening { status in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
                self.showAlert(title: "Can't connect at the moment".localized(), message: "Check your network connection.".localized(), alertAction: nil)
            } else {
                if let window = self.window {
                    if var topController = window.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        topController.dismiss(animated: true, completion: nil)
                   }
                }
            }
        }
        
        appCoordinator  = AppCoordinator(window: self.window!)
        appCoordinator.start().subscribe().disposed(by: disposeBag)
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    // MARK: - Show Alert
    
    /// Show configured alert
    ///
    /// - Parameters:
    ///   - title:    `title` of the alert view
    ///   - message:  `message` that should be displayed to the user
    ///   - alertAction:  Custom `action`
    func showAlert(title: String! = nil, message: String! = nil, alertAction: UIAlertAction! = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if alertAction != nil {
            ac.addAction(alertAction)
        } else {
            ac.addAction(UIAlertAction(title: "Ok".localized(), style: .cancel, handler: nil))
        }
        
        if var topController = self.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(ac, animated: true, completion: nil)
        }
    }

}
