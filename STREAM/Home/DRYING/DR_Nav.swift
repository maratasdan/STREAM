//
//  DR_Nav.swift
//  STREAM
//
//  Created by Danxd on 7/28/26.
//

import SwiftUI

struct DR_Nav: View {
    
    @State private var gotohome: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView {
                DR_Panels()
                    .tabItem {
                        //                    Image(systemName: "")
                        //                        .tint(Color.orange)
                        Label("Drying", systemImage: "flame.circle")
                    }
                DR_CurrentPanels()
                    .tabItem {
                        Image(systemName: "cloud.fill")
                            .tint(Color.orange)
                    }
                DR_ApproveDrying()
                    .tabItem {
                        Image(systemName: "list.bullet")
                            .tint(Color.orange)
                    }
                DR_ListForApproval()
                    .tabItem {
                        Image(systemName: "checklist")
                            .tint(Color.orange)
                    }
                DR_DMR()
                    .tabItem {
                        Image(systemName: "waveform.path.ecg.text.clipboard")
                            .tint(Color.orange)
                    }
            }
            .tabViewStyle(.tabBarOnly)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        gotohome = true
                    }) {
                        Image(systemName: "house")
                            .foregroundStyle(Color.red)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.red.opacity(0.15))
                }
            }
            .navigationDestination(isPresented: $gotohome) {
                RCV_Home()
            }
        }
    }
}

#Preview {
    DR_Nav()
}
