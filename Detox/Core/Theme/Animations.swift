import SwiftUI

enum DetoxAnimation {

    static let standard = Animation.easeInOut(duration: 0.5)

    static let slow = Animation.easeInOut(duration: 0.8)

    static let verySlow = Animation.easeInOut(duration: 1.2)

    static let micro = Animation.easeInOut(duration: 0.25)

    static let breathe = Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 0)

    static func characterDelay(index: Int) -> Double {
        Double(index) * 0.035
    }

    static let interceptionDelay: Double = 1.5

    static let interceptionFadeIn = Animation.easeInOut(duration: 0.8)

    static var pageTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.animation(.easeIn(duration: 0.6)),
            removal: .opacity.animation(.easeOut(duration: 0.3))
        )
    }

    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity).animation(.easeOut(duration: 0.5)),
            removal: .move(edge: .top).combined(with: .opacity).animation(.easeIn(duration: 0.3))
        )
    }
}
