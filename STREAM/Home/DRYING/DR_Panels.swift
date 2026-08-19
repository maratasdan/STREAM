//
//  DR_Panels.swift
//  STREAM
//
//  Created by Danxd on 7/24/26.
//

import SwiftUI
import SwiftData
internal import Combine

struct PanelDeviceStatus: Codable, Identifiable {
    var id: String { dhid }
    var dhid: String
    var device_owner: String?
    var device_model: String?
    var deivice_id: String?
}


struct DryingPanel: Codable, Identifiable {
    var id: String { dmhead.dhid }

    let dmhead: DryingHeader
    let dmrows: [DryingMonitoring]
}

struct DryingHeader: Codable, Identifiable {
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

struct DryingMonitoring: Codable, Identifiable {
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


struct DR_Panels: View {
    
    @State private var goToDryingDetails: Bool = false
    @State private var goToAppriveDrying: Bool = false
    @State private var goToPanels: Bool = false
    @State private var goToCurrentPannels: Bool = false
    
    @State private var openShutOffMCAlert: Bool = false
    @State private var openShutOffMCSheet: Bool = false
    @State private var shuttoffmc: String = ""
    @State private var errormsg: String = ""
    @State private var displayProgress: Bool = false
    @State private var currentrhid: String = ""
    
    @State private var openConfirmAlert: Bool = false
    
    @State private var notifiedBins: Set<String> = []
    
    @Environment(\.modelContext) private var context
    
    @State private var currentDate = Date()
    
    @State private var crhid: String = ""

    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    @State private var localdrheader: [tbl_drying_header] = []
    @State private var paneldevicestatus: [PanelDeviceStatus] = []
    
    @State private var dryingPanels: [DryingPanel] = []
    
