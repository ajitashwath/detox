import Foundation

struct DailyStats: Codable {
    let date: Date
    var pauseCount: Int
    var continueCount: Int
    var voiceNoteCount: Int
    var typedNoteCount: Int

    var reflectionRate: Double {
        guard pauseCount > 0 else { return 0 }
        return Double(voiceNoteCount + typedNoteCount) / Double(pauseCount)
    }
}

struct WeeklyStats {
    let weekStartDate: Date
    var dailyStats: [DailyStats]

    var totalPauses: Int {
        dailyStats.reduce(0) { $0 + $1.pauseCount }
    }

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

    var maxDailyPauseCount: Int {
        dailyStats.map(\.pauseCount).max() ?? 1
    }
}
