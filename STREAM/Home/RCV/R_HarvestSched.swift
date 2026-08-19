//
//  R_HarvestSched.swift
//  STELLAR SIMULATOR
//
//  Created by danxd on 7/3/26.
//

import SwiftUI

struct HarvestSched: Codable, Identifiable {
    
    var id: String { hidc }
    var hidc: String
    var harvest_id: String
    var hybrid_code: String
    var quality_flagging: String
    var growers_name: String
    var status: String
    var skind: String
    
}

struct R_HarvestSched: View {
    
    @State private var harvestsched: [HarvestSched] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Table(harvestsched) {
                    TableColumn("Harvest ID", value: \.harvest_id)
                    TableColumn("Hybird Code", value: \.hybrid_code)
                    TableColumn("Quality Flagging", value: \.quality_flagging)
                    TableColumn("Growers Name", value: \.growers_name)
                }
            }
        }
        .onAppear() {
            getHarvestSched()
        }
    }
    
    func getHarvestSched() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/RCV/GetHarvestSched.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([HarvestSched].self, from: data)

                DispatchQueue.main.async {
                    self.harvestsched = result
                }
            } catch {
                print(error)
            }
        }.resume()
    }
        
}

#Preview {
    R_HarvestSched()
}
