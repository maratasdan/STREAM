//
//  Scaler_Home.swift
//  STREAM
//
//  Created by Dan on 8/24/26.
//

import SwiftUI
import WebKit
import SwiftData

struct Scaler_Home: View {
    
    @Query private var userdata: [tbl_login]
    @Environment(\.modelContext) private var context
    
    @State private var goHome: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if userdata.first?.email == nil {
                    VStack {
                        Text("No Internet Connection or Email is not yet Registered")
                    }
                } else {
                    WebViewX(url: URL(string: "https://ops.stellarseedscorp.org/auth/AppSession/login_session.php?email=\(userdata.first?.email ?? "")&platform=mobile")!)
                        .ignoresSafeArea()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        logout()
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $goHome) {
            CheckSession()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func logout() {
        do {
            let users = try context.fetch(FetchDescriptor<tbl_login>())
            
            for user in users {
                context.delete(user)
            }
            
            try context.save()
            
            print("✅ Deleted \(users.count) users")
            goHome = true
            
        } catch {
            print("❌ Delete error:", error)
        }
    }
}

#Preview {
    Scaler_Home()
}
