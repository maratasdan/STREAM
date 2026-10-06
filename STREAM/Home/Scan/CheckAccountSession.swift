//
//  CheckAccountSession.swift
//  STREAM
//
//  Created by dan on 10/6/26.
//

import SwiftUI
import SwiftData

struct CheckAccountSession: View {
    
    let rhid: Int
    
    //MARK: Database
    @Query private var userdata: [tbl_login] = []
    
    var body: some View {
        VStack {
            if userdata.first?.email == nil {
                VStack {
                    Text("No Internet Connection or Email is not yet Registered")
                }
            } else {
                WebViewX(url: URL(string: "https://ops.stellarseedscorp.org/modules/admin/activity_log_app.php?rhid=\(rhid)")!)
                    .ignoresSafeArea()
            }
        }
    }
    
    func checkAccount() {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/auth/check_account_exist_app.php") else {
            print("Invalid URLx")
            return
        }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
    let body = [
        "username": userdata[0].email
    ]
        
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    print(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                }
            }
        }
        .resume()
    
    }
    
}

#Preview {
    CheckAccountSession(rhid: 0)
}
