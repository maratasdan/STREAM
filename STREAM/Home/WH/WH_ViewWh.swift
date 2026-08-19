//
//  WH_ViewWh.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct WarehouseData: Codable, Identifiable {
    var id: String { whid }
    var whid: String
    var sessionid: String
    var lotno: String
    var whno: String
    var status: String
    var phaseType: String
    var totalkg: String
}

struct WarehouseOverAllKl: Codable, Identifiable {
    var id: Double { overallkl }
    var name: String
    var overallkl: Double
}



struct WH_ViewWh: View {
    
    var filteredWarehouseData: [WarehouseData] {
        if searchText.isEmpty {
            return warehousedata
        } else {
            return warehousedata.filter {
                $0.lotno.localizedCaseInsensitiveContains(searchText) ||
                $0.whno.localizedCaseInsensitiveContains(searchText) ||
                $0.sessionid.localizedCaseInsensitiveContains(searchText) ||
                $0.status.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    let whno: String
    let nobags: String
    
    @State private var searchText = ""
    
    @State private var warehousedata: [WarehouseData] = []
    @State private var warehouseoverallkl: [WarehouseOverAllKl] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                HStack(spacing: 20) {
                    VStack {
                        List {
                            Section {
                                VStack {
                                    Image(systemName: "archivebox.circle.fill")
                                        .font(.system(size: 90))
                                    Text("Warehouse \(whno)")
                                        .font(.title2)
                                }
                                .frame(maxWidth: .infinity)
                                .listRowBackground(Color.clear)
                            }
                            Section {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("\(warehouseoverallkl.first?.overallkl ?? 0, specifier: "%.2f")")
                                            .bold()
                                        Text("Total Kilograms")
                                            .font(.footnote)
                                    }
                                }
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("\(nobags) Bags")
                                            .bold()
                                        Text("In-house Bags")
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .frame(width: 300)
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading) {
                        List(filteredWarehouseData) { item in
//                            NavigationLink {
//                                WH_BatchDetails(lotnumber: item.lotno, whno: item.whno)
//                            } label: {
                                HStack {
                                    Image(systemName: "archivebox.circle.fill")
                                        .font(.system(size: 30))
                                    VStack(alignment: .leading) {
                                        Text("\(item.lotno)")
                                        HStack {
                                            HStack {
    //                                            Image(systemName: "scalemass.fill")
                                                Text("\((Double(item.totalkg) ?? 0).formatted(.number.grouping(.automatic).precision(.fractionLength(2)))) kgs")
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                }
//                            }
                            
                        }
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .searchable(
                        text: $searchText,
                        placement: .automatic,
                        prompt: "Search"
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
            }
        }
        .onAppear() {
            getAllBatchByWh()
            getAllBatchByWhKL()
        }
    }
    
    func getAllBatchByWh() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/getAllBatchByWh.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=\(whno)&type=1"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseData].self, from: data)

                DispatchQueue.main.async {
                    self.warehousedata = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func getAllBatchByWhKL() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/WH/getAllBatchByWh.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "whno=\(whno)&type=2"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WarehouseOverAllKl].self, from: data)

                DispatchQueue.main.async {
                    self.warehouseoverallkl = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
}

#Preview {
    WH_ViewWh(whno: "2", nobags: "")
}
