//
//  DR_ConfirmTopup.swift
//  STREAM
//
//  Created by Danxd on 7/31/26.
//

import SwiftUI

struct TP_Data: Codable, Identifiable {
    var id: String { rhid }
    
    let lot_number: String
    let dhid: Int
    let rhid: String
    let drying_initial_mc: Double
    let topup_new_mc: Double?
    let drying_start: String
    let topup_at: String
    let topup_confirmed: Int
    let latest_row_date: String
    let latest_upper: String
    let latest_lower: String
}

struct DR_ConfirmTopup: View {
    
    let rhid: String
    
    @State private var errormsg: String = ""
    @State private var goToDrNav: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var openUploadAlert: Bool = false
    
    @State private var topupData: [TP_Data] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section("Topup Details") {
                    VStack(alignment: .leading) {
                        Text("Lot Number \(rhid)")
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                        Text("\(topupData.first?.lot_number ?? "NA")")
                    }
                    VStack(alignment: .leading) {
                        Text("New MC")
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                        HStack {
                            Text("\(topupData.first?.drying_initial_mc ?? 0, format: .number)")
                            Image(systemName: "arrow.right")
                            Text("\(topupData.first?.topup_new_mc ?? 0, format: .number)")
                                .bold()
                        }
                    }
                    
                    if errormsg.isEmpty {
                        
                    } else {
                        VStack {
                            Text("\(errormsg)")
                                .font(.footnote)
                                .foregroundStyle(Color.red)
                        }
                    }
                }
                
                Button(action: {
                    openUploadAlert = true
                }) {
                    Text("Proceed Now")
                }
            }
            .alert("Confirmation", isPresented: $openUploadAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Proceed", role: .confirm) {
                    updateTP()
                }
            } message: {
                Text("Are you sure to proceed topup?")
            }
        }
        .onAppear() {
            loadTPDataOnine()
        }
        .navigationDestination(isPresented: $goToDrNav) {
            DR_Nav()
        }
    }
    
    func loadTPDataOnine() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/receiving-header.php?rhid=\(rhid)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([TP_Data].self, from: data)
                topupData = result
//                print(result)
            } catch {
                print(error)
            }

        }.resume()
        
    }
    
    func updateTP() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/modules/pho/views/dryer_operator/API/calculate-tp.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "rhid": rhid,
            "dhid": topupData.first?.dhid ?? 0,
            "newmc": String(format: "%.2f", topupData.first?.topup_new_mc ?? 0),
            "latest_row_date": numberOfHours(from: topupData.first?.latest_row_date ?? "NA"),
            "latest_upper": topupData.first?.latest_upper ?? 0,
            "latest_lower": topupData.first?.latest_lower ?? 0
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                if String(data: data, encoding: .utf8) == "updated" {
                    goToDrNav = true
                } else {
                    errormsg = "Error or Please check internet connection";
                }
            } else {
                print("Error")
            }
        }.resume()
    }
    
    func numberOfHours(from dateString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let startDate = formatter.date(from: dateString) else {
            return "--:--:--"
        }
        
        let elapsed = Int(Date().timeIntervalSince(startDate))

        if elapsed < 0 {
            return "00:00:00"
        }
        
        let hours = elapsed / 3600
        let minutes = (elapsed % 3600) / 60
        let seconds = elapsed % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    DR_ConfirmTopup(rhid: "12")
}
