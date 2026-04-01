// ShieldActionProvider.swift
// DetoxShieldAction Extension – Handles "Continue anyway"
//
// Apple calls this when the user takes an action on the shield screen.
// Our implementation unlocks the app temporarily when the user holds "Continue anyway".

import ManagedSettings
import DeviceActivity

/// Handles button taps on the shield overlay.
/// NSExtensionPrincipalClass must point to this class in the extension's Info.plist.
final class ShieldActionProvider: ShieldActionDataSource {

    private let store = ManagedSettingsStore()

    /// Called when the user presses the primary action (we repurpose this as "Continue").
    override func handle(action: ShieldAction, for application: Application, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // "Continue anyway" was held – temporarily unblock this app
            unlockTemporarily(application: application)
            completionHandler(.close)

        case .secondaryButtonPressed:
            // Secondary = dismiss shield without opening the app
            completionHandler(.defer)

        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(action: ShieldAction, for application: Application, in category: ActivityCategory, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handle(action: action, for: application, completionHandler: completionHandler)
    }

    // MARK: – Temporary Unlock

    private func unlockTemporarily(application: Application) {
        guard let bundleID = application.bundleIdentifier else { return }

        // Remove from the shielded set for 30 seconds
        var currentApps = store.shield.applications ?? []
        currentApps.remove(Application(bundleIdentifier: bundleID))
        store.shield.applications = currentApps

        // Re-add after 30 seconds (best-effort background execution)
        DispatchQueue.global().asyncAfter(deadline: .now() + 30) { [weak self] in
            guard let self else { return }
            var apps = self.store.shield.applications ?? []
            apps.insert(Application(bundleIdentifier: bundleID))
            self.store.shield.applications = apps
        }
    }
}
