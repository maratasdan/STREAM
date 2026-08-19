//
//  WH_BatchDetails.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI

struct WH_BatchDetails: View {
    
    let lotnumber: String
    let whno: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                HStack(spacing: 20) {
                    VStack {
                        List {
                            Section {
                                VStack {
                                    Image(systemName: "archivebox.circle.fill")
                                        .font(.system(size: 90))
                                    Text("\(lotnumber)")
                                        .font(.title2)
                                    Text("Batch Number")
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity)
                                .listRowBackground(Color.clear)
                            }
                            Section {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("\(whno)")
                                            .bold()
                                        Text("Warehouse Located")
                                            .font(.footnote)
                                    }
                                }
                                
                            }
                        }
                    }
                    .frame(width: 300)
                    .cornerRadius(20)
                    
                    VStack {
                        List {
                            
                        }
                    }
                    .cornerRadius(20)
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    WH_BatchDetails(lotnumber: "", whno: "")
}
