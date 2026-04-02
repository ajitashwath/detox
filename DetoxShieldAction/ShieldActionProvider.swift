import ManagedSettings
import DeviceActivity

final class ShieldActionProvider: ShieldActionDataSource {
    private let store = ManagedSettingsStore()
    override func handle(action: ShieldAction, for application: Application, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            unlockTemporarily(application: application)
            completionHandler(.close)

        case .secondaryButtonPressed:
            completionHandler(.defer)

        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(action: ShieldAction, for application: Application, in category: ActivityCategory, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handle(action: action, for: application, completionHandler: completionHandler)
    }

    private func unlockTemporarily(application: Application) {
        guard let bundleID = application.bundleIdentifier else { return }

        var currentApps = store.shield.applications ?? []
        currentApps.remove(Application(bundleIdentifier: bundleID))
        store.shield.applications = currentApps

        DispatchQueue.global().asyncAfter(deadline: .now() + 30) { [weak self] in
            guard let self else { return }
            var apps = self.store.shield.applications ?? []
            apps.insert(Application(bundleIdentifier: bundleID))
            self.store.shield.applications = apps
        }
    }
}
