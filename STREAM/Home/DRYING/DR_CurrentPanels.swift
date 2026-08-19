//
//  DR_CurrentPanels.swift
//  STREAM
//
//  Created by Danxd on 7/24/26.
//

import SwiftUI
import SwiftData

struct DR_CurrentPanels: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var dryingheader: [tbl_drying_header]
    @Query private var dyringmonitoring: [tbl_drmonitoring_rows]
    
    @State private var searchText = ""
    
    var filteredItemSearch: [tbl_drying_header] {
        
        if searchText.isEmpty {
            return dryingheader
        }
        
        return dryingheader.filter {
            $0.bin_id.localizedCaseInsensitiveContains(searchText)
        }
        
    }

    var body: some View {
        NavigationStack {
            
            if dryingheader.isEmpty {
                VStack {
                    Text("Empty")
                }
            } else {
                List(filteredItemSearch) { item in
                    NavigationLink(destination: DR_CurrentPanelsDetails(dhid: item.dhid)) {
                        HStack {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange.opacity(0.15))
                                        .frame(width: 58, height: 58)
                                    
                                    Image(systemName: "flame.fill")
                                        .font(.title2)
                                        .foregroundStyle(.orange)
                                }
                                VStack(alignment: .leading) {
                                    Text("Bin \(item.bin_id)")
                                        .font(.title)
                                        .bold()
                                    Text("ID: \(item.dhid)")
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                            .padding()
                            .frame(width: 200)
                            
                            Divider()
                            VStack(alignment: .leading) {
                                HStack {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 45, height: 45)
                                            Image(systemName: "drop.fill")
                                                .font(.title2)
                                                .foregroundStyle(.blue)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("\(item.initial_mc)")
                                                .bold()
                                            Text("Inital MC")
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }
                                    .padding()
                                    
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.indigo.opacity(0.15))
                                                .frame(width: 45, height: 45)
                                            Image(systemName: "arrow.up.arrow.down")
                                                .font(.title2)
                                                .foregroundStyle(.indigo)
                                        }
                                        HStack {
                                            
                                            if let row = dyringmonitoring
                                                .filter ({ $0.dhid == item.dhid })
                                                .sorted(by: { $0.date > $1.date })
                                                .first {
                                                
                                                VStack(alignment: .leading) {
                                                    Text("\(row.upper)")
                                                        .bold()
                                                    Text("Top")
                                                        .foregroundStyle(Color.secondary)
                                                }
                                                Divider()
                                                VStack(alignment: .leading) {
                                                    Text("\(row.lower)")
                                                        .bold()
                                                    Text("Bot")
                                                        .foregroundStyle(Color.secondary)
                                                }
                                            }
                                    
                                        }
                                        
                                    }
                                    .padding()
                                    
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.green.opacity(0.15))
                                                .frame(width: 45, height: 45)
                                            Image(systemName: "leaf.fill")
                                                .font(.title2)
                                                .foregroundStyle(.green)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("\(item.hybrid)")
                                                .bold()
                                            Text("Hybrid")
                                                .foregroundStyle(Color.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 200)
                                      
                                    HStack {
                                        
                                        if item.statis == "2" {
                                            VStack(alignment: .leading) {
                                                Text("DOWNTIME")
                                                    .font(.system(size: 35))
                                                    .bold()
                                                    .foregroundStyle(Color.red)
                                            }
                                        } else {
                                            if let itemtimer = dyringmonitoring
                                                .filter ({ $0.dhid == item.dhid })
                                                .sorted (by: { $0.date > $1.date })
                                                .first {
                                                VStack(alignment: .leading) {
                                                    Text("\(countdown(from: itemtimer.date))")
                                                        .font(.system(size: 40))
                                                        .bold()
                                                        .foregroundStyle(Color.blue)
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    .padding()
                                }
                            } 
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search Bin")
            }
            
        }
        .searchable(text: $searchText, prompt: "Search Bin")
    }
    
    func countdown(from dateString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let savedDate = formatter.date(from: dateString) else {
            return "--:--:--"
        }

        let expiryDate = savedDate.addingTimeInterval(3600)

        let remaining = Int(expiryDate.timeIntervalSince(Date()))

        if remaining <= 0 {
            return "Timers Up!"
        }

        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

#Preview {
    DR_CurrentPanels()
}
