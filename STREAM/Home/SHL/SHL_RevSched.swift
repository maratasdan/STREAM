//
//  SHL_RevSched.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct ScheduleDetails: Codable, Identifiable {
    var id: String { shid }
    var shid: String
    var rhid: String
    var start: String
    var end: String
    var status: String
    var estkl: String
    var bin: String
    var seedtype: String?
    var date: String
    var dyer_line: String
    var binid: String
    var lot_no: String
    var orders: String
    var revisions: String
    var client_rep: String
    var archived: String
    var skind: String
    var prep: String
    var cftp: String
    var upload_online: String?
    var removefromsshed: String
    var stats: String
}

struct SHL_RevSched: View {
    
    let schedid: String
    
    @State private var scheduledetails: [ScheduleDetails] = []
    
    var body: some View {
        NavigationStack {
            if scheduledetails.isEmpty {
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
                    VStack {
                        Text("SHELLING/UNLOADING TEAM ACTIVITIES")
                            .font(.title2)
                            .bold()
                    }
                    .padding(20)
                    
                    Table(scheduledetails) {
                        TableColumn("Bin No", value: \.binid)
                        TableColumn("Client") { item in
                            Text("Syngenta")
                        }
                        TableColumn("Internal Batch Number", value: \.lot_no)
                        TableColumn("Qty") { item in
                            Text("\(item.estkl) kgs")
                        }
                        TableColumn("Date Closing") { item in
                            Text(formatDate(item.start))
                        }
                        .width(250)
                        TableColumn("Options") { item  in
                            NavigationLink {
                                SHL_ViewSMR(shid: item.shid, rhid: item.rhid)
                            } label: {
                                Text("View SMR")
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            getSHListReview()
        }
    }
    
    func getSHListReview() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/SHL/getSHListReview.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "schedid=\(schedid)"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([ScheduleDetails].self, from: data)

                DispatchQueue.main.async {
                    self.scheduledetails = result
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
    SHL_RevSched(schedid: "SD63212")
}
