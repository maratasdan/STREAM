//
//  CND_List.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct ConditioningList: Codable, Identifiable {
    var id: String { cndshlist_id }
    var cndshlist_id: String
    var cndshid: String
    var orders: String
    var routing_no: String
    var bin: String
    var client: String
    var hybrid: String
    var batchno: String
    var qty: String
    var flag: String
    var com500: String
    var po_com500: String
    var com300: String
    var status: String
    var pre_ppt: String
    var sstatus: String
}

struct CND_List: View {
    
    let cndshid: String
    
    @State private var conditioninglist: [ConditioningList] = []
    
    var body: some View {
        NavigationStack {
            if conditioninglist.isEmpty {
                VStack(spacing: 15) {
                    ProgressView()
                        .scaleEffect(1.4)

                    Text("Fetching Data")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.6))
            } else {
                VStack(alignment: .leading) {
                    
                    Table(conditioninglist) {
                        TableColumn("ID", value: \.cndshlist_id)
                        TableColumn("Lot Number", value: \.batchno)
                        TableColumn("Bin", value: \.bin)
                        TableColumn("Hybrid", value: \.hybrid)
                        TableColumn("Status") { item in
                            if item.sstatus == "2" {
                                NavigationLink {
                                    CND_Conditioning(cndlistid: item.cndshlist_id, cndshid: item.cndshid)
                                } label: {
                                    Text("Conditioning")
                                }
                            } else if item.sstatus == "3" {
                                NavigationLink {
                                    CND_CPF(cndlistid: item.cndshlist_id)
                                } label: {
                                    Text("View CPF")
                                }
                            } else if item.sstatus == "1" {
                                NavigationLink {
                                    
                                } label: {
                                    Text("Pending")
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        .onAppear() {
            getCNDList()
        }
    }
    
    func getCNDList() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/CND/getCNDList.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "cndshid=\(cndshid)"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([ConditioningList].self, from: data)

                DispatchQueue.main.async {
                    self.conditioninglist = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
}

#Preview {
    CND_List(cndshid: "CND43327")
}
