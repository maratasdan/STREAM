//
//  WH_Tags.swift
//  STREAM
//
//  Created by Dan on 8/26/26.
//

import SwiftUI

struct JBTags: Codable {
    let tagid: String
    let lotno: String
    let jbno: String
    let kg: String?
    let sessionid: String?
    let status: String?
}

struct WH_Tags: View {
    
    let lotno: String
    
    @State private var jbtags: [JBTags] = []
    
    @State private var showAlertConfirmTransfer: Bool = false
    @State private var gotohome: Bool = false
    
    var body: some View {
        NavigationStack {
            List(Array(jbtags.enumerated()), id: \.element.tagid) { index, item in
                if item.status == "1" {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(Color.green.opacity(0.15))
                            Text("\(index + 1)")
                                .bold()
                        }
                        VStack(alignment: .leading) {
                            Text("\(item.jbno)")
                            Text("Quantity: \(item.kg ?? "0") KG")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                    }
                } else {
                    NavigationLink(destination: WH_Tags_Scan(tagid: item.tagid, sessionid: item.sessionid ?? "")) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.red.opacity(0.15))
                                Text("\(index + 1)")
                                    .bold()
                            }
                            VStack(alignment: .leading) {
                                Text("\(item.jbno)")
                                Text("Quantity: \(item.kg ?? "0") KG")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
            }
        }
        .alert("Confirmation", isPresented: $showAlertConfirmTransfer) {
            Button("Cancel", role: .close) {
                
            }
            Button("Confirm", role: .confirm) {
                confirmTransfer(sessionid: jbtags.first?.sessionid ?? "")
            }
        } message: {
            Text("Are you sure you want to transfer these tags?")
        }
        .navigationDestination(isPresented: $gotohome) {
            WH_Dashboard()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    gotohome = true
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAlertConfirmTransfer = true
                }) {
                    Image(systemName: "checkmark.circle")
                }
                .tint(Color.green)
            }
        }
        .onAppear() {
            getTags(lotno: lotno)
        }
    }
    
    func getTags(lotno: String) {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/Warehouse/get_tags.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "lotnumber": lotno,
            "type": "1"
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
	
            do {
                let result = try JSONDecoder().decode([JBTags].self, from: data)
                print(result)
                jbtags = result

            } catch {
                print(error)
            }

        }.resume()
    }
    
    func confirmTransfer(sessionid: String) {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/Warehouse/confirm_transfer.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "sessionid": sessionid,
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                
                print(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)  ?? "")
                
                if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "savetag" {
                    gotohome = true
                }
            }
            
        }.resume()
    }
}

#Preview {
    WH_Tags(lotno: "")
}
