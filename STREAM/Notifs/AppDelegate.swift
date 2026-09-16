//
//  AppDelegate.swift  .swift
//  PushNotificationDemo
//
//  Created by Dan on 9/9/26.
//

import Foundation
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // Receive notifications while app is running
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // MARK: - APNs Registration Success

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {

        let token = deviceToken
            .map {
                String(format: "%02.2hhx", $0)
            }
            .joined()

        print("========================================")
        print("✅ APNs DEVICE TOKEN")
        print(token)
        print("========================================")

        PushNotificationManager.shared
            .registerDeviceToken(token)
    }

    // MARK: - APNs Registration Failed

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {

        print("========================================")
        print("❌ APNs REGISTRATION FAILED")
        print(error.localizedDescription)
        print("========================================")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Notification received while app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        completionHandler([
            .banner,
            .sound,
            .badge
        ])
    }

    // User tapped the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:
        @escaping () -> Void
    ) {

        let userInfo = response.notification.request.content.userInfo

        print("🔔 Notification tapped")
        print("📦 Data:", userInfo)

        completionHandler()
    }
}
