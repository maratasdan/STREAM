//
//  P_LCPreview.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI
import SwiftData

struct P_LCPreview: View {
    
    let rhid: String
    let dryer_line: String
    let bin_id: String
    let rmf_date: String
    
    @Environment(\.modelContext) private var context
    
    @State private var showAlertStart: Bool = false
    
    @State private var goToLCC: Bool = false
    @State private var goLC1: Bool = false
    @State private var goLC2: Bool = false
    @State private var goLC3: Bool = false
    @State private var goLC4: Bool = false
    @State private var goLC5: Bool = false
    @State private var goLC6: Bool = false
    @State private var goToNames: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section("RHID: \(rhid)") {
                    HStack {
                        Image(systemName: "archivebox")
                        VStack {
                            Text("Bin \(bin_id)")
                        }
                    }
                    .font(.system(size: 20))
                    HStack {
                        Image(systemName: "calendar")
                        VStack {
                            Text("\(rmf_date)")
                        }
                    }
                    .font(.system(size: 20))
                    HStack {
                        Image(systemName: "line.3.horizontal")
                        VStack {
                            Text("\(dryer_line)")
                        }
                    }
                    .font(.system(size: 20))
                }
                
                VStack {
                    
                    let descriptor = FetchDescriptor<tbl_lcc>(
                        predicate: #Predicate { $0.rhid == rhid }
                    )
                    
                    if let res = try? context.fetch(descriptor).first {
                        
                        Button(action: {
                            if res.step == "1" {
                                goLC1 = true
                            } else if res.step == "2" {
                                goLC2 = true
                            } else if res.step == "3" {
                                goLC3 = true
                            } else if res.step == "4" {
                                goLC4 = true
                            } else if res.step == "5" {
                                goLC5 = true
                            } else if res.step == "6" {
                                goLC6 = true
                            } else if res.step == "7" {
                                goToNames = true
                            }
                        }) {
                            Text("Continue LC \(res.step)")
                                .frame(maxWidth: .infinity)
                                .padding(5)
                        }
                        .tint(Color.green)
                        .buttonStyle(.glassProminent)
                        .glassEffect(.clear)
                        .frame(maxWidth: .infinity)
                        
                    } else {
                        Button(action: {
                            saveDataLC()
                        }) {
                            Text("Start Line Cleaning Checklist")
                                .frame(maxWidth: .infinity)
                                .padding(5)
                        }
                        .tint(Color.green)
                        .buttonStyle(.glassProminent)
                        .glassEffect(.clear)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $goToLCC) {
            LC1(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC1) {
            LC1(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC2) {
            LC2(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC3) {
            LC3(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC4) {
            LC4(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC5) {
            LC5(rhid: rhid)
        }
        .navigationDestination(isPresented: $goLC6) {
            LC6(rhid: rhid)
        }
        .navigationDestination(isPresented: $goToNames) {
            LCNames(rhid: rhid)
        }
    }
    
    func saveDataLC() {
        
        let linecleaning = tbl_lcc(
            rhid: rhid,
            step: "1",
            opname: "Dan",
            slname: "Dan"
        )
        
        context.insert(linecleaning)
        
        do  {
            try context.save()
            goToLCC = true
            print("Saved")
        } catch {
            print("Error Saving")
        }
        
    }
}

#Preview {
    P_LCPreview(rhid: "", dryer_line: "", bin_id: "", rmf_date: "")
}
