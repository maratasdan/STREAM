//
//  CompanyWebsite.swift
//  STREAM
//
//  Created by Danxd on 7/13/26.
//

import SwiftUI
import WebKit

struct CompanyWebsite: View {
    var body: some View {
        NavigationStack {
            WebViewer(url: "https://web.stellarseedscorp.org/")
                .ignoresSafeArea()
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
    CompanyWebsite()
}
