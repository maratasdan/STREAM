//
//  FindUsingQR.swift
//  STREAM
//
//  Created by dan on 10/7/26.
//

import SwiftUI

struct FindUsingQR: View {
    
    // MARK: Navigations
    @State private var goToCheckSession: Bool = false
    
    // MARK: Variables
    @State private var rhid: Int = 0
    @State private var qrCode: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                QRScannerView { code in
                    qrCode = code
                    getQRData(codedata: code)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("QR Tag Scanner")
                    }
                }
            }
            .navigationDestination(isPresented: $goToCheckSession) {
                CheckAccountSession(rhid: rhid)
            }
        }
    }
    
    func getQRData(codedata: String) {
        
        print(codedata)
        
        guard let data = codedata.data(using: .utf8) else {
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode(QRData.self, from: data)
            print(decoded.rhid)
            rhid.self = decoded.rhid
           goToCheckSession = true
       } catch {
           print("❌ Invalid QR:", error)
       }
    }
}

#Preview {
    FindUsingQR()
}
