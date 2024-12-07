//
//  ViewOffset.swift
//  EBuddy
//
//  Created by Vincent on 07/12/24.
//

import SwiftUI

struct ViewOffsetXKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
