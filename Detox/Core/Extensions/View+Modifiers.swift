// View+Modifiers.swift
// Detox – Reusable View Modifiers

import SwiftUI

// MARK: – Primary Button Style

struct DetoxPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DetoxFont.body)
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: DetoxRadius.button, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DetoxRadius.button, style: .continuous)
                    .stroke(Color.black, lineWidth: DetoxStroke.thin)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(DetoxAnimation.micro, value: configuration.isPressed)
    }
}

// MARK: – Ghost Button Style (inverted, for dark screens)

struct DetoxGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DetoxFont.body)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: DetoxRadius.button, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DetoxRadius.button, style: .continuous)
                    .stroke(Color.white.opacity(0.6), lineWidth: DetoxStroke.thin)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(DetoxAnimation.micro, value: configuration.isPressed)
    }
}

// MARK: – Hairline Separator

struct DetoxDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(DetoxOpacity.hairline))
            .frame(height: DetoxStroke.hairline)
    }
}

// MARK: – View Modifiers

extension View {

    /// Standard screen outer padding.
    func screenPadding() -> some View {
        self.padding(.horizontal, Spacing.screenHorizontal)
    }

    /// Slow fade-in on appear with optional delay.
    func fadeInOnAppear(delay: Double = 0) -> some View {
        modifier(FadeInModifier(delay: delay))
    }

    /// Hides keyboard on tap of the view.
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}

// MARK: – Fade-In Modifier

private struct FadeInModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(DetoxAnimation.slow) {
                        opacity = 1
                    }
                }
            }
    }
}

// MARK: – Scale Press Effect

struct ScalePressEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(DetoxAnimation.micro, value: configuration.isPressed)
    }
}

// MARK: – Conditional Modifier

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
