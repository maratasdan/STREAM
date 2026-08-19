//
//  SHL_List.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct SHLSchedule: Codable, Identifiable {
    let id = UUID()

    let schedid: String
    let orders: String
    let date_created: String
    let start_date: String
    let date_end: String
    let totalhrs: String
    let status: String
    let skind: String

    enum CodingKeys: String, CodingKey {
        case schedid
        case orders
        case date_created
        case start_date
        case date_end
        case totalhrs
        case status
        case skind
    }
}

struct SHL_List: View {
    
    @State var shlschedule: [SHLSchedule] = []
    
    var body: some View {
        NavigationStack {
            if shlschedule.isEmpty {
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
                Table(shlschedule) {
                    TableColumn("SHID", value: \.schedid)
                    TableColumn("Date Created") { item in
                        Text(formatDate(item.date_created))
                    }
                    TableColumn("Status") { item in
                        if item.status == "3" {
                            Text("Ready to Shell")
                        } else if item.status == "4" {
                            Text("Operating")
                        }
                    }
                    TableColumn("") { item in
                        NavigationLink {
                            SHL_RevSched(schedid: item.schedid)
                        } label: {
                            Text("Review")
                        }
                    }
                }
            }
        }
        .onAppear() {
            getSHList()
        }
    }
    
    func getSHList() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/SHL/getSHList.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([SHLSchedule].self, from: data)

                DispatchQueue.main.async {
                    self.shlschedule = result
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy hh:mm a"

        return outputFormatter.string(from: date)
    }
    
}

#Preview {
    SHL_List()
}
