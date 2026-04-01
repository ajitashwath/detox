import SwiftUI
import Combine

@Observable
final class HomeViewModel {

    var pauseCount: Int = 0
    var isShieldActive: Bool = false
    var insightText: String = ""

    func onAppear() {
        refresh()
    }

    func refresh() {
        pauseCount = UserDefaultsManager.shared.pauseCountToday
        isShieldActive = UserDefaultsManager.shared.isShieldActive
        insightText = UserDefaultsManager.shared.currentInsightText
    }

    func toggleShield() {
        withAnimation(DetoxAnimation.breathe) {
            FamilyControlsManager.shared.toggleShield()
            isShieldActive = UserDefaultsManager.shared.isShieldActive
        }
    }

    func openReflections() {
        AppCoordinator.shared.navigate(to: .reflection)
    }

    func openWeeklyReport() {
        AppCoordinator.shared.navigate(to: .weeklyReport)
    }
}
