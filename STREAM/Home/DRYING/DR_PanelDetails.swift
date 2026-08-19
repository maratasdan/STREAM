//
//  DR_PanelDetails.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 6/26/26.
//

import SwiftUI
import WebKit
internal import Combine

struct DryingData: Codable, Identifiable {
    var id: String { noh }
    var noh: String
    var date: String
    var time: String
    var top: String
    var bot: String
    var mc: String
    var remarks: String
}

struct DryingDataOnline: Codable, Identifiable {
    var id: String { dmid }
    var dmid: String
    var dhid: String
    var noh: String
    var date: String
    var time: String
    var upper: String
    var lower: String
    var mc: String
    var remarks: String
    var status: String
}

struct DryingDataOnlineHead: Codable, Identifiable {
    var id: String { rhid }
    var rhid: String
    var binid: String
    var lot_no: String
    var start: String
    var end: String
    var initial_mc: String
}

struct DR_PanelDetails: View {
    
    let rhid: String
    let dhid: String
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    @State private var showAddData: Bool = false
    
    @State private var noh: String = ""
    @State private var date: String = ""
    @State private var time: String = ""
    @State private var top: String = ""
    @State private var bot: String = ""
    @State private var mc: String = ""
    @State private var remarks: String = ""
    
    @State private var dryingdataonline: [DryingDataOnline] = []
    @State private var dryingdataonlinehead: [DryingDataOnlineHead] = []
    
