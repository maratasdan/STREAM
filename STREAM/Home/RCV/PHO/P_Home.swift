//
//  P_Home.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI

struct P_Home: View {
    
    @State private var goHome: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: P_RMFApprovalList()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(Color.green.opacity(0.15))
                                .cornerRadius(30)
                            Image(systemName: "checklist")
                                .foregroundColor(Color.green)
                        }
                        VStack(alignment: .leading) {
                            Text("RMF Approval")
                                .font(.system(size:18))
                                .bold()
                                .foregroundColor(Color.green)
                        }
                    }
                }
                
                NavigationLink(destination: P_ListOfLCC()) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(Color.green.opacity(0.15))
                                .cornerRadius(30)
                            Image(systemName: "list.bullet.clipboard")
                                .foregroundColor(Color.green)
                        }
                        VStack(alignment: .leading) {
                            Text("Line Cleaning Checklist")
                                .font(.system(size:18))
                                .bold()
                                .foregroundColor(Color.green)
                        }
                    }
                }
                
                
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goHome) {
            RCV_Home()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    goHome = true
                } label: {
                    Image(systemName: "house.circle.fill")
                }
            }
        }
    }
}

#Preview {
    P_Home()
}
