//
//  LC5.swift
//  STREAM APP
//
//  Created by Danxd on 7/22/26.
//

import SwiftUI
import SwiftData

struct LC5: View {
    
    let rhid: String
    
    @State private var showScanner = false
    @State private var qrCode = ""
    
    @State private var goToLC6: Bool = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Line Cleaning Checklist 5/6")
                        .font(.title)
                }
                .listRowBackground(Color.clear)
                Section {
                    VStack {
                        Text("1. Are the Bin Labels Available or Installed?")
                    }
                    VStack {
                        Text("2. Is the Top of the Bin Clean and Free from Debris?")
                    }
                    VStack {
                        Text("3. Is the Filling door Clean and Free from Debris?")
                    }
                    VStack {
                        Text("4. Are the Bin Walls Clean and Free from Debris?")
                    }
                    VStack {
                        Text("5. Are the Dyer Screen Floors clean and Kernel Free?")
                    }
                    VStack {
                        Text("6. Are the Wood Barricades are in Place?")
                    }
                    VStack {
                        Text("7. Is the unloading window clean, closed and locked?")
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
        
        .navigationDestination(isPresented: $goToLC6) {
            LC6(rhid: rhid)
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
                res.step = "6"

                try context.save()
                print("Updated successfully")
                showScanner = false
                goToLC6 = true
            }
        } catch {
            print(error)
        }
        
    }
}

#Preview {
    LC5(rhid: "")
}
