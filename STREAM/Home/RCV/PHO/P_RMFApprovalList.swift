//
//  P_RMFApprovalList.swift
//  STREAM
//
//  Created by Danxd on 7/23/26.
//

import SwiftUI

struct DryerRecord: Codable, Identifiable {
    var id: String { rhid }
    var rhid: String
    var lot_number: String
    var dryer_line: String
    var bin_id: String
    var rmf_date: String
    var hybrid_code: String
    var qf: String
    var status: String
}

struct P_RMFApprovalList: View {
    
    @State private var dryerrecords: [DryerRecord] = []
    
    var body: some View {
        NavigationStack {
            Table(dryerrecords) {
                TableColumn("RHID", value: \.rhid)
                TableColumn("Lot Number", value: \.lot_number)
                TableColumn("Date", value: \.rmf_date)
                TableColumn("Bin", value: \.bin_id)
                TableColumn("") { item in
                    NavigationLink(destination: P_RMFApproveNow(rhid: item.rhid)) {
                        Text("Preview")
                    }
                }
            }
        }
        .onAppear() {
            getForDryingRMFApproval()
        }
    }
    
    func getForDryingRMFApproval() {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/PHO/get_rmf_approval_list.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryerRecord].self, from: data)

                dryerrecords = result

            } catch {
                print(error)
            }

        }.resume()
        
    }
}

#Preview {
    P_RMFApprovalList()
}
