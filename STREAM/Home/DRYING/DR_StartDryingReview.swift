//
//  DR_StartDryingReview.swift
//  STREAM
//
//  Created by Danxd on 7/23/26.
//

import SwiftUI
import SwiftData

struct StartDryingPreviewList: Codable, Identifiable {
    var id: String { rhid }
    var rhid: String
    var initial_mc: String
    var total_hours: String
    var reversal_hours: String
    var drying_start: String
    var estimated_end: String
}

struct DR_StartDryingReview: View {
    
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var contextmodel
    
    @State private var startdryingpreview: [StartDryingPreviewList] = []
    @State private var showAlertStartDrying: Bool = false
    
    let rhid: String
    
    var body: some View {
        NavigationStack {
            List(startdryingpreview) { item in
                Section {
                    VStack(alignment: .leading) {
                        Text("RHID")
                            .font(.footnote)
                        Text("\(item.rhid)")
                            .font(.title2)
                    }
                    VStack(alignment: .leading) {
                        Text("Initial MC")
                            .font(.footnote)
                        Text("\(item.initial_mc)")
                            .font(.title2)
                    }
                    VStack(alignment: .leading) {
                        Text("Est. Drying Hours")
                            .font(.footnote)
                        Text("\(item.total_hours)")
                            .font(.title2)
                    }
                    VStack(alignment: .leading) {
                        Text("Drying Start")
                            .font(.footnote)
                        Text("\(item.drying_start)")
                            .font(.title2)
                    }
                    VStack(alignment: .leading) {
                        Text("Est. Drying End")
                            .font(.footnote)
                        Text("\(item.estimated_end)")
                            .font(.title2)
                    }
                }
                
                Section {
                    HStack {
                        Button(action: {
                            showAlertStartDrying = true
                        }) {
                            Text("Start Now")
                                .padding(5)
                        }
                        .buttonStyle(.glassProminent)
                        .glassEffect()
                        .alert("Confirmation", isPresented: $showAlertStartDrying) {
                            Button("Close", role: .cancel) { }
                            Button(action: {
                                insertDataDP(rhid: rhid)
                            }) {
                                Text("Confirm")
                            }
                        } message: {
                            Text("Please confirm to proceed drying")
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .onAppear() {
            getDataDP()
        }
    }
    
    func getDataDP() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/getDryingPreview.php?rhid=\(rhid)&type=1") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(StartDryingPreviewList.self, from: data)

                DispatchQueue.main.async {
                    startdryingpreview = [result]
                }
            } catch {
                print(error)
                print(String(data: data, encoding: .utf8) ?? "")
            }
            
        }
        .resume()
    }
    
    func insertDataDP(rhid: String) {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/confirm_drying.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "rhid": rhid,
            "type": "2"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                let dhid = String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? "NA"

                print("Drying...\(dhid)")

                DispatchQueue.main.async {
                    dismiss()
                }
            }

        }.resume()
    }
}

#Preview {
    DR_StartDryingReview(rhid: "6")
}
