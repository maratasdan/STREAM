//
//  SHLW_Nav.swift
//  STREAM
//
//  Created by Danxd on 8/4/26.
//

import SwiftUI
import WebKit

struct SHLW_Nav: View {
    var body: some View {
        WebViewer(url: "https://ops.stellarseedscorp.org/auth/dev_login.php")
            .ignoresSafeArea()
    }
}


#Preview {
    SHLW_Nav()
}
