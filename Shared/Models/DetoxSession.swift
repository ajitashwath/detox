// DetoxSession.swift
// Detox – Session & Streak Model

import Foundation

/// Aggregated statistics for a single calendar day.
struct DailyStats: Codable {
    let date: Date
    var pauseCount: Int
    var continueCount: Int  // Times the user pressed "Continue anyway"
    var voiceNoteCount: Int
    var typedNoteCount: Int

    /// Percentage of pauses where the user reflected (vs. skipped).
    var reflectionRate: Double {
        guard pauseCount > 0 else { return 0 }
        return Double(voiceNoteCount + typedNoteCount) / Double(pauseCount)
    }
}

/// Weekly aggregate used by the Weekly Report screen.
struct WeeklyStats {
    let weekStartDate: Date
    var dailyStats: [DailyStats]  // Ordered Mon–Sun

    var totalPauses: Int {
        dailyStats.reduce(0) { $0 + $1.pauseCount }
    }

    /// Rough "time reclaimed" estimate: assume 8 minutes average session displaced per pause.
    var timeReclaimedMinutes: Int {
        totalPauses * 8
    }

    var timeReclaimedDisplay: String {
        let minutes = timeReclaimedMinutes
        if minutes < 60 { return "\(minutes) min" }
        let hours = minutes / 60
        let remainder = minutes % 60
        return remainder == 0 ? "\(hours) hr" : "\(hours) hr \(remainder) min"
    }

    var mostPausedDay: DailyStats? {
        dailyStats.max { $0.pauseCount < $1.pauseCount }
    }

    /// Peak pause count across the week (for bar chart scaling).
    var maxDailyPauseCount: Int {
        dailyStats.map(\.pauseCount).max() ?? 1
    }
}
