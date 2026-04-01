import SwiftUI

@Observable
final class WeeklyReportViewModel {

    var weeklyStats: WeeklyStats?
    var topAppName: String = "—"

    func onAppear() {
        weeklyStats = DeviceActivityManager.shared.buildWeeklyStats()
        if let bundleID = DeviceActivityManager.shared.topBlockedApp() {

            topAppName = bundleID.components(separatedBy: ".").last?.capitalized ?? bundleID
        }
    }

    func dismiss() {
        AppCoordinator.shared.navigate(to: .home)
    }

    var weekDayLabels: [String] {
        weeklyStats?.dailyStats.map { $0.date.weekdayAbbreviation } ?? []
    }

    var normalisedBarHeights: [Double] {
        guard let stats = weeklyStats, stats.maxDailyPauseCount > 0 else { return [] }
        return stats.dailyStats.map {
            Double($0.pauseCount) / Double(stats.maxDailyPauseCount)
        }
    }
}
