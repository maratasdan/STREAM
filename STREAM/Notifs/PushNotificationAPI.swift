//
//  PushNotificationAPI.swift
//  PushNotificationDemo
//
//  Created by Dan on 9/9/26.
//

import Foundation

final class PushNotificationAPI {

    static let shared = PushNotificationAPI()

    private init() {}

    // MARK: - Configuration

    private let baseURL =
        "https://ops.stellarseedscorp.org/push/send-push.php"


    // MARK: - Send Push Notification

    func send(
        userId: Int,
        title: String,
        body: String
    ) {

        guard let url = URL(string: baseURL) else {
            print("❌ Invalid push API URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )


        let payload: [String: Any] = [

            "user_id": userId,

            "title": title,

            "body": body

        ]


        do {

            request.httpBody =
                try JSONSerialization.data(
                    withJSONObject: payload,
                    options: []
                )

        } catch {

            print("❌ Failed to encode push payload:")
            print(error.localizedDescription)

            return
        }


        URLSession.shared.dataTask(
            with: request
        ) { data, response, error in

            if let error = error {

                print("❌ Push API Error:")
                print(error.localizedDescription)

                return
            }


            if let httpResponse =
                response as? HTTPURLResponse {

                print(
                    "📡 Push API Status:",
                    httpResponse.statusCode
                )
            }


            guard let data = data else {

                print("⚠️ No response from Push API")

                return
            }


            if let responseString =
                String(
                    data: data,
                    encoding: .utf8
                ) {

                print("📦 Push API Response:")
                print(responseString)
            }

        }.resume()
    }
}
