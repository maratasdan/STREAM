//
//  DR_Grid.swift
//  STREAM
//
//  Created by Dan on 9/7/26.
//

import SwiftUI

struct PanelDeviceStatusG: Codable, Identifiable {
    var id: String { dhid }
    var dhid: String
    var device_owner: String?
    var device_model: String?
    var deivice_id: String?
}


struct DryingPanelG: Codable, Identifiable {
    var id: String { dmhead.dhid }

    let dmhead: DryingHeaderG
    let dmrows: [DryingMonitoringG]
}

struct DryingHeaderG: Codable, Identifiable {
    var id: String { dhid }
    let dhid: String
    let rhid: String
    let bin_id: String
    let initial_mc: String
    let drying_start: String
    let date: String
    let device_owner: String?
    let device_model: String?
    let deivice_id: String?
    let est_drying_end: String
    let reversal: String
    let blower: String
    let hybrid_code: String
    let statis: String
    let topup_new_mc: String?
    let status: String
}

struct DryingMonitoringG: Codable, Identifiable {
    var id: String { dmrid }

    let dmrid: String
    let dhid: String
    let noh: String
    let date: String
    let time: String
    let upper: String
    let lower: String
    let boiler: String
    let mc: String
    let remarks: String?
    let status: String
}


struct DR_Grid: View {

    @State private var paneldevicestatus: [PanelDeviceStatusG] = []
    
