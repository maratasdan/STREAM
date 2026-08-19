//
//  DR_ViewDMR.swift
//  STREAM
//
//  Created by Danxd on 8/18/26.
//

import SwiftUI
import WebKit

struct DR_ViewDMR: View {
    
    let dhid: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebViewX(url: URL(string: "https://ops.stellarseedscorp.org/modules/pho/views/dryer_operator/dmr-preview-app.php?dhid=\(dhid)")!)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    DR_ViewDMR(dhid: "44")
}