    var dryingPanelsSearch: [DryingPanel] {
        if searchText.isEmpty {
            return dryingPanels
        }
        
        return dryingPanels.filter {
            $0.dmhead.bin_id.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @State private var searchText = ""
    
    @Query private var userdata: [tbl_login]
    
    var body: some View {
        NavigationStack {
            
            if dryingPanels.isEmpty {
                Text("No Data")
            } else {
                List {
                    
                    Section {
                        HStack(spacing: 8) {
                            Spacer()
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)

                                TextField("Search Bin", text: $searchText)

                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(10)
//                        .background(Color(.systemGray6))
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .listRowBackground(Color.clear)
                    }
                    
                    ForEach(dryingPanelsSearch) { item in
                        
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
                                    Text("Bin \(item.dmhead.bin_id)")
                                        .font(.title)
                                        .bold()
                                    Text("ID: \(item.dmhead.dhid)")
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
                                            Text("\(item.dmhead.initial_mc)")
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
                                            VStack(alignment: .leading) {
                                                Text("\(item.dmrows.last?.upper ?? "")")
                                                    .bold()
                                                Text("Top")
                                                    .foregroundStyle(Color.secondary)
                                            }
                                            Divider()
                                            VStack(alignment: .leading) {
                                                Text("\(item.dmrows.last?.lower ?? "")")
                                                    .bold()
                                                Text("Bot")
                                                    .foregroundStyle(Color.secondary)
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
                                            Text("\(item.dmhead.hybrid_code)")
                                                .bold()
                                            Text("Hybrid")
                                                .foregroundStyle(Color.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 200)
                                    
                                    HStack {
                                        ZStack {
                                            if item.dmhead.blower == "0" {
                                                Image(systemName: "arrow.up")
                                                    .foregroundStyle(Color.blue)
                                                    .font(.title)
                                            } else {
                                                Image(systemName: "arrow.down")
                                                    .foregroundStyle(Color.blue)
                                                    .font(.title)
                                            }
                                            Rectangle()
                                                .foregroundStyle(Color.blue.opacity(0.15))
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(30)
                                        }
                                        VStack(alignment: .leading) {
                                            
                                            if item.dmhead.statis == "2" {
                                                Text("DOWNTIME")
                                                    .font(.system(size: 35))
                                                    .bold()
                                                    .foregroundStyle(Color.red)
                                            } else {
                                                Text("\(countdown(from: item.dmrows.last?.date ?? ""))")
                                                    .font(.system(size: 40))
                                                    .bold()
                                                    .foregroundStyle(Color.blue)
                                            }
                                        }
                                    }
                                    .padding()
                                    .task {
                                        
                                        while !Task.isCancelled {
                                            
                                            checkNotifications()
                                            
                                            try? await Task.sleep(for: .seconds(1))
                                        }
                                        
                                    }
                                }
                                HStack {
                                    
                                    if item.dmhead.deivice_id == nil ||
                                        item.dmhead.device_model == nil ||
                                        item.dmhead.device_owner == nil
                                    {
                                        Text("The bin is free to migrate.")
                                            .foregroundStyle(Color.green)
                                            .padding(.horizontal, 3)
                                            .background(Color.green.opacity(0.15))
                                            .cornerRadius(50)
                                    } else {
                                        
                                        Text("Operator: \(item.dmhead.device_owner ?? "")")
                                            .foregroundStyle(Color.orange)
                                            .padding(.horizontal, 3)
                                            .cornerRadius(50)
                                        Divider()
                                        Text("Model: \(item.dmhead.device_model ?? "")")
                                            .foregroundStyle(Color.orange)
                                            .padding(.horizontal, 3)
                                            .cornerRadius(50)
                                        Divider()
                                        if item.dmhead.deivice_id == UIDevice.current.identifierForVendor?.uuidString {
                                            HStack {
                                                Text("This Device")
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(Color.green)
                                            }
                                            .foregroundStyle(Color.orange)
                                            .padding(.horizontal, 3)
                                            .cornerRadius(50)
                                        } else {
                                            
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
                                .padding(.leading)
                                
                                
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            
                            if item.dmhead.status == "4_T" {
                                Button(action: {
                                    crhid = item.dmhead.rhid
                                    openConfirmAlert = true
                                }) {
                                    Image(systemName: "square.and.arrow.down.fill")
                                        .tint(Color.yellow)
                                }
                            } else {
                                if item.dmhead.deivice_id == nil {
                                    
                                    Button(action: {
                                        migrateData(dhid: item.dmhead.dhid)
                                        saveDataLocal(dhid: item.dmhead.dhid)
                                    }) {
                                        Image(systemName: "icloud.and.arrow.down.fill")
                                            .tint(Color.blue)
                                    }
                                    
                                    Button(action: {
                                        openShutOffMCAlert = true
                                        currentrhid = item.dmhead.rhid
                                    }) {
                                        Image(systemName: "power.circle.fill")
                                            .tint(Color.red)
                                    }
                                    
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
                
                .navigationDestination(isPresented: $goToAppriveDrying) {
                    DR_ApproveDrying()
                }
                .navigationDestination(isPresented: $goToPanels) {
                    DR_Panels()
                }
                .navigationDestination(isPresented: $goToCurrentPannels) {
                    DR_CurrentPanels()
                }
                .navigationDestination(isPresented: $openConfirmAlert) {
                    DR_ConfirmTopup(rhid: crhid)
                }
                
                .sheet(isPresented: $openShutOffMCSheet) {
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("Shutoff MC")
                                .font(.title)
                            Text("\(errormsg)")
                                .font(.footnote)
                                .foregroundStyle(Color.red)
                            VStack {
                                TextField("Enter MC", text: $shuttoffmc)
                                    .padding(10)
                            }
                            .background(Color.secondary.opacity(0.15))
                            .cornerRadius(10)
                            
                            HStack {
                                Spacer()
                                
//                                if displayProgress {
//                                    
//                                    HStack {
//                                        ProgressView()
//                                            .scaleEffect(1)
//                                        Text("Please wait...")
//                                    }
//                                    .padding(.top, 10)
//                                    
//                                } else {
                                    
                                    Button(action: {
                                        if shuttoffmc.isEmpty {
                                            errormsg = "Please enter shutoff mc"
                                        } else {
                                            displayProgress = true
                                            goShutoffMC(mc: shuttoffmc, crrhid: currentrhid)
                                        }
                                    }) {
                                        Label("Submit", systemImage: "power.circle")
                                            .padding(5)
                                    }
                                    .buttonStyle(.glassProminent)
                                    .tint(Color.red)
//                                }
                                
                            }
                        }
                        .presentationDetents([.medium])
                        .padding(20)
                    }
                }
                
                .alert("Confirmation", isPresented: $openShutOffMCAlert) {
                    Button("Cancel", role: .close) { }
                    Button("Confirm", role: .confirm) {
                        openShutOffMCSheet = true
                    }
                } message: {
                    Text("Are you sure to shutoff this bin?")
                }
                
            }
        }
//      MARK: Search Box
        .searchable(text: $searchText, prompt: "Search Bin")
        
        .onAppear() {
            loadData()
            loadDrDataOnine()
        }
        .task {
            while !Task.isCancelled {
                loadDrDataOnine()
                try? await Task.sleep(for: .seconds(1))
            }
        }
        
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    goToAppriveDrying = true
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    goToPanels = true
                }) {
                    Image(systemName: "flame.circle")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    goToCurrentPannels = true
                }) {
                    Image(systemName: "flame.circle.fill")
                }
            }
        }
    }
    
    func goShutoffMC(mc: String, crrhid: String) {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/shutoff_mc.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "mc": mc,
            "rhid": crrhid
        ] as [String : Any]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                if String(data: data, encoding: .utf8) == "updated" {
                    displayProgress = false
                    shuttoffmc = ""
                    crhid = ""
                    openShutOffMCSheet = false
                } else {
                    errormsg = "Error or Please check internet connection";
                }
            } else {
                print("Error")
            }
        }.resume()
        
    }
    
    
    func checkNotifications() {

        for item in dryingPanels {

            let remaining = countdown(from: item.dmrows.last?.date ?? "")

            if remaining == "00:00:00" {

                print("Hello \(item.dmhead.bin_id)")
                
                if !notifiedBins.contains(item.dmhead.bin_id) {

                    notifiedBins.insert(item.dmhead.bin_id)

                    NotificationManager.shared.sendNotification(
                        bin: item.dmhead.bin_id
                    )

                }

            }

        }

    }
    
