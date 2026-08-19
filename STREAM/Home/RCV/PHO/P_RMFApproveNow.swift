//
//  P_RMFApproveNow.swift
//  STREAM
//
//  Created by Danxd on 7/23/26.
//

import SwiftUI

struct P_RMFApproveNow: View {
    
    let rhid: String
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var openApproveAlert: Bool = false
    @State private var openCancelAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebViewX(url: URL(string: "https://ops.stellarseedscorp.org/modules/pho/views/scaler/print_rmf_legacy_app.php?rhid=\(rhid)&type=app")!)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        openApproveAlert = true
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.green)
                    }
                    .alert("Confirmation", isPresented: $openApproveAlert) {
                        Button("Cancel", role: .cancel) { }
                        
                        Button(action: {
                            formConfirmation(type: "1")
                            dismiss()
                        }) {
                            Text("Approve")
                            
                        }
                    } message: {
                        Text("Are you sure you want to approve this form?")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        openCancelAlert = true
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(Color.red)
                    }
                    .alert("Confirmation", isPresented: $openCancelAlert) {
                        Button("Cancel", role: .cancel) { }
                        
                        Button(action: {
                            formConfirmation(type: "2")
                            dismiss()
                        }) {
                            Text("Decline")
                        }
                    } message: {
                        Text("Are you sure you want to decline this form?")
                    }
                }
            }
        }
    }
    
    func formConfirmation(type: String) {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/PHO/confirm_rmf.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "rhid": rhid,
            "type": type
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                
                print(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NA")
//                
//                if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "1" {
//                    dismiss()
//                } else {
//                    dismiss()
//                }
            }
            
        }.resume()
        
    }
}

#Preview {
    P_RMFApproveNow(rhid: "5")
}
