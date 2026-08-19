//
//  LC6.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import SwiftUI
import SwiftData

struct LC6: View {
    
    let rhid: String
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToNames: Bool = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Line Cleaning Checklist 6/6")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
                Section {
                    VStack {
                        Text("1. Ready for Bin Loading Activity?")
                    }
                }
                VStack(alignment: .trailing) {
                    Button(action: {
                        showScanner = true
                    }) {
                        Text("Scan QR")
                            .padding(5)
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
        .sheet(isPresented: $showScanner) {
            ZStack {
                QRScannerView { code in
                    qrCode = code
                    showScanner = false
                }
                Button("Submit") {
                    saveDataLC()
                }
            }
        }
        
        .navigationDestination(isPresented: $goToNames) {
            LCNames(rhid: rhid)
        }
    }
    
    func saveDataLC() {
        
        let descriptor = FetchDescriptor<tbl_lcc>(
            predicate: #Predicate {
                $0.rhid == rhid
            }
        )
        
        do {
            if let res = try context.fetch(descriptor).first {
                res.step = "7"

                try context.save()
                print("Updated successfully")
                showScanner = false
                goToNames = true
            }
        } catch {
            print(error)
        }
        
    }
}
#Preview {
    LC6(rhid: "")
}
