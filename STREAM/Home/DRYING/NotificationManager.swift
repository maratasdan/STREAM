//
//  NotificationManager.swift
//  STREAM
//
//  Created by Danxd on 7/27/26.
//

import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in

            if let error {
                print(error)
            }

            print("Permission:", granted)
        }
    }

    func sendNotification(bin: String) {

        let content = UNMutableNotificationContent()
        content.title = "Timers Up!"
        content.body = "It's time to record the temperature for Bin \(bin)."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "BIN_\(bin)",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

}
