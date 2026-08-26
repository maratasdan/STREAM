//
//  WH_Dashboard.swift
//  STREAM
//
//  Created by dan on 8/25/26.
//

import SwiftUI
import SwiftData

struct QRData: Codable {
    let type: String
    let tagid: Int
    let rhid: Int
    let lotno: String
    let jbno: String
    let kg: Double
    let api: String
}


struct WH_Dashboard: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var userdata: [tbl_login]
    @State private var qrdata: QRData?
    
    @State private var goToCheckSession: Bool = false
    @State private var isOn = true
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToConfirmTag: Bool = false
    @State private var goToTags: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 45, height: 45)
                                .cornerRadius(30)
                                .foregroundStyle(Color.green)
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(30)
                                .foregroundStyle(Color.white)
                            Image(systemName: "person")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(userdata.first?.firstname ?? "") \(userdata.first?.lastname ?? "")")
                            Text("Warehouse Man")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.forward.2")
                            .foregroundStyle(Color.green)
                        
                    }
                    .listRowBackground(Color.clear)
                    
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            logout()
                        }) {
                            Image(systemName: "power")
                                .foregroundStyle(Color.red)
                                .tint(Color.red)
                                .bold()
                        }
                    }
                    
                }
                Section {
                    NavigationLink(destination: WH_Home()) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.green.opacity(0.15))
                                Image(systemName: "house")
                            }
                            VStack(alignment: .leading) {
                                Text("Warehouses")
                                Text("Display all warehouses")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    NavigationLink(destination: WH_Home()) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.green.opacity(0.15))
                                Image(systemName: "list.bullet.rectangle.portrait")
                            }
                            VStack(alignment: .leading) {
                                Text("ISM")
                                Text("Create, View and Share")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showScanner) {
                ZStack {
                    QRScannerView { code in
                        qrCode = code
                        getQRData(codedata: qrCode)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $goToCheckSession) {
            CheckSession()
        }
        .navigationDestination(isPresented: $goToConfirmTag) {
            WH_PreviewConfirm(lotno: qrdata?.lotno ?? "", rhid: qrdata?.rhid ?? 0, processtype: qrdata?.type ?? "", jbno: qrdata?.jbno ?? "", kg: qrdata?.kg ?? 0, tagid: qrdata?.tagid ?? 0)
        }
        .navigationDestination(isPresented: $goToTags) {
            WH_Tags(lotno: qrdata?.lotno ?? "")
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    showScanner = true
                }) {
                    Image(systemName: "qrcode")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func getQRData(codedata: String) {
        
        print(codedata)
        showScanner = false
        
        guard let data = codedata.data(using: .utf8) else {
            return
        }
        do {
            let decoded = try JSONDecoder().decode(QRData.self, from: data)

            qrdata = decoded
            
            checkifexist(lotnumber: decoded.lotno, rhid: decoded.rhid)
            
           
       } catch {
           print("❌ Invalid QR:", error)
       }
    }
    
    func checkifexist(lotnumber: String, rhid: Int) {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/Warehouse/check_tag_exist.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "rhid": rhid,
            "lotnumber": lotnumber,
            "uuid": UUID().uuidString,
            "step": "1"
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                
                print(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))
                
                if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "no records" {
                    goToConfirmTag = true
                } else if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "Exist" {
                    goToTags = true
                } else {
                    
                }
            }
            
        }.resume()
        
    }
    
    func logout() {
        do {
            let users = try context.fetch(FetchDescriptor<tbl_login>())
            
            for user in users {
                context.delete(user)
            }
            
            try context.save()
            
            print("✅ Deleted \(users.count) users")
            goToCheckSession = true
            
        } catch {
            print("❌ Delete error:", error)
        }
    }
}

struct ProfileHeader: View {
    
    var body: some View {
        
    }
}

#Preview {
    WH_Dashboard()
}
