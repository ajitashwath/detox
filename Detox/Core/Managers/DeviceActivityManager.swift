import Foundation
import DeviceActivity
import Combine

@Observable
final class DeviceActivityManager {

    static let shared = DeviceActivityManager()

    private let center = DeviceActivityCenter()

    enum ScheduleName {
        static let daily  = DeviceActivityName("detox.daily")
        static let weekly = DeviceActivityName("detox.weekly")
    }

    func startDailyMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd:   DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        do {
            try center.startMonitoring(ScheduleName.daily, during: schedule)
        } catch {
            print("[DeviceActivityManager] Failed to start monitoring: \(error)")
        }
    }

    func stopMonitoring() {
        center.stopMonitoring([ScheduleName.daily, ScheduleName.weekly])
    }

    var pauseCountToday: Int {
        UserDefaultsManager.shared.pauseCountToday
    }

    func buildWeeklyStats() -> WeeklyStats {
        let allEntries = ReflectionEntry.loadAll()
        let calendar = Calendar.current
        let today = Date()
        let weekDays = today.currentWeekDays

        let dailyStats: [DailyStats] = weekDays.map { day in
            let dayEntries = allEntries.filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
            return DailyStats(
                date: day,
                pauseCount: dayEntries.count,
                continueCount: dayEntries.filter(\.didContinue).count,
                voiceNoteCount: dayEntries.filter { $0.responseType == .voice }.count,
                typedNoteCount: dayEntries.filter { $0.responseType == .typed }.count
            )
        }

        return WeeklyStats(weekStartDate: weekDays.first ?? today, dailyStats: dailyStats)
    }

    func topBlockedApp() -> String? {
        let counts = UserDefaultsManager.shared.weeklyPauseCounts
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
