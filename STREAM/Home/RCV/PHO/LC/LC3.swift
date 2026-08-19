//
//  LC3.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import SwiftUI
import SwiftData

struct LC3: View {
    
    let rhid: String
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToLC4: Bool = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Line Cleaning Checklist 3/6")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
                Section {
                    VStack {
                        Text("1. Are the Inclined Conveyor clean, kernels free and free from any debris?")
                    }
                    VStack {
                        Text("2. Are the Distribution Conveyor clean, kernels free and free from any debris?")
                    }
                    VStack {
                        Text("3. Are the Tripper Car Conveyor clean, kernels free and free from any debris?")
                    }
                    VStack {
                        Text("4. Is the Tripper Car in position to the bin to be loaded?")
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
        
        .navigationDestination(isPresented: $goToLC4) {
            LC4(rhid: rhid)
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
                res.step = "4"

                try context.save()
                print("Updated successfully")
                showScanner = false
                goToLC4 = true
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    LC3(rhid: "")
}
