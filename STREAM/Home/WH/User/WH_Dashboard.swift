//
//  WH_Dashboard.swift
//  STREAM
//
//  Created by dan on 8/25/26.
//

import SwiftUI
import SwiftData

struct WH_Dashboard: View {
    
    @Query private var userdata: [tbl_login]
    
    @State private var isOn = true
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 45, height: 45)
                                .cornerRadius(30)
                                .foregroundStyle(Color.green)
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(30)
                                .foregroundStyle(Color.white)
                            Image(systemName: "person")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(userdata.first?.firstname ?? "") \(userdata.first?.lastname ?? "")")
                            Text("Warehouse Man")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.forward.2")
                            .foregroundStyle(Color.green)
                        
                    }
                    .listRowBackground(Color.clear)
                    
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            isOn.toggle()
                        }) {
                            Image(systemName: "power")
                                .foregroundStyle(Color.red)
                                .tint(Color.red)
                                .bold()
                        }
                    }
                    
                }
                Section {
                    NavigationLink(destination: WH_Home()) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.green.opacity(0.15))
                                Image(systemName: "house")
                            }
                            VStack(alignment: .leading) {
                                Text("Warehouses")
                                Text("Display all warehouses")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    NavigationLink(destination: WH_Home()) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundStyle(Color.green.opacity(0.15))
                                Image(systemName: "list.bullet.rectangle.portrait")
                            }
                            VStack(alignment: .leading) {
                                Text("ISM")
                                Text("Create, View and Share")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "qrcode")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileHeader: View {
    
    var body: some View {
        
    }
}

#Preview {
    WH_Dashboard()
}
