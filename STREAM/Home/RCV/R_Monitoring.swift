//
//  R_Monitoring.swift
//  STREAM
//
//  Created by Danxd on 7/13/26.
//

import SwiftUI
import WebKit

struct R_Monitoring: View {
    var body: some View {
        NavigationStack {
            ZStack {
                WebViewer(url: "https://stellarseedscorp.org/system/PHO/monitoring-listA.php")
                    .ignoresSafeArea()
            }
        }
    }
    
    struct WebViewer: UIViewRepresentable {
        let url: String

        func makeUIView(context: Context) -> WKWebView {
            WKWebView()
        }

        func updateUIView(_ webView: WKWebView, context: Context) {
            guard let url = URL(string: url) else { return }
            webView.load(URLRequest(url: url))
        }
    }
}

#Preview {
    R_Monitoring()
}
