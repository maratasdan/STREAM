//
//  DR_SSCAI_About.swift
//  STREAM
//
//  Created by Danxd on 8/6/26.
//

import SwiftUI

struct DR_SSCAI_About: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.indigo.opacity(0.10))
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("SSC AI Drying Prediction (Beta)")
                        .bold()
                        .foregroundStyle(Color.indigo)
                    Text(" uses machine learning to estimate the drying duration and expected completion time based on current monitoring data and historical drying records. It analyzes key factors such as moisture content, temperature readings, and monitoring history to support drying operations and decision-making. \n\nThis feature is currently in Beta, and predictions are continuously being improved as more drying data becomes available. Results are estimates and may vary depending on actual drying conditions.")
                        .foregroundStyle(Color.indigo.opacity(0.70))
                
                
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    DR_SSCAI_About()
}
