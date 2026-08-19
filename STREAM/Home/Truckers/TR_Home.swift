//
//  TR_Home.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 6/25/26.
//

import SwiftUI
internal import Combine

struct WatingTrucks: Codable, Identifiable {
    var id: String
    var type: String
    var dateArrived: String
}

struct TR_Home: View {
     
    @State private var currentDate = Date()
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    @State private var waitingtime: [WatingTrucks] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var showMenu = false
    @State private var showDashboard: Bool = false
    
    @State private var currentType: String = ""
    @State private var currentDateTime: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        
                        ForEach(waitingtime) { item in
                            
                            VStack {
                                VStack {
                                    HStack(alignment: .top) {
                                        Image(systemName: "truck.box.badge.clock")
                                            .foregroundStyle(Color(hex: "#0041BA"))
                                            .font(.title)
                                        VStack {
                                            HStack {
                                                Text("\(item.type)")
                                                    .font(.title2)
                                                Spacer()
                                            }
                                            HStack {
                                                Image(systemName: "arrow.down")
                                                Text(item.dateArrived)
                                                Spacer()
                                            }
                                            HStack {
                                                Image(systemName: "clock")
                                                Text(waitingTime(from: item.dateArrived))
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(hex: "#ffffff").opacity(0.7))
                            .cornerRadius(10)
                            .onTapGesture {
                                
                                currentType = item.type
                                currentDateTime = item.dateArrived
                                
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showMenu.toggle()
                                }
                            }
                            
                        }
                    }
                    .padding()
                }
                
                if showMenu {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMenu = false
                            }
                        }
                }
                
                VStack(alignment: .leading) {
                    List {
                        VStack {
                            Image(systemName: "truck.box.badge.clock")
                                .resizable()
                                .frame(width: 130, height: 100)
                                .foregroundStyle(Color(hex: "#0041BA"))
                                .symbolEffect(.bounce.up.byLayer, options: .repeat(.periodic(delay: 3.0)))
                            Text("\(currentType)")
                                .font(.title2)
                        }
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity)
                        
                        Section("") {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Image(systemName: "calendar.circle")
                                    VStack(alignment: .leading) {
                                        Text("\(currentDateTime)")
                                        Text("Date of arrival")
                                            .font(.caption)
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Image(systemName: "clock.badge")
                                    VStack(alignment: .leading) {
                                        Text(waitingTime(from: currentDateTime))
                                        Text("Waiting time")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        
                        Section("") {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Image(systemName: "questionmark.circle")
                                    VStack(alignment: .leading) {
                                        Text("Report this truck")
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: 300)
                .background(.background)
                .offset(x: showMenu ? 0 : -300)
                .animation(.easeInOut(duration: 0.3), value: showMenu)
            }
            .onReceive(timer) { value in
                currentDate = value
            }
            .onAppear() {
                getTPendingTrucks()
            }
        }
        .toolbar {
//
            ToolbarItem(placement: .topBarTrailing) {
                
                Button(action: {
                    showDashboard = true
                }){
                    Image(systemName: "chart.bar.xaxis")
                        .foregroundColor(Color.blue)
                }
                .buttonStyle(.glassProminent)
                .tint(Color.white)
                
            }

            ToolbarItem(placement: .principal) {
                Text("Waiting Trucks")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        }
        .navigationDestination(isPresented: $showDashboard) {
            TR_Dashboard()
        }
    }
    
    func getTPendingTrucks() {
        guard let url = URL(string: "https://ops.stellarseedscorp.org/App/Truckers/get_pending_truckers.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode([WatingTrucks].self, from: data)

                waitingtime = result

            } catch {
                print(error)
            }

        }.resume()
        
    }
    
    func waitingTime(from dateString: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current

        guard let arrivalDate = formatter.date(from: dateString) else {
            print("Invalid date: \(dateString)")
            return "--:--:--"
        }

        let seconds = Int(currentDate.timeIntervalSince(arrivalDate))

        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
}

#Preview {
    TR_Home()
}
