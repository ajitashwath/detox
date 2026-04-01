import Foundation
import FamilyControls
import ManagedSettings
import Combine

@Observable
final class FamilyControlsManager {

    static let shared = FamilyControlsManager()

    var selection: FamilyActivitySelection = AppSelectionStore.load() {
        didSet { AppSelectionStore.save(selection) }
    }

    var authorizationStatus: AuthorizationStatus = .notDetermined
    var authorizationError: Error?

    private let store = ManagedSettingsStore()
    private let authCenter = AuthorizationCenter.shared

    enum AuthorizationStatus {
        case notDetermined, approved, denied
    }

    @MainActor
    func requestAuthorization() async {
        do {
            try await authCenter.requestAuthorization(for: .individual)
            authorizationStatus = .approved
        } catch {
            authorizationStatus = .denied
            authorizationError = error
        }
    }

    func enableShield() {
        guard authorizationStatus == .approved else { return }
        store.shield.applications = selection.applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(
            selection.categories
        )
        UserDefaultsManager.shared.isShieldActive = true
    }

    func disableShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = .none
        UserDefaultsManager.shared.isShieldActive = false
    }

    func toggleShield() {
        if UserDefaultsManager.shared.isShieldActive {
            disableShield()
        } else {
            enableShield()
        }
    }

    func temporarilyUnblock(bundleID: String) {
        var apps = store.shield.applications ?? []
        apps.remove(Application(bundleIdentifier: bundleID))
        store.shield.applications = apps

        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.enableShield()
        }
    }
}
