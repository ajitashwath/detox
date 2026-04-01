// DeviceActivityManager.swift
// Detox – Usage Tracking via DeviceActivity framework

import Foundation
import DeviceActivity
import Combine

/// Manages DeviceActivity schedules and aggregates usage data
/// for the Home screen stat and Weekly Report.
///
/// - The main schedule runs midnight → midnight daily.
/// - The extension `DetoxDeviceActivity` receives callbacks and
///   writes aggregated data into the shared App Group container.
@Observable
final class DeviceActivityManager {

    static let shared = DeviceActivityManager()

    private let center = DeviceActivityCenter()

    // MARK: – Schedule Names

    enum ScheduleName {
        static let daily  = DeviceActivityName("detox.daily")
        static let weekly = DeviceActivityName("detox.weekly")
    }

    // MARK: – Start Monitoring

    /// Begin monitoring. Call after FamilyControls is authorized.
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

    // MARK: – Derived Stats (read from App Group)

    /// Today's pause count — incremented by the ShieldAction extension on each interception.
    var pauseCountToday: Int {
        UserDefaultsManager.shared.pauseCountToday
    }

    /// Build `WeeklyStats` from stored `ReflectionEntry` records.
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

    /// Most paused app this week (by bundle ID).
    func topBlockedApp() -> String? {
        let counts = UserDefaultsManager.shared.weeklyPauseCounts
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
