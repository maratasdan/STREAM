//
//  DR_Home.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import SwiftUI

struct DR_Home: View {
    var body: some View {
        NavigationStack {
            List {
                
                NavigationLink(destination: DR_ListForApproval()) {
                    HStack {
                        Image(systemName: "checklist")
                            .font(.system(size:30))
                            .foregroundColor(Color.green)
                        
                        VStack(alignment: .leading) {
                            Text("Approve Bin")
                                .font(.system(size:18))
                                .bold()
                                .foregroundColor(Color.green)
                            Text("List of all approvals")
                                .font(.callout)
                        }
                    }
                }
                
                NavigationLink(destination: DR_ListForApproval()) {
                    HStack {
                        Image(systemName: "checklist")
                            .font(.system(size:30))
                            .foregroundColor(Color.green)
                        
                        VStack(alignment: .leading) {
                            Text("Approve Drying")
                                .font(.system(size:18))
                                .bold()
                                .foregroundColor(Color.green)
                            Text("List of all approvals")
                                .font(.callout)
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    DR_Home()
}
