//
//  PushNotificationManager.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 3/29/21.
//  Copyright © 2021 Nadeesha Lakmal. All rights reserved.
//

//import Firebase
//import FirebaseMessaging
//import UIKit
//import UserNotifications
//
//class PushNotificationManager: NSObject {
//
//    static let si = PushNotificationManager(userID: "currently_logged_in_user_id")
//
//    let userID: String
////    let authOptions: UNAuthorizationOptions                              = [.alert, .badge, .sound]
////    let authPresentationOptions: UNNotificationPresentationOptions       = [.alert, .badge, .sound]
//    let authOptions: UNAuthorizationOptions                                = [.alert, .sound]
//    let authPresentationOptions: UNNotificationPresentationOptions         = [.alert, .sound]
//
//
//    private init(userID: String) {
//        self.userID = userID
//        super.init()
//
//        // This needs to configure Google analytics too
//        FirebaseApp.configure()
//    }
//
//    func registerForPushNotifications() {
//        Messaging.messaging().delegate                                      = self
//        UNUserNotificationCenter.current().delegate                         = self
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in
//
//            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//                guard settings.authorizationStatus == .authorized else {
//                    // TODO: To know about our updates, enable Push notifications, Don't show again
//                    print("TODO: To know about our updates, enable Push notifications, Don't show again")
//                    return
//                }
//            }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        })
//    }
//
//    func updateFirestorePushTokenIfNeeded() {
//        if let token = Messaging.messaging().fcmToken {
//            print("fcmToken: \(token)")
////            let usersRef = Firestore.firestore().collection("users_table").document(userID)
////            usersRef.setData(["fcmToken": token], merge: true)
//        }
//    }
//
//}
//
//
//extension PushNotificationManager: UNUserNotificationCenterDelegate {
//
//    /// Handle Notification when app is in foreground. Received the notification before displaying
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        print("***** WillPresent notification withCompletionHandler *****")
//        print("***** Handle Notification when app is in foreground. Received the notification before displaying *****")
//        print("***** Userinfo: \(userInfo) *****")
//
//        // To continue displaying as notification
//        completionHandler(authPresentationOptions)
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotificationKeys.UpdateNotificationsPage.rawValue), object: nil)
//    }
//
//    // MARK: Handle Notification when app is in background, This method will trigger after the user taps on the notification and opens the app.
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//        print("***** DidReceive response withCompletionHandler *****")
//        print("***** Handle Notification when app is in background. For iOS 10+ *****")
//        print("***** DidReceive response category: '\(response.notification.request.content.categoryIdentifier)' *****")
//        print("***** And The user select the action: \(response.actionIdentifier) *****")
//        print("***** Userinfo: \(userInfo) *****")
//
//        completionHandler()
//    }
//
//}
//
//
//extension PushNotificationManager : MessagingDelegate {
//    /// This callback is fired at each app startup and whenever a new token is generated.
//    /// If necessary send token to application server.
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//      updateFirestorePushTokenIfNeeded()
//    }
//}
//
//
//enum LocalNotificationKeys: String {
//    case UpdateNotificationCountLabel
//    case UpdateNotificationsPage
//}
