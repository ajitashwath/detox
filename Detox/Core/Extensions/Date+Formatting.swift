import Foundation

extension Date {

    var reflectionTimeString: String {
        formatted(.dateTime.hour().minute())
    }

    var weekdayAbbreviation: String {
        formatted(.dateTime.weekday(.abbreviated))
    }

    var weekDisplayString: String {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) else { return "" }
        return "Week of \(startOfWeek.formatted(.dateTime.month(.abbreviated).day()))"
    }

    var currentWeekDays: [Date] {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    var isoDateString: String {
        ISO8601DateFormatter().string(from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
