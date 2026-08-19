//
//  LC2.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import SwiftUI
import SwiftData

struct LC2: View {
    
    let rhid: String
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToLC3: Bool = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Line Cleaning Checklist 2/6")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
                Section {
                    VStack {
                        Text("1. Is the Sorting Conveyors clean, kernel free and free from debris?")
                    }
                    VStack {
                        Text("2. Is the Collection Conveyor clean, kernel free and free from any debris?")
                    }
                    VStack {
                        Text("3. Are the Cross Conveyor clean, kernels free and free from any debris?")
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
        
        .navigationDestination(isPresented: $goToLC3) {
            LC3(rhid: rhid)
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
                res.step = "3"

                try context.save()
                print("Updated successfully")
                showScanner = false
                goToLC3 = true
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    LC2(rhid: "")
}
