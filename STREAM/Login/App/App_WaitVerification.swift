//
//  App_WaitVerification.swift
//  STREAM
//
//  Created by Dan on 8/25/26.
//

import SwiftUI

struct App_WaitVerification: View {
    
    @State private var backtologin: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bglog")
                    .scaledToFill()
                
                Rectangle()
                    .foregroundStyle(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    Spacer()
                    
                    Image("stellar-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                    
                    HStack {
                        Text("Your account is under verification. Please wait until the verification is complete.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 350)
                    
                    Button {
                        backtologin = true
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            Text("Back to login")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .bold()
                            
                        }
                        .frame(maxWidth: 330)
                        .frame(height: 38)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color(hex: "#F25022"))
                    .glassEffect(.regular)
                    
                    Spacer()
                    
                }
                .padding(.horizontal,40)
                
                
            }
            .navigationDestination(isPresented: $backtologin) {
                App_Login()
            }
            .navigationBarBackButtonHidden(true)
            
            
        }
    }
}

#Preview {
    App_WaitVerification()
}
