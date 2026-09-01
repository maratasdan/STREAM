//
//  DR_ApproveDrying.swift
//  STREAM
//
//  Created by Danxd on 7/23/26.
//

import SwiftUI

struct ApproveDryingList: Codable, Identifiable {
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

struct DR_ApproveDrying: View {
    
    @State private var approvedryinglist: [ApproveDryingList] = []
    @State private var goToStartDryingPreview: Bool = false
    
    @State private var selectedRHID: String = ""
    @State private var selectedBin: String = ""
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text("Approve Drying")
                    .font(.title)
            }
            
            Table(approvedryinglist) {
                TableColumn("RHID", value: \.rhid)
                    .width(100)
                TableColumn("Lot Number", value: \.lot_number)
                TableColumn("Bin", value: \.bin_id)
                TableColumn("Date Created", value: \.rmf_date)
                TableColumn("") { item in
                    Menu {
                        Button(action: {
                            print("Hello")
                            selectedRHID = item.rhid
                            goToStartDryingPreview = true
                        }) {
                            Label("Start Drying", systemImage: "checkmark.circle")
                                .tint(Color.green)
                        }
                        .buttonStyle(.glassProminent)
                        .glassEffect()
                        
                        Button(action: {
                            
                        }) {
                            Label("Decline", systemImage: "x.circle")
                                .tint(Color.red)
                        }
                        .buttonStyle(.glassProminent)
                        .glassEffect()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(isPresented: $goToStartDryingPreview) {
                DR_StartDryingReview(rhid: selectedRHID)
            }
        }
        .onAppear() {
            getApproveDrying()
        }
        
    }
    
    func getApproveDrying() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/getApproveDrying.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode([ApproveDryingList].self, from: data)
                
                DispatchQueue.main.async {
                    approvedryinglist = result
                    print(result)
                    print("--------------------------")
                }
                
            } catch {
                print(error)
            }
        }
        .resume()
        
    }
}

#Preview {
    DR_ApproveDrying()
}
