//
//  Login.swift
//  STREAM
//
//  Created by Danxd on 8/7/26.
//

import SwiftUI
import MSAL
import SwiftData

struct AppUserData: Codable {
    let userid: Int
    let jobTitle: String
    let email: String
    let firstname: String
    let lastname: String
    let role: String
}

struct App_Login: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var userdata: [AppUserData] = []
    
    @State private var goToregister: Bool = false
    @State private var email: String = ""
    
    @State private var goToCheckSession: Bool = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var openSheetCheckingAccount: Bool = false
    @State private var openAppRegister: Bool = false
    @State private var openAlertEmptyField: Bool = false
    @State private var openWaitVerify: Bool = false
    @State private var openWrongAccount: Bool = false
    
    @State private var rotation: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bglog")
                    .scaledToFill()
                
                Rectangle()
                    .foregroundStyle(Color.black.opacity(0.6))
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
                                TextField("Email Address", text: $username)
                                    .frame(width: 290)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .frame(width: 350, height: 50)
                                .glassEffect()
                                .foregroundStyle(Color.clear)
                            HStack {
                                Image(systemName: "lock")
                                SecureField("Password", text: $password)
                                    .frame(width: 290)
                            }
                        }
                    }
                    
                    Button {
                        
                        
                        openSheetCheckingAccount = true
                        
                        if username == "" || password == "" {
                            openAlertEmptyField = true
                        } else {
                            openSheetCheckingAccount = true
                            checkIfAccountExist(username: username, password: password)
                        }
                        
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            Text("Login")
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
                    
                    VStack(spacing: 6) {
                        
                        Text("Please contact MIS if you don't have an authorized account.")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 360)
                        
                        Text("Version 2.1.1")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.45))
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal,40)
                
                
                .alert("Error", isPresented: $openAlertEmptyField) {
                    
                } message: {
                    Text("Please fill up all the fields.")
                }
                
                .alert("Error", isPresented: $openWrongAccount) {
                    
                } message: {
                    Text("Invalid Account, Please try again.")
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
            .navigationDestination(isPresented: $openAppRegister) {
                App_Register(emailEx: username)
            }
            .navigationDestination(isPresented: $openWaitVerify) {
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
    
    func checkIfAccountExist(username: String, password: String) {
        var request = URLRequest(url: URL(string: "https://ops.stellarseedscorp.org/auth/check_account_exist_app_mobile.php?type=app")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            print(String(data: data, encoding: .utf8) ?? "")
            
            if(String(data: data, encoding: .utf8)  == "No") {
                openAppRegister = true
            } else if(String(data: data, encoding: .utf8)  == "Wrong Password") {
                openWrongAccount = true
            } else if(String(data: data, encoding: .utf8)  == "notver") {
                openWaitVerify = true
            } else if(String(data: data, encoding: .utf8)  == "empty") {
                openWaitVerify = true
            } else {
                print("Found")
                do {
                    let decoded = try JSONDecoder().decode([AppUserData].self, from: data)

                    DispatchQueue.main.async {
                        userdata = decoded
                        
                        if let userx = decoded.first {
                            saveUserLocalDB(useridx: userx.userid, emailx: userx.email, firstnamex: userx.firstname, lastnamex: userx.lastname, jobTitlex: userx.jobTitle, rolex: userx.role)
                        }
                        
                    }
                
                } catch {
                    print("JSON Decode Error:", error)
                }
            }
            
        }.resume()
    }
}

#Preview {
    App_Login()
}
