//
//  CND_Monitoring.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct ConditioningSchedule: Codable, Identifiable {
    var id: String { cndshid }
    var cndshid: String
    var orders: String
    var date_created: String
    var start_date: String
    var end_date: String
    var totalhrs: String
    var status: String
    var skind: String
    var flag: String?
}

struct CND_Monitoring: View {
    
    @State private var conditioningsched: [ConditioningSchedule] = []
    
    var body: some View {
        NavigationStack {
            if conditioningsched.isEmpty {
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
                    
                    Table(conditioningsched) {
                        TableColumn("ID", value: \.cndshid)
                        TableColumn("Date Creared", value: \.date_created)
                        TableColumn("Hybrid") { item in
                            Text("\(item.flag ?? "NA")")
                        }
                        TableColumn("") { item in
                            NavigationLink {
                                CND_List(cndshid: item.cndshid)
                            } label: {
                                Text("Review")
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
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/CND/getCNDMonitoring.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([ConditioningSchedule].self, from: data)

                DispatchQueue.main.async {
                    self.conditioningsched = result
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}

#Preview {
    CND_Monitoring()
}
