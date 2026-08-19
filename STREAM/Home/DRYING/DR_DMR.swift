//
//  DR_DMR.swift
//  STREAM
//
//  Created by Danxd on 8/17/26.
//

import SwiftUI

struct GetDMRS: Identifiable, Codable {
    var id: String { dhid }
    var dhid: String
    var rhid: String
    var initial_mc: String
    var drying_start: String
    var lot_number: String
    var status: String
    var statis: String
    var bin_name: String
    var seed_name: String
    var blower: String
    var hybrid: String
    var drying_end: String?
}

struct DR_DMR: View {
    
    @State private var getdmrs: [GetDMRS] = []
    @State private var searchText: String = ""
    
    var filteredDMRS: [GetDMRS] {
        if searchText.isEmpty {
            return getdmrs
        }
        
        return getdmrs.filter {
            $0.lot_number.localizedCaseInsensitiveContains(searchText) || 
            $0.bin_name.localizedCaseInsensitiveContains(searchText) ||
            $0.dhid.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                    HStack {
                        TextField("DHID, Lot Number, Bin", text: $searchText)
                            .padding(7)
                            .frame(maxWidth: 300)
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(5)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                
                Table(filteredDMRS) {
//                    TableColumn("ID") { item in
//                        VStack(alignment: .leading) {
//                            Text("DHID: \(item.dhid)")
//                                .font(.system(size: 12))
//                            Text("RHID: \(item.rhid)")
//                                .font(.system(size: 12))
//                        }
//                    }
                    TableColumn("Bin", value: \.bin_name)
                    TableColumn("Lot Number", value: \.lot_number)
                    TableColumn("Drying End") { item in
                        Text("\(item.drying_end ?? "NA")")
                    }
                    TableColumn("") { item in
                        Menu {
                            
                            NavigationLink(destination: DR_ViewDMR(dhid: item.dhid)) {
                                Label("DMR", systemImage: "list.bullet.clipboard")
                            }
                            
                            NavigationLink(destination: DR_ViewRMF(rhid: item.rhid)) {
                                Label("RMF", systemImage: "list.clipboard.fill")
                            }

                            Button(action: {
                                
                            }) {
                                Label("Statistics", systemImage: "chart.bar.xaxis")
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.secondary.opacity(0.15))
                                    .cornerRadius(30)
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            getdmrsonline()
        }
    }
    
    func getdmrsonline() {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/get_dmrs.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "rhid"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([GetDMRS].self, from: data)

                DispatchQueue.main.async {
                    self.getdmrs = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
}

#Preview {
    DR_DMR()
}
