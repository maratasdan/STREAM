//
//  CheckSession.swift
//  STREAM
//
//  Created by Danxd on 8/10/26.
//

import SwiftUI
import SwiftData

struct CheckSession: View {
    
    @Query private var userdatatable: [tbl_login]
    
    @State private var openLogin: Bool = false
    @State private var openHome: Bool = false
    @State private var openScalerHome: Bool = false
    @State private var openMobileLogin: Bool = false
    
    @State private var rotation: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Loading Spinner
                    Circle()
                        .trim(from: 0.05, to: 0.75)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        ) 
                        .frame(width: 45, height: 45)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1)
                                .repeatForever(autoreverses: false)
                            ) {
                                rotation = 360
                            }
                        }
                    
                    Text("Checking account...")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("Please wait while we verify your account.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .navigationDestination(isPresented: $openLogin) {
                Login()
            }
            .navigationDestination(isPresented: $openHome) {
                RCV_Home()
            }
            .navigationDestination(isPresented: $openScalerHome) {
                Scaler_Home()
            }
            .navigationDestination(isPresented: $openMobileLogin) {
                App_Login()
            }
            .onAppear() {
                checkLocalDB()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
   
    func checkLocalDB() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if userdatatable.isEmpty {
                print("NO SESSION")
                openLogin = true
            } else {
                
    //            if userdatatable[0].role == "scaler" {
    //                openScalerHome = true
    //            } else if userdatatable[0].role == "sheller" {
    //                openScalerHome = true
    //            } else {
    //                openHome = true
    //            }
    //            print("SESSION FOUND")
    //            print(userdatatable[0].email)
                
                print(userdatatable[0].role)
                
                if userdatatable[0].role == "shift_lead" {
                    openHome = true
                } else {
                    openScalerHome = true
                }
            }
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            openMobileLogin = true
        }
        
        
    }
}

#Preview {
    CheckSession()
        .modelContainer(for: tbl_login.self, inMemory: true)
}
