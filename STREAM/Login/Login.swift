//
//  Login.swift
//  STREAM
//
//  Created by Danxd on 8/7/26.
//

import SwiftUI
import MSAL
import SwiftData

struct UserData: Codable {
    let userid: Int
    let jobTitle: String
    let email: String
    let firstname: String
    let lastname: String
    let role: String
}

struct Login: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var userdata: [UserData] = []
    
    @State private var goToregister: Bool = false
    @State private var email: String = ""
    
    @State private var goToCheckSession: Bool = false
    
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
                    
                    Button {
                        
                        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let root = scene.windows.first?.rootViewController else {
                            return
                        }
                        
                        AuthenticationManager.shared.signIn(from: root) { result in
                            
                            switch result {
                                
                            case .success(let auth):
                                
                                print(auth.account.username ?? "NA")
                                
                                checkIfAccountExist(username: auth.account.username ?? "NA")
                                
                            case .failure(let error):
                                
                                print(error)
                                
                            }
                            
                        }
                        
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            Image("mslogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text("Sign in with Microsoft")
                                .font(.headline)
                                .foregroundStyle(.black)
                            
                        }
                        .frame(maxWidth: 380)
                        .frame(height: 58)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.clear)
                    .glassEffect()
                    
                    VStack(spacing: 6) {
                        
                        Text("Please contact MIS if you don't have an authorized account.")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                        
                        Text("Version 1.0.0")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.45))
                        
                    }
                    
//                    Button("Go") {
//                        checkIfAccountExist(username: "mariomaratasjr@stellarseedscorp.org")
//                    }
//                    .buttonStyle(.glassProminent)
//                    .glassEffect()
                    
                    Spacer()
                    
                }
                .padding(.horizontal,40)
                
            }
            .navigationDestination(isPresented: $goToregister) {
                Registration(username: email)
            }
            .navigationDestination(isPresented: $goToCheckSession) {
                CheckSession()
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
    
    func checkIfAccountExist(username: String) {
        var request = URLRequest(url: URL(string: "https://ops.stellarseedscorp.org/auth/check_account_exist_app.php?type=app")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            print(String(data: data, encoding: .utf8) ?? "")
            
            if(String(data: data, encoding: .utf8)  == "No") {
                email = username
                goToregister = true
                print("lalalal")
            } else {
                do {
                    let decoded = try JSONDecoder().decode([UserData].self, from: data)

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
    Login()
}
