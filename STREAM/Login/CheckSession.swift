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
            .onAppear() {
                checkLocalDB()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
   
    func checkLocalDB() {
        if userdatatable.isEmpty {
            print("NO SESSION")
            openLogin = true
        } else {
            print("SESSION FOUND")
            print(userdatatable[0].email)
            openHome = true
        }
    }
}

#Preview {
    CheckSession()
        .modelContainer(for: tbl_login.self, inMemory: true)
}
