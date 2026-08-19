//
//  TR_Dashboard.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 6/26/26.
//

import SwiftUI
import Charts

struct Productionx: Identifiable {
    let id = UUID()
    let truck: String
    let noh: Double
}

struct TR_Dashboard: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let data = [
        Productionx(truck: "ELF 1", noh: 26),
        Productionx(truck: "TRUCK", noh: 28),
        Productionx(truck: "ELF 2", noh: 34)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .leading, spacing: 20) {

                        Text("Truck Waiting Time")
                            .font(.title2.bold())

                        Chart(data) { item in

                            BarMark(
                                x: .value("Truck", item.truck),
                                y: .value("Hours", item.noh)
                            )
                            .foregroundStyle(Color.green.gradient)
                            .cornerRadius(6)
                            .annotation(position: .top) {
                                Text("\(Int(item.noh)) Hours")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom)
                        }
                        .chartLegend(position: .top, alignment: .leading)
                        .frame(height: 320)
                        Spacer()

                    }
                    .padding(25)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.08), radius: 15, y: 8)
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    
                }
                
            }
        }
    }
}

#Preview {
    TR_Dashboard()
}
