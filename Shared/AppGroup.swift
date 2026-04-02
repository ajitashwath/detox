import Foundation

enum AppGroup {
    static let identifier = "group.com.ajitashwath.detox"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: identifier)!
    }

    static var containerURL: URL {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: identifier)!
    }
}

extension AppGroup {
    enum Keys {
        static let hasCompletedOnboarding = "detox.hasCompletedOnboarding"
        static let isShieldActive = "detox.isShieldActive"
        static let selectedAppsData = "detox.selectedAppsData"
        static let reflectionEntries = "detox.reflectionEntries"
        static let pauseCountToday = "detox.pauseCountToday"
        static let lastPauseResetDate = "detox.lastPauseResetDate"
        static let weeklyPauseCounts = "detox.weeklyPauseCounts"
    }
}
