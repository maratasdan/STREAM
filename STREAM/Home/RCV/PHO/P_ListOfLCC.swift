//
//  P_ListOfLCC.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI

struct P_ListForLCC: Codable, Identifiable {
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

struct P_ListOfLCC: View {
    
    @State private var plistforlcc: [P_ListForLCC] = []
    
    var body: some View {
        NavigationStack {
            Table(plistforlcc) {
                TableColumn("RHID", value: \.rhid)
                TableColumn("Dryer Line", value: \.dryer_line)
                TableColumn("Bin", value: \.bin_id)
                TableColumn("Hybrid Code", value: \.hybrid_code)
                TableColumn("") { item in
                    NavigationLink(destination: P_LCPreview(
                        rhid: item.rhid,
                        dryer_line: item.dryer_line,
                        bin_id: item.bin_id,
                        rmf_date: item.rmf_date
                    )) {
                        HStack {
                            Text("Preview")
                            Image(systemName: "arrow.forward")
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
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/get_lcc_list.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([P_ListForLCC].self, from: data)

                plistforlcc = result

            } catch {
                print(error)
            }

        }.resume()
        
    }
}

#Preview {
    P_ListOfLCC()
}