    func migrateData(dhid: String) {
        
        let devicename = "\(userdata.first?.firstname ?? "NA") \(userdata.first?.lastname ?? "NA")"
        let deviceid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let devicemodel = UIDevice.current.model
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/migratedata.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "dhid": dhid,
            "devicename": devicename,
            "deviceid": deviceid,
            "devicemodel": devicemodel
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                loadData()
                loadDrDataOnine()
//                print(String(data: data, encoding: .utf8) ?? "")
                
            }
        }.resume()
    }
    
    func saveDataLocal(dhid: String) {
        
        let descriptor = FetchDescriptor<tbl_drying_header>(
            predicate: #Predicate { $0.dhid == dhid }
        )
        
        let descriptorrows = FetchDescriptor<tbl_drmonitoring_rows>(
            predicate: #Predicate { $0.dhid == dhid }
        )

        do {
            let result = try context.fetch(descriptor)

            if let header = result.first {
                context.delete(header)
                
                let resultrows = try context.fetch(descriptorrows)
                
                for row in resultrows {
                    context.delete(row)
                }
                try context.save()
                print("Deleted DB")
//                print("Existed! \(header.dhid)")
                
                
            } else {
                
               if  let getHeaderOnline = dryingPanels.first(where: { $0.dmhead.dhid == dhid }) {
                   
                   let insertHeader = tbl_drying_header(
                    dhid: getHeaderOnline.dmhead.dhid,
                    rhid: getHeaderOnline.dmhead.rhid,
                    initial_mc: getHeaderOnline.dmhead.initial_mc,
                    drying_start: getHeaderOnline.dmhead.drying_start,
                    est_drying_end: getHeaderOnline.dmhead.est_drying_end,
                    reversal: getHeaderOnline.dmhead.reversal,
                    blower: getHeaderOnline.dmhead.blower,
                    bin_id: getHeaderOnline.dmhead.bin_id,
                    hybrid: getHeaderOnline.dmhead.hybrid_code,
                    statis: getHeaderOnline.dmhead.statis,
                    topup_new_mc: getHeaderOnline.dmhead.topup_new_mc
                   )
                   
                   do {
                       context.insert(insertHeader)
                       
                       for rows in getHeaderOnline.dmrows {
                           
                           let dmrows = tbl_drmonitoring_rows(
                            dmid: rows.dmrid,
                            dhid: rows.dhid,
                            noh: rows.noh,
                            date: rows.date,
                            time: rows.time,
                            upper: rows.upper,
                            lower: rows.lower,
                            boiler: rows.boiler,
                            mc: rows.mc,
                            status: rows.status,
                            remarks: rows.remarks
                           )
                           
                           context.insert(dmrows)
                           
                       }
                       
                       try context.save()
                       print("Local Data Saved!")
                       
                   } catch {
                       print("Local Dryer Header Error!")
                   }
                   
                }
                
                
                
            }

        } catch {
            print("Error: \(error)")
        }
        
        
    }
    
    func loadData() {
        let descriptor = FetchDescriptor<tbl_drying_header>()

        do {
            localdrheader = try context.fetch(descriptor)

            localdrheader.sort {
                Int($0.bin_id) ?? 0 < Int($1.bin_id) ?? 0
            }

        } catch {
            print("Error fetching")
        }
    }
    
    func loadDrDataOnine() {
        
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/DR/get_current_drying.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryingPanel].self, from: data)
//                print("DS: \(result)")
                dryingPanels = result

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
    DR_Panels()
}
