//
//  SHL_ViewSMR.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI
import WebKit

struct SHL_ViewSMR: View {
    
    let shid: String
    let rhid: String
    
    var body: some View {
        ZStack {
            WebViewer(url: "https://stellarseedscorp.org/system/SHELLING/smr.php?rhid=\(rhid)&&shid=\(shid)")
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

#Preview {
    SHL_ViewSMR(shid: "", rhid: "")
}
