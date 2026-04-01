// Animations.swift
// Detox – Motion Design Tokens

import SwiftUI

/// All animations in Detox are slow and intentional.
/// Nothing bounces. Nothing flashes. Motion is barely perceptible.
enum DetoxAnimation {

    // MARK: – Core Curves

    /// Standard transition — 0.5s ease in/out. Used most broadly.
    static let standard = Animation.easeInOut(duration: 0.5)

    /// Slow reveal — 0.8s ease in/out. Used for important content appearing.
    static let slow = Animation.easeInOut(duration: 0.8)

    /// Very slow — 1.2s. Interception screen text fade-in.
    static let verySlow = Animation.easeInOut(duration: 1.2)

    /// Micro — 0.25s. Toggle state, button press feedback.
    static let micro = Animation.easeInOut(duration: 0.25)

    /// Breathe spring — used for the toggle and count-up. No bounce.
    static let breathe = Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 0)

    // MARK: – Character Reveal

    /// Stagger delay per character in the interception headline reveal.
    /// Total reveal for a 20-char string ≈ 1.0s feel.
    static func characterDelay(index: Int) -> Double {
        Double(index) * 0.035
    }

    // MARK: – Interception Screen Timing

    /// Delay before any content appears on the interception screen.
    /// The 1.5s pause is intentional — it IS the experience.
    static let interceptionDelay: Double = 1.5

    /// Fade-in duration for interception content post-delay.
    static let interceptionFadeIn = Animation.easeInOut(duration: 0.8)

    // MARK: – Page Transitions

    /// Asymmetric transition: fade in slowly, out faster.
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
