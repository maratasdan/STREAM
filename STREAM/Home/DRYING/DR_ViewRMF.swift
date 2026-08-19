//
//  DR_ViewRMF.swift
//  STREAM
//
//  Created by Danxd on 8/18/26.
//

import SwiftUI
import WebKit

struct DR_ViewRMF: View {
    
    let rhid: String
    
    var body: some View {
        ZStack {
            WebViewX(url: URL(string: "https://ops.stellarseedscorp.org/modules/pho/views/scaler/print_rmf_legacy_app.php?rhid=\(rhid)&type=app")!)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    DR_ViewRMF(rhid: "")
}
