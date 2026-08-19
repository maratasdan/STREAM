//
//  LC1.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI
import SwiftData

struct LC1: View {
    
    let rhid: String
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToLC2: Bool = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Line Cleaning Checklist 1/6")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
                Section {
                    VStack {
                        Text("1. Are the Floors and Walls in Receiving area clean and kernel free?")
                    }
                    VStack {
                        Text("2. Is the Receiving Platform clean and kernel free?")
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
        
        .navigationDestination(isPresented: $goToLC2) {
            LC1(rhid: rhid)
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
                res.step = "2"

                try context.save()
                print("Updated successfully")
                showScanner = false
                goToLC2 = true
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    LC1(rhid: "")
}
