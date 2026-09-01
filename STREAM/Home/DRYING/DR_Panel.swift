//
//  SwiftUIView.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 6/26/26.
//
import SwiftUI

internal import Combine
struct DryerPanel: Identifiable, Codable {
    
    var id: String { binid }
    var binid: String
    var hybrid: String
    var seedtype: String
    var mc: String
    var uppertemp: String
    var lowertemp: String
    var timer: String
    var blower: String
    
}

struct DryerPanelOnline: Identifiable, Codable {
    
    var id: String { dhid }
    var dhid: String
    var rhid: String
    var binid: String
    var lot_no: String
    var status: String
    var initial_mc: String
    var start: String
    var start_half: String
    var end: String
    var reversal: String
    var blower: String
    var skind: String
    var hybrid_code: String
    var date: String
    var upper: String
    var lower: String
    
}



struct DR_Panel: View {
    
    @State private var binTimerColor: String = "#0041BA";
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var dryerpanel: [DryerPanel] = [
        DryerPanel(binid: "201", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T14:10:12", blower: "1"),
        DryerPanel(binid: "202", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T15:10:03", blower: "2"),
        DryerPanel(binid: "203", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T12:10:04", blower: "2"),
        DryerPanel(binid: "204", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T16:10:14", blower: "1"),
        DryerPanel(binid: "205", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T14:10:24", blower: "1"),
        DryerPanel(binid: "206", hybrid: "POLY", seedtype: "Corn", mc: "43.21", uppertemp: "31", lowertemp: "24", timer: "2026-07-02T15:10:32", blower: "2")
    ]
    
    @State private var goToDryingDetails: Bool = false
    @State private var dryingpanelonline: [DryerPanelOnline] = []
    @State private var goToAppriveDrying: Bool = false
    @State private var goToPanels: Bool = false
    @State private var goToCurrentPannels: Bool = false
    
    @State private var rhid: String = ""
    @State private var dhid: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                if dryingpanelonline.isEmpty {
                    VStack(spacing: 15) {
                        ProgressView()
                            .scaleEffect(1.4)

                        Text("Fetching Data")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        HStack {
                            LazyVGrid(columns: columns) {
                                ForEach(dryingpanelonline) { item in
                                    VStack {
                                        VStack {
                                            VStack {
                                                HStack {
                                                    Image(systemName: "flame.fill")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                        .foregroundColor(Color.red)
                                                        .symbolEffect(.pulse)
                                                    Text("\(item.binid)")
                                                        .font(.title)
                                                        .foregroundColor(Color(hex: "#0041BA"))
                                                        .bold()
                                                    Spacer()
                                                    if item.blower ==  "1" {
                                                        Image(systemName: "arrow.up.circle")
                                                            .resizable()
                                                            .frame(width: 30, height: 30)
                                                    } else if item.blower == "2" {
                                                        Image(systemName: "arrow.down.circle")
                                                            .resizable()
                                                            .frame(width: 30, height: 30)
                                                    }
                                                    
                                                }
                                                .padding(.bottom, 10)
                                                HStack {
                                                    Label("\(item.hybrid_code)", systemImage: "camera.macro.circle.fill")
                                                    Spacer()
                                                }
                                                HStack {
                                                    if item.skind == "1" {
                                                        Label("Rice", systemImage: "leaf.circle.fill")
                                                    } else {
                                                        Label("Corn", systemImage: "leaf.circle.fill")
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                HStack {
                                                    HStack {
                                                        Label("\(item.upper)°", systemImage: "arrow.up")
                                                        Label("\(item.lower)°", systemImage: "arrow.down")
                                                    }
                                                    Spacer()
                                                }
                                                Spacer()
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        //                                                Label(, systemImage: "timer")
                                                        Text(remainingTime(for: item.date))
                                                            .frame(width: 110, height: 30)
                                                            .bold()
                                                            .background(
                                                                Color(
                                                                    hex: remainingTime(for: item.date) == "Timers Up!"
                                                                    ? "#f54254"
                                                                    : "#0041BA"
                                                                )
                                                            )
                                                            .cornerRadius(10)
                                                            .foregroundStyle(Color.white)
                                                        Spacer()
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                                
                                                Spacer()
                                            }
                                            .padding(20)
                                            .background(
                                                Color(
                                                    hex: remainingTime(for: item.date) == "Timers Up!"
                                                    ? "#ffedef"
                                                    : "#ffffff"
                                                )
                                                .opacity(0.9)
                                            )
                                        }
                                        .border(Color.white, width: 2)
                                        .cornerRadius(20)
                                        .frame(maxWidth: .infinity)
                                        .padding(5)
                                    }
                                    .onTapGesture {
                                        goToDryingDetails = true
                                        rhid = item.rhid
                                        dhid = item.dhid
                                    }
                                }
                            }
                        }
                        .padding(20)
                        Spacer()
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .onReceive(timer) { value in
                currentTime = value
            }
            .navigationDestination(isPresented: $goToDryingDetails) {
                DR_PanelDetails(rhid: rhid, dhid: dhid)
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
        }
        .onAppear() {
            getDryingPanel()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    goToAppriveDrying = true
                }) {
                    Image(systemName: "list.bullet")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    goToPanels = true
                }) {
                    Image(systemName: "flame.circle")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    goToCurrentPannels = true
                }) {
                    Image(systemName: "flame.circle.fill")
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
    
    func getDryingPanel() {
        guard let url = URL(string: "https://stellarseedscorp.org/system/app/DR/getToDryS.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([DryerPanelOnline].self, from: data)

                DispatchQueue.main.async {
                    self.dryingpanelonline = result
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

#Preview {
    DR_Panel()
}
