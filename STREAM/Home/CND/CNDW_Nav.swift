//
//  CNDW_Nav.swift
//  STREAM
//
//  Created by Danxd on 8/4/26.
//

import SwiftUI
import WebKit

struct CNDW_Nav: View {
    var body: some View {
        WebViewer(url: "https://ops.stellarseedscorp.org/auth/dev_login.php")
            .ignoresSafeArea()
    }
}

#Preview {
    CNDW_Nav()
}
