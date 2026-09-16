//
//  PushNotificationManager.swift
//  PushNotificationDemo
//
//  Created by Dan on 9/9/26.
//
import Foundation
import UIKit
import UserNotifications

final class PushNotificationManager {

    static let shared = PushNotificationManager()

    private init() {}

    // MARK: - API

    private let apiURL =
        "https://YOUR-DOMAIN.com/push/register-device.php"


    // MARK: - Request Permission

    func requestPermission() {

        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [
                    .alert,
                    .badge,
                    .sound
                ]
            ) { granted, error in

                if let error = error {

                    print("Notification permission error:")
                    print(error.localizedDescription)

                    return
                }

                print("Notification Permission:", granted)

                guard granted else {
                    return
                }

                DispatchQueue.main.async {

                    UIApplication.shared
                        .registerForRemoteNotifications()
                }
            }
    }


    // MARK: - Register Device

    func registerDeviceToken(_ token: String) {

        let urlString = "https://ops.stellarseedscorp.org/push/register-device.php"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid API URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let deviceType =
            UIDevice.current.userInterfaceIdiom == .pad
            ? "iPad"
            : "iPhone"

        let payload: [String: Any] = [
            "user_id": 1001,
            "device_token": token,
            "device_type": deviceType,
            "device_name": UIDevice.current.name
        ]

        do {

            request.httpBody = try JSONSerialization.data(
                withJSONObject: payload
            )

        } catch {

            print("❌ JSON encoding failed:", error)
            return
        }

        URLSession.shared.dataTask(
            with: request
        ) { data, response, error in

            if let error = error {

                print("❌ Device registration failed:")
                print(error.localizedDescription)

                return
            }

            if let response = response as? HTTPURLResponse {

                print("📡 Server Status:", response.statusCode)
            }

            if let data = data {

                print(
                    "📦 Server Response:",
                    String(data: data, encoding: .utf8) ?? ""
                )
            }

        }.resume()
    }
    
}
