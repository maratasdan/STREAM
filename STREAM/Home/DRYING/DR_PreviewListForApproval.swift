//
//  DR_PreviewListForApproval.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI

struct DR_PreviewListForApproval: View {
    
    let rhid: String
    let binid: String
    let rmf_date: String
    let hybrid_code: String
    let qf: String
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlertDecline: Bool = false
    @State private var showAlertApprove: Bool = false
    
    var body: some View {
        List {
            Section("RHID: \(rhid)") {
                HStack {
                    Image(systemName: "archivebox")
                    VStack {
                        Text("Bin \(binid)")
                    }
                }
                .font(.system(size: 20))
                HStack {
                    Image(systemName: "calendar")
                    VStack {
                        Text("\(rmf_date)")
                    }
                }
                .font(.system(size: 20))
                HStack {
                    Image(systemName: "leaf")
                    VStack {
                        Text("\(hybrid_code)")
                    }
                }
                .font(.system(size: 20))
            }
            
            HStack {
                Button(action: {
                    showAlertDecline = true
                }) {
                    Text("Decline")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                .tint(Color.red)
                .buttonStyle(.glassProminent)
                .glassEffect(.clear)
                .frame(maxWidth: .infinity)
                .alert("Decline Confirmation", isPresented: $showAlertDecline) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        print("Deleted")
                    }
                } message: {
                    Text("Are you sure you want to delcine this form?")
                }
                
                Button(action: {
                    showAlertApprove = true
                }) {
                    Text("Approve")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                .tint(Color.green)
                .buttonStyle(.glassProminent)
                .glassEffect(.clear)
                .frame(maxWidth: .infinity)
                .alert("Approve Confirmation", isPresented: $showAlertApprove) {
                    Button("Cancel", role: .cancel) { }
                    Button("Approve", role: .confirm) {
                        print("Approve")
                        approveForm(rhid: rhid)
                    }
                } message: {
                    Text("Are you sure you want to approve this form?")
                }
                
            }
        }
    }
    
    func approveForm(rhid: String) {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/approval_form.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "rhid": rhid,
            "type": "1"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "done" {
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
            }
            
        }.resume()
    }
    
    func declineForm() {
        guard let url = URL(string: "https://yourdomain.com/api/save.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "userid": "001",
            "fullname": "Dan Maratas"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
}

#Preview {
    DR_PreviewListForApproval(rhid: "2", binid: "401", rmf_date: "2025-21-01", hybrid_code: "RF", qf: "")
}
