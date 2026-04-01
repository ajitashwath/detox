// WeeklyReportViewModel.swift
// Detox – Weekly Report Logic

import SwiftUI

@Observable
final class WeeklyReportViewModel {

    var weeklyStats: WeeklyStats?
    var topAppName: String = "—"

    func onAppear() {
        weeklyStats = DeviceActivityManager.shared.buildWeeklyStats()
        if let bundleID = DeviceActivityManager.shared.topBlockedApp() {
            // In a real build, use LSApplicationWorkspace to resolve display name.
            // For now we show the bundle ID's last component as a fallback.
            topAppName = bundleID.components(separatedBy: ".").last?.capitalized ?? bundleID
        }
    }

    func dismiss() {
        AppCoordinator.shared.navigate(to: .home)
    }

    // MARK: – Chart Helpers

    var weekDayLabels: [String] {
        weeklyStats?.dailyStats.map { $0.date.weekdayAbbreviation } ?? []
    }

    /// Normalised bar height (0.0 – 1.0) for each day.
    var normalisedBarHeights: [Double] {
        guard let stats = weeklyStats, stats.maxDailyPauseCount > 0 else { return [] }
        return stats.dailyStats.map {
            Double($0.pauseCount) / Double(stats.maxDailyPauseCount)
        }
    }
}
