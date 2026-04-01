// AppGroup.swift
// Detox – Shared Constants for App Group Container
// Used by main app + all extension targets

import Foundation

/// All App Group identifiers and shared container keys in one place.
/// Every extension target must declare the same App Group entitlement.
enum AppGroup {

    /// The App Group identifier – must match exactly in all target entitlements.
    static let identifier = "group.com.ajitashwath.detox"

    /// Shared UserDefaults suite for cross-target communication.
    static var defaults: UserDefaults {
        UserDefaults(suiteName: identifier)!
    }

    /// Shared container URL for file storage (voice recordings, etc.)
    static var containerURL: URL {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: identifier)!
    }
}

// MARK: – Storage Keys

extension AppGroup {

    enum Keys {
        /// `Bool` – Has the user completed onboarding?
        static let hasCompletedOnboarding = "detox.hasCompletedOnboarding"

        /// `Bool` – Is the detox shield actively blocking apps?
        static let isShieldActive = "detox.isShieldActive"

        /// `Data` – JSON-encoded `FamilyActivitySelection`
        static let selectedAppsData = "detox.selectedAppsData"

        /// `Data` – JSON-encoded `[ReflectionEntry]`
        static let reflectionEntries = "detox.reflectionEntries"

        /// `Int` – Total pauses recorded today (reset at midnight)
        static let pauseCountToday = "detox.pauseCountToday"

        /// `String` – ISO date string of the last pause-count reset
        static let lastPauseResetDate = "detox.lastPauseResetDate"

        /// `Data` – JSON-encoded `[String: Int]` (bundle ID → weekly pause count)
        static let weeklyPauseCounts = "detox.weeklyPauseCounts"
    }
}
