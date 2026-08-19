//
//  STREAMApp.swift
//  STREAM
//
//  Created by Danxd on 7/6/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct STREAMApp: App {
    
    init() {
        NotificationManager.shared.requestPermission()
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
//            Registration(username: "dan.scaler@stellarseedscorp.org")
//            Login()
            CheckSession()
//            DR_DMR()
//            RCV_Home()
//            DR_Panel()
//            DR_Nav()
        }
        .modelContainer(for:[
            tbl_lcc.self,
            tbl_drmonitoring_rows.self,
            tbl_drying_header.self,
            tbl_login.self
        ])
    }
    
    func requestNotificationPermission() {

        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

                print("Notification Permission: \(granted)")
            }
    }
}
