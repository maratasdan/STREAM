//
//  ViewExtensions.swift
//  STREAM
//
//  Created by Dan on 8/26/26.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func myGlass() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
        }
    }
}
