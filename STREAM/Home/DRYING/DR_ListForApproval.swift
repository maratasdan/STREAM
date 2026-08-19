//
//  DR_ListForApproval.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI

struct DR_ListForApprovalList: Codable, Identifiable {
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

struct DR_ListForApproval: View {
    
    @State private var dr_listforapprovallist: [DR_ListForApprovalList] = []
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text("Approve Bin")
                    .font(.title)
            }
            
            Table(dr_listforapprovallist) {
                TableColumn("RHID", value: \.rhid)
                TableColumn("Hybrid", value: \.hybrid_code)
                TableColumn("Bin") { item in
                    Text("Bin \(item.bin_id)")
                }
                TableColumn("Date Created", value: \.rmf_date)
                TableColumn("") { item in
                    
                    if item.status == "0" {
                        NavigationLink(destination: DR_PreviewListForApproval(
                            rhid: item.rhid,
                            binid: item.bin_id,
                            rmf_date: item.rmf_date,
                            hybrid_code: item.hybrid_code,
                            qf: item.qf)) {
                            Text("Preview")
                        }
                    }
                    
                }
            }
        }
        .onAppear() {
            getDRListForApprovalList()
        }
    }
    
    func getDRListForApprovalList() {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/get_approval_first.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DR_ListForApprovalList].self, from: data)

                dr_listforapprovallist = result

            } catch {
                print(error)
            }

        }.resume()
        
    }
    
}

#Preview {
    DR_ListForApproval()
}
