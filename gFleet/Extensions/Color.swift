//
//  Color.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import SwiftUI

extension Color {
    static let appTheme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let secondaryBackground = Color("SecondaryBackground")
    let theme = Color("ThemeColor")
    let primaryText = Color("PrimaryTextColor")
    let secondaryText = Color("SecondaryTextColor")
}
