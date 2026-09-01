//
//  RCV_Home.swift
//  STREAM
//
//  Created by Danxd on 7/7/26.
//

import SwiftUI
import Charts
internal import Combine
import SwiftData

struct Production: Identifiable {
    let id = UUID()
    let day: String
    let kg: Double
}


struct RCV_Home: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var now = Date()
    @State private var borderRotation: Double = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let data = [
        Production(day: "Mon", kg: 1200),
        Production(day: "Tue", kg: 1450),
        Production(day: "Wed", kg: 1320),
        Production(day: "Thu", kg: 1680),
        Production(day: "Fri", kg: 1820),
        Production(day: "Sat", kg: 1750)
    ]
    
    @State private var goToMappingPage: Bool = false
    @State private var goToWebsite: Bool = false
    @State private var pageSelection: String = "1"
    @State private var goToCheckSession: Bool = false
    
    @State private var showAppVersion: Bool = false
    @State private var showLogout: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                HStack(spacing: 0) {
                    VStack {
                        HStack {
                            Image(systemName: "leaf.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(hex: "#6bd17c"))
                        }
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    pageSelection == "1" ?
                                    Color(hex: "#6bd17c").opacity(0.2)
                                    : Color.clear
                                )

                            Image(systemName: "house.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(
                                    pageSelection == "1" ?
                                    Color(hex: "#6bd17c")
                                    : Color.white
                                )
                                .onTapGesture {
                                    pageSelection = "1"
                                }
                                .scaleEffect(pageSelection == "1" ? 1.2 : 1)
                                .rotationEffect(.degrees(pageSelection == "1" ? 5 : 0))
                                .animation(.spring(response: 0.35, dampingFraction: 0.5), value: pageSelection)
                        }
                        .frame(width: 45, height: 45)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    pageSelection == "2" ?
                                    Color(hex: "#6bd17c").opacity(0.2)
                                    : Color.clear
                                )
                        
                            Image(systemName: "map.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(
                                    pageSelection == "2" ?
                                    Color(hex: "#6bd17c")
                                    : Color.white
                                )
                                .onTapGesture {
                                    pageSelection = "2"
                                }
                                .scaleEffect(pageSelection == "2" ? 1.2 : 1)
                                .rotationEffect(.degrees(pageSelection == "2" ? 5 : 0))
                                .animation(.spring(response: 0.35, dampingFraction: 0.5), value: pageSelection)
                        }
                        .frame(width: 45, height: 45)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    pageSelection == "3" ?
                                    Color(hex: "#6bd17c").opacity(0.2)
                                    : Color.clear
                                )
                        
                            Image(systemName: "globe")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(
                                    pageSelection == "3" ?
                                    Color(hex: "#6bd17c")
                                    : Color.white
                                )
                                .onTapGesture {
                                    pageSelection = "3"
                                    goToWebsite = true
                                }
                                .scaleEffect(pageSelection == "3" ? 1.2 : 1)
                                .rotationEffect(.degrees(pageSelection == "3" ? 5 : 0))
                                .animation(.spring(response: 0.35, dampingFraction: 0.5), value: pageSelection)
                        }
                        .frame(width: 45, height: 45)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    pageSelection == "4" ?
                                    Color(hex: "#6bd17c").opacity(0.2)
                                    : Color.clear
                                )
                        
                            Image(systemName: "bolt.shield")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(
                                    pageSelection == "4" ?
                                    Color(hex: "#6bd17c")
                                    : Color.white
                                )
                                .onTapGesture {
                                    pageSelection = "4"
                                    goToWebsite = true
                                }
                                .scaleEffect(pageSelection == "4" ? 1.2 : 1)
                                .rotationEffect(.degrees(pageSelection == "4" ? 5 : 0))
                                .animation(.spring(response: 0.35, dampingFraction: 0.5), value: pageSelection)
                        }
                        .frame(width: 45, height: 45)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.bottom, 10)
                        .onTapGesture {
                            showLogout = true
                        }
                        
                            
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .onTapGesture {
                            showAppVersion = true
                        }
                    
                    }
                    .frame(width: 80)
                    .background(Color.white.opacity(0.1))
                    
                    
                    VStack {
                        
                        if pageSelection == "1" {
                            Dashboard()
                        } else
                        
                        if pageSelection == "2" {
                            VStack {
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("84.3%")
                                            .font(.system(size: 70))
                                            .bold()
                                            .foregroundStyle(Color(hex: "#6bd17c"))
                                        Text("Availability")
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(30)
                                    
                                    
                                    VStack {
                                        Text("98.5%")
                                            .font(.system(size: 65))
                                            .bold()
                                            .foregroundStyle(Color(hex: "#6bd17c"))
                                        Text("Performance")
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: "#6bd17c"),
                                                    Color.green.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                    )
                                    
                                    VStack {
                                        Text("99%")
                                            .font(.system(size: 65))
                                            .bold()
                                            .foregroundStyle(Color(hex: "#6bd17c"))
                                        Text("Quality")
                                            .foregroundStyle(Color.white)
                                            .bold()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: "#6bd17c"),
                                                    Color.green.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                    )
                                    
                                }
                                .padding(.bottom, 10)
                                
                                HStack(alignment: .top, spacing: 20) {
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text(now, format: .dateTime
                                            .year()
                                            .month(.abbreviated)
                                            .day()
                                            .hour()
                                            .minute()
                                            .second()
                                        )
                                        .font(.system(size: 22, design: .monospaced))
                                        .foregroundStyle(Color(hex: "#6bd17c"))
                                        .onReceive(timer) { now = $0 }
                                    }
                                    .padding(25)
                                    .frame(maxWidth: 340)
                                    .clipShape(RoundedRectangle(cornerRadius: 28))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: "#6bd17c"),
                                                    Color.green.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                    )
                                    
                                    VStack {
                                        VStack {
                                            Chart(data) { item in
                                                
                                                AreaMark(
                                                    x: .value("Day", item.day),
                                                    y: .value("KG", item.kg)
                                                )
                                                .foregroundStyle(
                                                    LinearGradient(
                                                        colors: [
                                                            Color(hex: "#6bd17c").opacity(0.4),
                                                            .clear
                                                        ],
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                
                                                LineMark(
                                                    x: .value("Day", item.day),
                                                    y: .value("KG", item.kg)
                                                )
                                                .foregroundStyle(Color(hex: "#6bd17c"))
                                                .lineStyle(.init(lineWidth: 3))
                                                
                                                if item.kg > 1800 {
                                                    PointMark(
                                                        x: .value("Day", item.day),
                                                        y: .value("KG", item.kg)
                                                    )
                                                    .foregroundStyle(Color.yellow)
                                                } else {
                                                    PointMark(
                                                        x: .value("Day", item.day),
                                                        y: .value("KG", item.kg)
                                                    )
                                                    .foregroundStyle(Color.white)
                                                }
                                                
                                            }
                                            .padding(50)
                                            
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 500)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 28)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color(hex: "#6bd17c"),
                                                            Color.green.opacity(0.1)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 3
                                                )
                                        )
                                    }
                                }
                            }
                            .padding()
                        } else if pageSelection == "3" {
                            CompanyWebsite()
                        } else if pageSelection == "4" {
                            S_Img()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.black)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToMappingPage) {
                Dashboard()
            }.navigationDestination(isPresented: $goToCheckSession) {
                CheckSession()
            }
            .alert("STREAM", isPresented: $showAppVersion) {
                Button("OK") { }
            } message: {
                Text("SSC 2026 | App Version 3.0")
            }
            
            .alert("Confirmation", isPresented: $showLogout) {
                Button("OK") {
                    logout()
                }
                Button("Cancel", role: .close) {
                    
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
        
    }
    
    func logout() {
        do {
            let users = try context.fetch(FetchDescriptor<tbl_login>())
            
            for user in users {
                context.delete(user)
            }
            
            try context.save()
            
            print("✅ Deleted \(users.count) users")
            goToCheckSession = true
            
        } catch {
            print("❌ Delete error:", error)
        }
    }
}

#Preview {
    RCV_Home()
}
