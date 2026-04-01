// Spacing.swift
// Detox – 8-Point Grid

import SwiftUI

/// All spacing in Detox is derived from an 8pt base unit.
/// Using named tokens enforces visual rhythm and makes resizing systematic.
enum Spacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 16
    static let lg: CGFloat  = 24
    static let xl: CGFloat  = 32
    static let xxl: CGFloat = 48
    static let huge: CGFloat = 64
    static let massive: CGFloat = 96

    /// Standard screen horizontal padding
    static let screenHorizontal: CGFloat = 28

    /// Standard page top padding (below nav)
    static let pageTop: CGFloat = 40
}

/// Hairline separator weight
enum DetoxStroke {
    static let hairline: CGFloat = 0.5
    static let thin: CGFloat     = 1.0
}

/// Corner radii — kept tight and intentional
enum DetoxRadius {
    static let button: CGFloat  = 14
    static let card: CGFloat    = 18
    static let small: CGFloat   = 8
    static let pill: CGFloat    = 100
}
