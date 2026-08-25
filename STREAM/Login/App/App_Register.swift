//
//  App_Register.swift
//  STREAM
//
//  Created by Dan on 8/25/26.
//

import SwiftUI
import MSAL
import SwiftData

struct AppUserDataReg: Codable {
    let userid: Int
    let jobTitle: String
    let email: String
    let firstname: String
    let lastname: String
    let role: String
}

struct App_Register: View {
    
    let emailEx: String
    
    @Environment(\.modelContext) private var context
    
    @State private var userdata: [AppUserDataReg] = []
    
    @State private var goToregister: Bool = false
    @State private var email: String = ""
    
    @State private var goToCheckSession: Bool = false
    
    @State private var displayName: String = ""
    @State private var position: String = "Warehouse Man"
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var openSheetCheckingAccount: Bool = false
    @State private var openPleaseWaitVerification: Bool = false
    @State private var openAlertEmptyField: Bool = false
    
    @State private var rotation: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bglog")
                    .scaledToFill()
                
                Rectangle()
                    .foregroundStyle(Color.black.opacity(0.1))
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    Spacer()
                    
                    Image("stellar-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                    
                    VStack(spacing: 10) {
                        ZStack {
                            Rectangle()
                                .frame(width: 350, height: 50)
                                .glassEffect()
                                .foregroundStyle(Color.clear)
                            HStack {
                                Image(systemName: "person.fill")
                                TextField("\(emailEx)", text: $username)
                                    .frame(width: 290)
                                    .disabled(true)
                            }
                        }
                    }
                    
                    VStack(spacing: 10) {
                        ZStack {
                            Rectangle()
                                .frame(width: 350, height: 50)
                                .glassEffect()
                                .foregroundStyle(Color.clear)
                            HStack {
                                Image(systemName: "person.fill")
                                TextField("Display Name", text: $displayName)
                                    .frame(width: 290)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .frame(width: 350, height: 50)
                                .glassEffect(.regular)
                                .foregroundStyle(Color.clear)
                            HStack {
                                Image(systemName: "person.fill")
                                TextField("Job Position", text: $position)
                                    .frame(width: 290)
                                    .disabled(true)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .frame(width: 350, height: 50)
                                .glassEffect(.regular)
                                .foregroundStyle(Color.clear)
                            HStack {
                                Image(systemName: "lock")
                                SecureField("Password", text: $password)
                                    .frame(width: 290)
                            }
                        }
                    }
                    
                    Button {
                        
                        username = emailEx
                        
                        if username == "" ||
                           password == "" ||
                           displayName == "" ||
                           position == ""
                        {
                            openAlertEmptyField = true
                        } else {
//                            openSheetCheckingAccount = true
                            saveAccountOnline(username: username, password: password, displayName: displayName, position: position)
                        }
                        
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            Text("Submit and Verify")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .bold()
                            
                        }
                        .frame(maxWidth: 330)
                        .frame(height: 38)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(hex: "#F25022"))
                    .glassEffect(.regular)
                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal,40)
                .alert("Error", isPresented: $openAlertEmptyField) {
                    
                } message: {
                    Text("Please fill up all the fields.")
                }
                .sheet(isPresented: $openSheetCheckingAccount) {
                    VStack(spacing: 20) {
                        
                        // Loading Spinner
                        Circle()
                            .trim(from: 0.05, to: 0.75)
                            .stroke(
                                Color(hex: "#F25022"),
                                style: StrokeStyle(
                                    lineWidth: 4,
                                    lineCap: .round
                                )
                            )
                            .frame(width: 45, height: 45)
                            .rotationEffect(.degrees(rotation))
                            .onAppear {
                                withAnimation(
                                    .linear(duration: 1)
                                    .repeatForever(autoreverses: false)
                                ) {
                                    rotation = 360
                                }
                            }
                        
                        Text("Checking account...")
                            .font(.headline)
                            .foregroundStyle(Color(hex: "#F25022"))
                        
                        Text("Make sure you are connected to the internet.")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "#F25022").opacity(0.6))
                    }
                    .presentationDetents([.medium])
//                    .interactiveDismissDisabled(true)
                }
                
            }
            .navigationDestination(isPresented: $goToregister) {
                Registration(username: email)
            }
            .navigationDestination(isPresented: $goToCheckSession) {
                CheckSession()
            }
            .navigationDestination(isPresented: $openPleaseWaitVerification) {
                App_WaitVerification()
            }
            .navigationBarBackButtonHidden(true)
            
            
        }
        
    }
    
    func saveUserLocalDB(useridx: Int, emailx: String, firstnamex: String, lastnamex: String, jobTitlex: String, rolex: String) {
        let item = tbl_login(
                userid: useridx,
                email: emailx,
                firstname: firstnamex,
                lastname: lastnamex,
                jobTitle: jobTitlex,
                role: rolex
            )
            
            do {
                context.insert(item)
                try context.save()
                
                print("✅ LOCAL SAVE SUCCESS")
                
                // TEST: Fetch directly from SwiftData
                let request = FetchDescriptor<tbl_login>()
                let savedUsers = try context.fetch(request)
                
                print("📦 SwiftData COUNT:", savedUsers.count)
                
                for user in savedUsers {
                    print("📦 SAVED USER:", user.userid, user.email)
                }
                
                DispatchQueue.main.async {
                    goToCheckSession = true
                }
                
            } catch {
                print("❌ LOCAL SAVE ERROR:", error)
            }
    }
    
    func saveAccountOnline(username: String, password: String, displayName: String, position: String) {
        var request = URLRequest(url: URL(string: "https://ops.stellarseedscorp.org/auth/save_account_app.php?type=app")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "displayName": displayName,
            "position": position
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            openSheetCheckingAccount = false

            print(String(data: data, encoding: .utf8) ?? "")
            
            if String(data: data, encoding: .utf8) == "reg" {
                openPleaseWaitVerification = true
            } else {
                 openPleaseWaitVerification = true
            }
            
        }.resume()
    }
}

#Preview {
    App_Register(emailEx: "")
}
