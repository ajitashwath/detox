import SwiftUI

enum DetoxFont {

    static let hero = Font.system(size: 72, weight: .ultraLight, design: .default)

    static let displayLarge = Font.system(size: 48, weight: .thin, design: .default)

    static let displayMedium = Font.system(size: 36, weight: .light, design: .default)

    static let title = Font.system(size: 28, weight: .regular, design: .default)

    static let headline = Font.system(size: 22, weight: .medium, design: .default)

    static let body = Font.system(size: 17, weight: .regular, design: .default)

    static let bodyLight = Font.system(size: 17, weight: .light, design: .default)

    static let caption = Font.system(size: 14, weight: .light, design: .default)

    static let micro = Font.system(size: 12, weight: .ultraLight, design: .default)

    static let timestamp = Font.system(size: 12, weight: .regular, design: .monospaced)

    static let interceptionHeadline = Font.system(size: 40, weight: .thin, design: .default)

    static let ghostAction = Font.system(size: 15, weight: .ultraLight, design: .default)
}

enum DetoxOpacity {
    static let primary: Double   = 1.0
    static let secondary: Double = 0.55
    static let tertiary: Double  = 0.30
    static let ghost: Double     = 0.18
    static let hairline: Double  = 0.08
}
