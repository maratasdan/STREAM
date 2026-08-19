//
//  Registration.swift
//  STREAM
//
//  Created by Danxd on 8/7/26.
//

import SwiftUI
import WebKit

struct Registration: View {
    
    let username: String
    
    @State private var firstname: String = ""
    
    @State private var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3", "Option 3", "Option 3", "Option 3"]

    
    var body: some View {
        
        NavigationStack {
            WebViewer(url: "https://ops.stellarseedscorp.org/auth/registration-app.php?pending_email=\(username)&type=App")
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
    Registration(username: "dan.scaler@stellarseedscorp.org")
}
