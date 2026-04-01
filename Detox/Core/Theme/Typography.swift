// Typography.swift
// Detox – Type Scale

import SwiftUI

/// All typography in Detox flows through this scale.
/// Strictly SF Pro (system font) with weight as the only axis of hierarchy.
/// No colors – hierarchy is expressed through weight and opacity alone.
enum DetoxFont {

    // MARK: – Display / Hero

    /// 72pt ultralight — used for large stat numbers (Home screen hero)
    static let hero = Font.system(size: 72, weight: .ultraLight, design: .default)

    /// 48pt thin — used for primary headings (Onboarding question)
    static let displayLarge = Font.system(size: 48, weight: .thin, design: .default)

    /// 36pt light — secondary display (Weekly report headline)
    static let displayMedium = Font.system(size: 36, weight: .light, design: .default)

    // MARK: – Heading

    /// 28pt regular — section titles (Reflection list header)
    static let title = Font.system(size: 28, weight: .regular, design: .default)

    /// 22pt medium — card headings
    static let headline = Font.system(size: 22, weight: .medium, design: .default)

    // MARK: – Body

    /// 17pt regular — standard body copy
    static let body = Font.system(size: 17, weight: .regular, design: .default)

    /// 17pt light — secondary explanatory text
    static let bodyLight = Font.system(size: 17, weight: .light, design: .default)

    // MARK: – Caption / Meta

    /// 14pt light — insight text below stats
    static let caption = Font.system(size: 14, weight: .light, design: .default)

    /// 12pt ultralight — timestamps, labels
    static let micro = Font.system(size: 12, weight: .ultraLight, design: .default)

    // MARK: – Monospaced (Timestamps)

    /// 12pt monospaced regular — reflection timestamps
    static let timestamp = Font.system(size: 12, weight: .regular, design: .monospaced)

    // MARK: – Interception Screen (Larger for psychological impact)

    /// 40pt thin — "Why are you opening this?" headline
    static let interceptionHeadline = Font.system(size: 40, weight: .thin, design: .default)

    /// 15pt ultralight — "Continue anyway" ghost label
    static let ghostAction = Font.system(size: 15, weight: .ultraLight, design: .default)
}

// MARK: – Opacity Scale

/// Opacity levels provide depth without color.
/// Using only black at varying opacities on a white background (or vice versa on black).
enum DetoxOpacity {
    static let primary: Double   = 1.0
    static let secondary: Double = 0.55
    static let tertiary: Double  = 0.30
    static let ghost: Double     = 0.18
    static let hairline: Double  = 0.08
}
