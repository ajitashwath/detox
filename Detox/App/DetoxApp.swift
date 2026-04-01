// DetoxApp.swift
// Detox – App Entry Point

import SwiftUI

@main
struct DetoxApp: App {

    @State private var coordinator = AppCoordinator.shared
    @State private var familyControls = FamilyControlsManager.shared
    @State private var deviceActivity = DeviceActivityManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
                .environment(familyControls)
                .environment(deviceActivity)
                .preferredColorScheme(.light)  // Force light mode; we control our own black/white palette
        }
    }
}

// MARK: – Root View

/// The single top-level switcher. All navigation lives in AppCoordinator.
struct RootView: View {

    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .onboarding:
                OnboardingView()
                    .transition(DetoxAnimation.pageTransition)

            case .home:
                HomeView()
                    .transition(DetoxAnimation.pageTransition)

            case .reflection:
                ReflectionTimelineView()
                    .transition(DetoxAnimation.slideUp)

            case .weeklyReport:
                WeeklyReportView()
                    .transition(DetoxAnimation.slideUp)
            }
        }
        .animation(DetoxAnimation.standard, value: coordinator.currentRoute)
    }
}
