//
//  CND_Conditioning.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI
import WebKit

struct CND_Conditioning: View {
    
    let cndlistid: String
    let cndshid: String
    
    var body: some View {
        ZStack {
            WebViewer(url: "https://stellarseedscorp.org/system/CND/conditioning.php?id=\(cndlistid)&id2=\(cndshid)'")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CND_Conditioning(cndlistid: "1", cndshid: "1")
}