    @State private var dryingPanels: [DryingPanelG] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color(hex: "#f2f0ec"))
                    .ignoresSafeArea()
                
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 250, maximum: 300))
                            ],
                            spacing: 20
                        ) {
                            ForEach(dryingPanels) { item in
                                VStack {
                                    ZStack {
                                        Rectangle()
                                            .frame(height: 320)
                                            .foregroundStyle(Color.white)
                                            .cornerRadius(15)
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text("Bin \(item.dmhead.bin_id)")
                                                        .bold()
                                                        .font(.system(size: 20))
                                                    Text("ID: \(item.dmhead.dhid) | \(item.dmhead.rhid)")
                                                        .font(.system(size: 13))
                                                        .foregroundStyle(Color.secondary)
                                                }
                                                .padding(.top, 5)
                                                Spacer()
                                                ZStack {
                                                    if item.dmhead.blower == "0" {
                                                        Image(systemName: "arrow.up")
                                                            .foregroundStyle(Color.blue)
                                                            .frame(width: 30, height: 30)
                                                    } else {
                                                        Image(systemName: "arrow.down")
                                                            .foregroundStyle(Color.blue)
                                                            .frame(width: 30, height: 30)
                                                    }
                                                    Rectangle()
                                                        .foregroundStyle(Color.blue.opacity(0.15))
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(30)
                                                }
                                            }
                                            .padding(.bottom, 10)
                                            
                                            Divider()
                                                .padding(.bottom, 10)
                                            
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.15))
                                                        .frame(width: 35, height: 35)
                                                    Image(systemName: "drop.fill")
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.blue)
                                                }
                                                Spacer()
                                                VStack(alignment: .leading) {
                                                    Text(String(format: "%.2f", Double(item.dmhead.initial_mc) ?? 0.0))
                                                        .bold()
                                                }
                                            }
                                            
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.indigo.opacity(0.15))
                                                        .frame(width: 35, height: 35)
                                                    Image(systemName: "arrow.up.arrow.down")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundStyle(.blue)
                                                }
                                                Spacer()
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        Text("\(item.dmrows.last?.upper ?? "")°")
                                                            .bold()
                                                            .foregroundStyle(Color.red)
                                                    }
                                                    VStack(alignment: .leading) {
                                                        Text("\(item.dmrows.last?.lower ?? "")°")
                                                            .foregroundStyle(Color.blue)
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.green.opacity(0.15))
                                                        .frame(width: 35, height: 35)
                                                    Image(systemName: "leaf.fill")
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.green)
                                                }
                                                Spacer()
                                                VStack(alignment: .leading) {
                                                    Text("\(item.dmhead.hybrid_code)")
                                                        .bold()
                                                }
                                            }
                                            
                                            Divider()
                                                .padding(.bottom, 10)
                                            
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.orange.opacity(0.15))
                                                        .frame(width: 35, height: 35)
                                                    Image(systemName: "clock")
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.orange)
                                                }
                                                Spacer()
                                                VStack(alignment: .leading) {
                                                    if item.dmhead.statis == "2" {
                                                        Text("DOWNTIME")
                                                            .bold()
                                                            .foregroundStyle(Color.red)
                                                    } else {
                                                        Text("\(countdown(from: item.dmrows.last?.date ?? ""))")
                                                            .bold()
                                                            .foregroundStyle(Color.blue)
                                                    }
                                                }
                                            }
                                            
                                            HStack {
                                                
                                                
                                                Spacer()
                                                
                                                if item.dmhead.deivice_id == nil ||
                                                    item.dmhead.device_model == nil ||
                                                    item.dmhead.device_owner == nil
                                                {
                                                    Text("Migrate Now")
                                                        .foregroundStyle(Color.green)
                                                        .padding(.horizontal, 3)
                                                        .cornerRadius(50)
                                                } else {
                                                    
                                                    
                                                    
                                                    if item.dmhead.deivice_id == UIDevice.current.identifierForVendor?.uuidString {
                                                        Spacer()
                                                        HStack {
                                                            Text("This Device")
                                                            Image(systemName: "checkmark.circle.fill")
                                                                .foregroundStyle(Color.green)
                                                        }
                                                        .foregroundStyle(Color.orange)
                                                        .padding(.horizontal, 3)
                                                        .cornerRadius(50)
                                                    } else {
                                                        Text("\(item.dmhead.device_owner ?? "")")
                                                            .foregroundStyle(Color.orange)
                                                            .padding(.horizontal, 3)
                                                            .cornerRadius(50)
                                                    }
                                                    
                                                }
                                                
                                                if item.dmhead.status == "4_T" {
                                                    HStack {
                                                        Text("Topup Now!")
                                                            .foregroundStyle(Color.orange)
                                                            .padding(.horizontal, 3)
                                                            .background(Color.yellow.opacity(0.15))
                                                            .cornerRadius(50)
                                                    }
                                                } else if item.dmhead.status == "4_TC" {
                                                    HStack {
                                                        Text("Topup Comfirmation")
                                                            .foregroundStyle(Color.orange)
                                                            .padding(.horizontal, 3)
                                                            .background(Color.yellow.opacity(0.15))
                                                            .cornerRadius(50)
                                                    }
                                                }
                                                
                                            }
                                            .font(.footnote)
                                            .foregroundStyle(Color.secondary)
                                            
                                            Spacer()
                                        }
                                        .padding(20)
                                    }
                                }
                                .frame(width: 270, height: 320)
                                .contextMenu {
                                    if item.dmhead.deivice_id == nil {
                                        
                                        Button(action: {
//                                            migrateData(dhid: item.dmhead.dhid)
//                                            saveDataLocal(dhid: item.dmhead.dhid)
                                        }) {
                                            HStack {
                                                Image(systemName: "icloud.and.arrow.down.fill")
                                                    .tint(Color.blue)
                                                Text("Migrate Now")
                                            }
                                        }
                                        
                                        Button(action: {
//                                            openShutOffMCAlert = true
//                                            currentrhid = item.dmhead.rhid
                                        }) {
                                            HStack {
                                                Image(systemName: "power.circle.fill")
                                                    .tint(Color.red)
                                                Text("Shut Off")
                                            }
                                        }
                                        
                                    } else {
                                        
                                        if item.dmhead.status == "4_T" {
                                            Button(action: {
//                                                let rhid = item.dmhead.rhid
//                                                crhid = rhid
//                                                
//                                                print("CRHID SET:", crhid)
//                                                
//                                                DispatchQueue.main.async {
//                                                    openConfirmAlert = true
//                                                }
                                            }) {
                                                Image(systemName: "square.and.arrow.down.fill")
                                                    .tint(Color.yellow)
                                            }
                                        } else {
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        .onAppear {
                            loadDrDataOnine()
                        }
                        .task {
                            while !Task.isCancelled {
                                loadDrDataOnine()
                                try? await Task.sleep(for: .seconds(1))
                            }
                        }
                    
                }
                .padding(20)
            }
            
        }
    }
    
    func loadDrDataOnine() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/get_current_drying.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryingPanelG].self, from: data)
//                print("DS: \(result)")
                DispatchQueue.main.async {
                    dryingPanels = result
                }
            } catch {
                print("Errorsx")
            }

        }.resume()
        
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
    DR_Grid()
}
