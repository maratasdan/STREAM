//
//  AppHome.swift
//  STREAM
//
//  Created by Danxd on 7/8/26.
//

import SwiftUI

enum MenuItem: String, CaseIterable, Identifiable {
    case dashboard
    case receiving
    case drying
    case shelling
    case conditioning
    case treatPack
    case reports
    case settings

    var id: String { rawValue }
}

struct AppHome: View {
    
    @State private var selection: MenuItem? = .dashboard
    
    var body: some View {
        NavigationSplitView {

           List(MenuItem.allCases, selection: $selection) {

               Label(title(for: $0), systemImage: icon(for: $0))
                   .tag($0)

           }
           .navigationTitle("STREAM")

       } detail: {

           switch selection {

           case .dashboard:
               Dashboard()

           default:
               Text("Select Menu")
           }

       }
    }
    
    func icon(for item: MenuItem) -> String {

        switch item {

        case .dashboard:
            return "rectangle.grid.2x2.fill"

        case .receiving:
            return "shippingbox.fill"

        case .drying:
            return "flame.fill"

        case .shelling:
            return "gearshape.2.fill"

        case .conditioning:
            return "leaf.fill"

        case .treatPack:
            return "cube.box.fill"

        case .reports:
            return "chart.bar.fill"

        case .settings:
            return "gearshape.fill"

        }

    }
    
    func title(for item: MenuItem) -> String {

        switch item {

        case .dashboard:
            return "Dashboard"

        case .receiving:
            return "Receiving"

        case .drying:
            return "Drying"

        case .shelling:
            return "Shelling"

        case .conditioning:
            return "Conditioning"

        case .treatPack:
            return "Treat & Pack"

        case .reports:
            return "Reports"

        case .settings:
            return "Settings"

        }

    }
    
    
}

#Preview {
    AppHome()
}
