//
//  WebView.swift
//  STREAM
//
//  Created by Danxd on 7/23/26.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewX: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Loading...")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished Loading")
        }
        
        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            print(error.localizedDescription)
        }
    }
}
