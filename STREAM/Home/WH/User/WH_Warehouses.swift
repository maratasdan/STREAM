//
//  WH_Warehouses.swift
//  STREAM
//
//  Created by Dan on 8/26/26.
//

import SwiftUI

struct WH_Warehouses: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: WH_Dashboard()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(Color.green.opacity(0.15))
                            Image(systemName: "house.circle")
                        }
                        VStack(alignment: .leading) {
                            Text("Warehouse 1")
                            Text("STELLAR SEEDS CORP PLANT")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                NavigationLink(destination: WH_Dashboard()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(Color.green.opacity(0.15))
                            Image(systemName: "house.circle")
                        }
                        VStack(alignment: .leading) {
                            Text("Warehouse 2")
                            Text("STELLAR SEEDS CORP PLANT")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                NavigationLink(destination: WH_Dashboard()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(Color.green.opacity(0.15))
                            Image(systemName: "house.circle")
                        }
                        VStack(alignment: .leading) {
                            Text("Warehouse 3")
                            Text("STELLAR SEEDS CORP PLANT")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                NavigationLink(destination: WH_Dashboard()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(Color.green.opacity(0.15))
                            Image(systemName: "house.circle")
                        }
                        VStack(alignment: .leading) {
                            Text("Warehouse 4")
                            Text("STELLAR SEEDS CORP PLANT")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WH_Warehouses()
}
