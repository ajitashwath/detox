// HomeViewModel.swift
// Detox – Home Screen Logic

import SwiftUI
import Combine

@Observable
final class HomeViewModel {

    // MARK: – Displayed State

    var pauseCount: Int = 0
    var isShieldActive: Bool = false
    var insightText: String = ""

    // MARK: – Lifecycle

    func onAppear() {
        refresh()
    }

    func refresh() {
        pauseCount = UserDefaultsManager.shared.pauseCountToday
        isShieldActive = UserDefaultsManager.shared.isShieldActive
        insightText = UserDefaultsManager.shared.currentInsightText
    }

    // MARK: – Toggle

    func toggleShield() {
        withAnimation(DetoxAnimation.breathe) {
            FamilyControlsManager.shared.toggleShield()
            isShieldActive = UserDefaultsManager.shared.isShieldActive
        }
    }

    // MARK: – Navigation

    func openReflections() {
        AppCoordinator.shared.navigate(to: .reflection)
    }

    func openWeeklyReport() {
        AppCoordinator.shared.navigate(to: .weeklyReport)
    }
}
