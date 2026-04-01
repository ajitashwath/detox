// FamilyControlsManager.swift
// Detox – App Selection & Blocking Engine
//
// PREREQUISITES:
//  1. Add `com.apple.developer.family-controls` entitlement to Detox.entitlements
//  2. Add the same App Group to all targets
//  3. Must run on a real device (not Simulator)

import Foundation
import FamilyControls
import ManagedSettings
import Combine

@Observable
final class FamilyControlsManager {

    static let shared = FamilyControlsManager()

    // MARK: – State

    /// Current app selection (bound to the FamilyActivityPicker)
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

    // MARK: – Authorization

    /// Request FamilyControls permission.
    /// Must be called from a user-initiated action (button tap).
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

    // MARK: – Shield Control

    /// Enable app blocking for all selected apps.
    func enableShield() {
        guard authorizationStatus == .approved else { return }
        store.shield.applications = selection.applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(
            selection.categories
        )
        UserDefaultsManager.shared.isShieldActive = true
    }

    /// Remove all shields (disable blocking).
    func disableShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = .none
        UserDefaultsManager.shared.isShieldActive = false
    }

    /// Toggle the shield on or off.
    func toggleShield() {
        if UserDefaultsManager.shared.isShieldActive {
            disableShield()
        } else {
            enableShield()
        }
    }

    /// Temporarily unblock a single app for 30 seconds (called from ShieldActionProvider).
    func temporarilyUnblock(bundleID: String) {
        var apps = store.shield.applications ?? []
        apps.remove(Application(bundleIdentifier: bundleID))
        store.shield.applications = apps

        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.enableShield()
        }
    }
}
