//
//  WH_Fill_Info.swift
//  STREAM
//
//  Created by Dan on 9/4/26.
//

import SwiftUI

struct WH_Fill_Info: View {
    
    @State private var orginalSite: String = ""
    
    var body: some View {
        List {
            Section {
                VStack {
                    Text("Please complete the following fields")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .foregroundStyle(Color.green.opacity(0.15))
                        Image(systemName: "widget.small")
                    }
                    VStack(alignment: .leading) {
                        Text("Lot Number")
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                        
                        Text("SSC080011ZEUS26")
                    }
                }
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .foregroundStyle(Color.green.opacity(0.15))
                        Image(systemName: "widget.small")
                    }
                    VStack(alignment: .leading) {
                        Text("Lot Number")
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                        
                        Text("SSC080011ZEUS26")
                    }
                }
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .foregroundStyle(Color.green.opacity(0.15))
                        Image(systemName: "widget.small")
                    }
                    VStack(alignment: .leading) {
                        Text("Lot Number")
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                        
                        Text("SSC080011ZEUS26")
                    }
                }
            }
        }
    }
}

#Preview {
    WH_Fill_Info()
}
