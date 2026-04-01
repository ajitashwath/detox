// AppCoordinator.swift
// Detox – Navigation State Machine

import SwiftUI

/// Single source of truth for which screen is shown.
/// Drives the root navigator via a simple enum — no NavigationStack stack needed.
@Observable
final class AppCoordinator {

    static let shared = AppCoordinator()

    enum Route: Equatable {
        case onboarding
        case home
        case reflection
        case weeklyReport
    }

    var currentRoute: Route

    init() {
        self.currentRoute = UserDefaultsManager.shared.hasCompletedOnboarding
            ? .home
            : .onboarding
    }

    func navigate(to route: Route) {
        withAnimation(DetoxAnimation.standard) {
            currentRoute = route
        }
    }

    func completeOnboarding() {
        UserDefaultsManager.shared.hasCompletedOnboarding = true
        navigate(to: .home)
    }
}
