//
//  Ext.swift
//  EBuddy
//
//  Created by Vincent on 07/12/24.
//

import SwiftUI

extension View {
    func read(offsetX: Binding<CGFloat>) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetXKey.self, value: geo.frame(in: .global).minX)
                }
                    .onPreferenceChange(ViewOffsetXKey.self) { minX in
                        let diff = abs(offsetX.wrappedValue - minX)
                        if diff > 1.0 {
                            offsetX.wrappedValue = minX
                            print("readOffsetX: \(offsetX.wrappedValue)")
                        }
                    }
            )
    }
}
