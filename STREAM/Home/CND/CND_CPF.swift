//
//  CND_CPF.swift
//  STELLAR SIMULATOR
//
//  Created by Danxd on 7/3/26.
//

import SwiftUI
import WebKit

struct CND_CPF: View {
    
    let cndlistid: String
    
    var body: some View {
        ZStack {
            WebViewer(url: "https://stellarseedscorp.org/system/CND/cpf.php?id=\(cndlistid)")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CND_CPF(cndlistid: "")
}
