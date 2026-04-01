// UserDefaultsManager.swift
// Detox – Local Storage Layer

import Foundation
import Combine

/// Centralised access layer for all UserDefaults reads and writes.
/// Uses the shared App Group suite so extensions can also read/write.
@Observable
final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let defaults = AppGroup.defaults

    // MARK: – Onboarding State

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: AppGroup.Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: AppGroup.Keys.hasCompletedOnboarding) }
    }

    // MARK: – Shield State

    var isShieldActive: Bool {
        get { defaults.bool(forKey: AppGroup.Keys.isShieldActive) }
        set { defaults.set(newValue, forKey: AppGroup.Keys.isShieldActive) }
    }

    // MARK: – Pause Counting

    /// Returns today's pause count, resetting to 0 if the stored date is not today.
    var pauseCountToday: Int {
        get {
            resetPauseCountIfNeeded()
            return defaults.integer(forKey: AppGroup.Keys.pauseCountToday)
        }
    }

    func incrementPauseCount() {
        resetPauseCountIfNeeded()
        let current = defaults.integer(forKey: AppGroup.Keys.pauseCountToday)
        defaults.set(current + 1, forKey: AppGroup.Keys.pauseCountToday)
    }

    private func resetPauseCountIfNeeded() {
        let stored = defaults.string(forKey: AppGroup.Keys.lastPauseResetDate) ?? ""
        let today = Date().isoDateString
        if stored != today {
            defaults.set(0, forKey: AppGroup.Keys.pauseCountToday)
            defaults.set(today, forKey: AppGroup.Keys.lastPauseResetDate)
        }
    }

    // MARK: – Weekly Pause Counts

    /// `[bundleID: pauseCount]` for the current week.
    var weeklyPauseCounts: [String: Int] {
        get {
            guard let data = defaults.data(forKey: AppGroup.Keys.weeklyPauseCounts),
                  let dict = try? JSONDecoder().decode([String: Int].self, from: data)
            else { return [:] }
            return dict
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: AppGroup.Keys.weeklyPauseCounts)
            }
        }
    }

    func incrementWeeklyPauseCount(forBundleID bundleID: String) {
        var counts = weeklyPauseCounts
        counts[bundleID, default: 0] += 1
        weeklyPauseCounts = counts
    }

    // MARK: – Insight Text (cycling)

    private let insightTexts = [
        "You're building awareness.",
        "Every pause is a choice reclaimed.",
        "You've been intentional today.",
        "Patterns need noticing before they can change.",
        "The pause is the practice.",
        "Awareness precedes change.",
        "A moment of reflection changes nothing. Many moments change everything.",
    ]

    var currentInsightText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return insightTexts[hour % insightTexts.count]
    }
}
