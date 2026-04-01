// Date+Formatting.swift
// Detox – Date Utilities

import Foundation

extension Date {

    /// "10:42 AM" — used in the Reflection Timeline
    var reflectionTimeString: String {
        formatted(.dateTime.hour().minute())
    }

    /// "Mon" — used in Weekly Report bar chart labels
    var weekdayAbbreviation: String {
        formatted(.dateTime.weekday(.abbreviated))
    }

    /// "Week of Mar 31" — Weekly Report title
    var weekDisplayString: String {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) else { return "" }
        return "Week of \(startOfWeek.formatted(.dateTime.month(.abbreviated).day()))"
    }

    /// Returns all 7 days of the week containing this date (Mon–Sun).
    var currentWeekDays: [Date] {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    /// ISO date string for midnight resets.
    var isoDateString: String {
        ISO8601DateFormatter().string(from: self)
    }

    /// `true` if this date falls in the same calendar day as `other`.
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
