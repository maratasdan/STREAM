//
//  NotificationDelegate.swift
//  STREAM
//
//  Created by Danxd on 7/28/26.
//

import Foundation
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationDelegate()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        completionHandler([.banner, .sound, .badge])
    }

}
