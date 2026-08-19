//
//  LCNames.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import SwiftUI
import SwiftData

struct LCNames: View {
    
    let rhid: String
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @State private var opname: String = ""
    @State private var slname: String = ""
    
    @State private var errmsg: Bool = false
    @State private var goToHome: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Operator")
                        TextField("Write Here...", text: $opname)
                            .padding(5)
                            
                    }
                    VStack(alignment: .leading) {
                        Text("Shift Leader")
                        TextField("Write Here...", text: $slname)
                            .padding(5)
                            
                    }
                }
                VStack(alignment: .trailing) {
                    Button(action: {
                        if opname.isEmpty || slname.isEmpty {
                            errmsg = true
                        } else {
                            approveForm(rhid: rhid, opName: opname, slName: slname)
                        }
                    }) {
                        Text("Submit")
                            .padding(5)
                    }
                    .buttonStyle(.glassProminent)
                    .alert("Error", isPresented: $errmsg) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Please fill out all fields.")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $goToHome) {
            P_Home()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func approveForm(rhid: String, opName: String, slName: String) {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/PHO/get_lcc_list.php") else { return }

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
                
                print(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "NA")
                
                if String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "donelc" {
                    saveDataLC(slName: opName, opName: opName)
                }
            }
            
        }.resume()
    }
    
    func saveDataLC(slName: String, opName: String) {
        
        let descriptor = FetchDescriptor<tbl_lcc>(
            predicate: #Predicate {
                $0.rhid == rhid
            }
        )
        
        do {
            if let res = try context.fetch(descriptor).first {
                res.opname = opName
                res.slname = slName

                try context.save()
                print("Updated successfully")
                goToHome = true
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    LCNames(rhid: "")
}
