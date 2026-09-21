//
//  WH_WHList.swift
//  STREAM
//
//  Created by Dan on 9/21/26.
//

import SwiftUI

struct WHListDetails: Codable, Identifiable {
    var id: String { rhid }
    var rhid: String
    var lotnumber: String
    var wh: String
    var binno: String
    var datetransfer: String
    var prepared: String
    var verified: String
}

struct WH_WHList: View {
    
    let wh: String
    
    @State private var searchText: String = ""
    
    @State private var whlistdetails: [WHListDetails] = []
    
    var filteredWHList: [WHListDetails] {
        if searchText.isEmpty {
            return whlistdetails
        }
        
        return whlistdetails.filter {
            $0.lotnumber.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredWHList) { item in
                if item.wh == wh {
                    HStack {
                        fieldIcon("bag")
                        VStack(alignment: .leading) {
                            Text("\(item.lotnumber)")
                            HStack {
                                Text("\(item.datetransfer)")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                } else {
                    HStack {
                        fieldIcon("face.smiling.inverse")
                        VStack(alignment: .leading) {
                            Text("Empty Fields")
                        }
                    }
                }
            }
        }
        .onAppear() {
            getWHListDetails()
        }
    }
    
    @ViewBuilder
    private func fieldIcon(_ systemName: String) -> some View {

        ZStack {

            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.15))
                .frame(width: 40, height: 40)

            Image(systemName: systemName)
                .foregroundStyle(.green)
        }
    }
    
    func getWHListDetails() {
        guard let encodedWH = wh.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else { return }

        let urlString = "https://ops.stellarseedscorp.org/App/Warehouse/v2/get_whlist_details.php?wh=\(encodedWH)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WHListDetails].self, from: data)

                DispatchQueue.main.async {
                    whlistdetails = result
                }
            } catch {
                print("JSON Decoding Error: \(error)")
            }
        }.resume()
    }
}

#Preview {
    WH_WHList(wh: "1")
}