    @State private var dryingdata: [DryingData] = [
        DryingData(noh: "01:00:00", date: "Wed Mar 18", time: "15:31:11", top: "32", bot: "25", mc: "13.5", remarks: "Normal"),
        DryingData(noh: "02:00:00", date: "Wed Mar 18", time: "16:31:11", top: "33", bot: "26", mc: "13.3", remarks: "Normal"),
        DryingData(noh: "03:00:00", date: "Wed Mar 18", time: "17:31:11", top: "34", bot: "27", mc: "13.1", remarks: "Normal"),
        DryingData(noh: "04:00:00", date: "Wed Mar 18", time: "18:31:11", top: "35", bot: "28", mc: "12.9", remarks: "Normal"),
        DryingData(noh: "05:00:00", date: "Wed Mar 18", time: "19:31:11", top: "36", bot: "29", mc: "12.8", remarks: "Good"),
        DryingData(noh: "06:00:00", date: "Wed Mar 18", time: "20:31:11", top: "37", bot: "30", mc: "12.6", remarks: "Good"),
        DryingData(noh: "07:00:00", date: "Wed Mar 18", time: "21:31:11", top: "38", bot: "31", mc: "12.5", remarks: "Good"),
        DryingData(noh: "08:00:00", date: "Wed Mar 18", time: "22:31:11", top: "39", bot: "32", mc: "12.4", remarks: "Normal"),
        DryingData(noh: "09:00:00", date: "Wed Mar 18", time: "23:31:11", top: "40", bot: "33", mc: "12.2", remarks: "Normal"),
        DryingData(noh: "10:00:00", date: "Thu Mar 19", time: "00:31:11", top: "41", bot: "34", mc: "12.0", remarks: "Normal"),
        DryingData(noh: "11:00:00", date: "Thu Mar 19", time: "01:31:11", top: "42", bot: "35", mc: "11.9", remarks: "Stable"),
        DryingData(noh: "12:00:00", date: "Thu Mar 19", time: "02:31:11", top: "43", bot: "36", mc: "11.8", remarks: "Stable"),
        DryingData(noh: "13:00:00", date: "Thu Mar 19", time: "03:31:11", top: "44", bot: "37", mc: "11.7", remarks: "Stable"),
        DryingData(noh: "14:00:00", date: "Thu Mar 19", time: "04:31:11", top: "45", bot: "38", mc: "11.6", remarks: "Stable"),
        DryingData(noh: "15:00:00", date: "Thu Mar 19", time: "05:31:11", top: "46", bot: "39", mc: "11.5", remarks: "Good"),
        DryingData(noh: "16:00:00", date: "Thu Mar 19", time: "06:31:11", top: "47", bot: "40", mc: "11.4", remarks: "Good"),
        DryingData(noh: "17:00:00", date: "Thu Mar 19", time: "07:31:11", top: "48", bot: "41", mc: "11.3", remarks: "Good"),
        DryingData(noh: "18:00:00", date: "Thu Mar 19", time: "08:31:11", top: "49", bot: "42", mc: "11.2", remarks: "Normal"),
        DryingData(noh: "19:00:00", date: "Thu Mar 19", time: "09:31:11", top: "50", bot: "43", mc: "11.1", remarks: "Normal"),
        DryingData(noh: "20:00:00", date: "Thu Mar 19", time: "10:31:11", top: "51", bot: "44", mc: "11.0", remarks: "Normal"),
        DryingData(noh: "21:00:00", date: "Thu Mar 19", time: "11:31:11", top: "52", bot: "45", mc: "10.9", remarks: "Monitor"),
        DryingData(noh: "22:00:00", date: "Thu Mar 19", time: "12:31:11", top: "53", bot: "46", mc: "10.8", remarks: "Monitor"),
        DryingData(noh: "23:00:00", date: "Thu Mar 19", time: "13:31:11", top: "54", bot: "47", mc: "10.7", remarks: "Monitor"),
        DryingData(noh: "24:00:00", date: "Thu Mar 19", time: "14:31:11", top: "55", bot: "48", mc: "10.6", remarks: "Monitor"),
        DryingData(noh: "25:00:00", date: "Thu Mar 19", time: "15:31:11", top: "56", bot: "49", mc: "10.5", remarks: "Done"),
        DryingData(noh: "26:00:00", date: "Thu Mar 19", time: "16:31:11", top: "57", bot: "50", mc: "10.4", remarks: "Done"),
        DryingData(noh: "27:00:00", date: "Thu Mar 19", time: "17:31:11", top: "58", bot: "51", mc: "10.3", remarks: "Done"),
        DryingData(noh: "28:00:00", date: "Thu Mar 19", time: "18:31:11", top: "59", bot: "52", mc: "10.2", remarks: "Done"),
        DryingData(noh: "29:00:00", date: "Thu Mar 19", time: "19:31:11", top: "60", bot: "53", mc: "10.1", remarks: "Done"),
        DryingData(noh: "30:00:00", date: "Thu Mar 19", time: "20:31:11", top: "61", bot: "54", mc: "10.0", remarks: "Completed")
    ]
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 20) {
                        VStack {
                            List {
                                Section {
                                    VStack(alignment: .center) {
                                        HStack(spacing: 20) {
                                            VStack {
                                                Text(remainingTime(for: dryingdataonline.first?.date ?? "NA"))
                                                    .font(.system(size: 40))
                                            }
                                            .frame(maxWidth: .infinity)
                                            
                                            VStack {
                                                Image(systemName: "arrow.up.circle")
                                                    .font(.system(size: 35))
                                                    .foregroundColor(Color(hex: "#0041BA"))
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                                Section {
                                    HStack(alignment: .top) {
                                        Image(systemName: "calendar.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA"))
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(currentTime)")
                                            Text("Current Date & Time")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image(systemName: "calendar.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA"))
                                        
                                        VStack(alignment: .leading) {
                                            Text(formatDate(dryingdataonlinehead.first?.start ?? "NA"))
                                            Text("Start")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image(systemName: "calendar.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA").opacity(0.6))
                                        
                                        VStack(alignment: .leading) {
                                            Text(formatDate(dryingdataonlinehead.first?.end ?? "NA"))
                                            Text("Est. End")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image(systemName: "archivebox.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA").opacity(1))
                                        
                                        VStack(alignment: .leading) {
                                            Text(dryingdataonlinehead.first?.binid ?? "NA")
                                            Text("Bin")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image(systemName: "leaf.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA").opacity(1))
                                        
                                        VStack(alignment: .leading) {
                                            Text("Corn")
                                            Text("Seed Type")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image(systemName: "drop.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#0041BA").opacity(1))
                                        
                                        VStack(alignment: .leading) {
                                            Text(dryingdataonlinehead.first?.initial_mc ?? "NA")
                                            Text("Initial MC")
                                                .font(.footnote)
                                        }
                                    }
                                    
                                }
                            }
                            .cornerRadius(20)
                        }
                        .frame(maxWidth: 380)
                        
                        VStack {
                            VStack {
                                Table(dryingdataonline) {
                                    TableColumn("NOH") { nohx in
                                        Text(nohx.noh)
                                    }
                                    TableColumn("Date & Time") { nohx in
                                        Text("\(formatDate(nohx.date))")
                                    }
                                    .width(200)
                                    TableColumn("Top") { item in
                                        Text("\(item.upper)°C")
                                    }
                                    TableColumn("Bot") { item in
                                        Text("\(item.lower)°C")
                                    }
                                    TableColumn("MC", value: \.lower)
                                    TableColumn("Remarks", value: \.remarks)
                                    TableColumn("Options") { user in
                                        Menu {
                                            Button("Edit") {

                                            }

                                            Button("Delete", role: .destructive) {

                                            }
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                        }
                                    }
                                }
                                .cornerRadius(20)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Label("Back", systemImage: "list.bullet")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Back action
                        Button(action: {
                            showAddData = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .tint(Color(hex: "#0041BA").opacity(1))
                                Text("Add Data")
                            }
                        }
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image(systemName: "arrow.trianglehead.2.counterclockwise")
                                    .tint(Color(hex: "#0041BA").opacity(1))
                                Text("Reversal")
                            }
                        }
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image(systemName: "x.circle")
                                    .tint(Color.red.opacity(1))
                                Text("Downtime")
                            }
                        }
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image(systemName: "power.circle")
                                    .tint(Color.red.opacity(1))
                                Text("Shut Off")
                            }
                        }
                        
                    } label: {
                        Label("Back", systemImage: "plus")
                    }
                }
            }
        }
        .navigationTitle("Panel Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            getDryingTempData()
            getDryingTempDataHead()
        }
        .onReceive(timer) { value in
            currentTime = value
            getDryingTempData()
            getDryingTempDataHead()
        }
        
        .sheet(isPresented: $showAddData) {
            NavigationStack {
                List {
                    Section {
                        Text("Add Monitoring Data")
                            .font(.title2)
                            .listRowBackground(Color.clear)
                    }
                    Section {
                        VStack(alignment: .leading) {
                            Text("NOH")
                            TextField("10:21:32", text: $noh)
                                .textFieldStyle(.automatic)
                        }
                        VStack(alignment: .leading) {
                            Text("Date")
                            TextField("06/30/2026, 11:21:06 AM", text: $date)
                                .textFieldStyle(.automatic)
                        }
                        VStack(alignment: .leading) {
                            Text("Top Temperature")
                            TextField("43", text: $top)
                                .textFieldStyle(.automatic)
                        }
                        VStack(alignment: .leading) {
                            Text("Bot Temperature")
                            TextField("43", text: $bot)
                                .textFieldStyle(.automatic)
                        }
                        VStack(alignment: .leading) {
                            Text("Moisture Content")
                            TextField("43", text: $mc)
                                .textFieldStyle(.automatic)
                        }
                        VStack(alignment: .leading) {
                            Text("Moisture Content")
                            TextField("43", text: $remarks)
                                .textFieldStyle(.automatic)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                let newTemp = DryingData(
                                    noh: "11:30:21",
                                    date: "Thur March 19",
                                    time: "23:12:32",
                                    top: "34",
                                    bot: "23",
                                    mc: "10.2",
                                    remarks: "NA")
                                
                                dryingdata.append(newTemp)
                                
                            }) {
                                Text("Add Data")
                                    .padding(8)
                                    
                            }
                            .buttonStyle(.glassProminent)
                        }
                        
                    }
                    .toolbar {

//                        ToolbarItem(placement: .topBarTrailing) {
//                            Button("Open Panel") {
//                            }
//                            .buttonStyle(.glassProminent)
//                            .tint(Color(hex: "#0041BA"))
//                        }

//                        ToolbarItem(placement: .principal) {
//                            Text("Waiting Trucks")
//                                .font(.headline)
//                        }
                    }
                }
                
                
            }
        }
        
    }
    
    func remainingTime(for timerString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let arrival = formatter.date(from: timerString) else {
            return "--:--:--"
        }

        let target = arrival.addingTimeInterval(60 * 60)
        let remaining = target.timeIntervalSince(currentTime)

        if remaining <= 0 {
            return "Timers Up!"
        }

        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60

        return String(format: "%02d:%02d:%02d",
                      hours,
                      minutes,
                      seconds)
    }
    
    func getDryingTempData() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/DR/getDryingTempDataS.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "rhid=\(rhid)&dhid=\(dhid)&type=1"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryingDataOnline].self, from: data)

                DispatchQueue.main.async {
                    self.dryingdataonline = result
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func getDryingTempDataHead() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/DR/getDryingTempDataS.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "rhid=\(rhid)&dhid=\(dhid)&type=2"

        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryingDataOnlineHead].self, from: data)

                DispatchQueue.main.async {
                    self.dryingdataonlinehead = result
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

struct WebView: UIViewRepresentable {

    let html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}


#Preview {
    DR_PanelDetails(rhid: "RH43227", dhid: "1421")
}
