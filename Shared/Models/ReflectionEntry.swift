// ReflectionEntry.swift
// Detox – Core Data Model

import Foundation

/// A single moment of pause. The atomic unit of the Detox experience.
/// Created each time a user encounters the interception screen.
struct ReflectionEntry: Codable, Identifiable, Hashable {

    let id: UUID
    let timestamp: Date
    let appBundleID: String
    let appDisplayName: String
    let responseType: ResponseType
    let textContent: String?
    let voiceFileURL: URL?
    let didContinue: Bool  // true = user continued into the app anyway

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        appBundleID: String,
        appDisplayName: String,
        responseType: ResponseType,
        textContent: String? = nil,
        voiceFileURL: URL? = nil,
        didContinue: Bool
    ) {
        self.id = id
        self.timestamp = timestamp
        self.appBundleID = appBundleID
        self.appDisplayName = appDisplayName
        self.responseType = responseType
        self.textContent = textContent
        self.voiceFileURL = voiceFileURL
        self.didContinue = didContinue
    }
}

// MARK: – Response Type

extension ReflectionEntry {

    enum ResponseType: String, Codable, CaseIterable {
        case voice   = "voice"    // User recorded a voice note
        case typed   = "typed"    // User typed a reason
        case skipped = "skipped"  // User pressed "Continue anyway"
    }
}

// MARK: – Persistence Helpers

extension ReflectionEntry {

    /// Load all entries from the shared App Group container.
    static func loadAll() -> [ReflectionEntry] {
        guard let data = AppGroup.defaults.data(forKey: AppGroup.Keys.reflectionEntries),
              let entries = try? JSONDecoder().decode([ReflectionEntry].self, from: data)
        else { return [] }
        return entries.sorted { $0.timestamp > $1.timestamp }
    }

    /// Persist a new entry, appending it to existing entries.
    static func save(_ entry: ReflectionEntry) {
        var existing = loadAll()
        existing.insert(entry, at: 0)
        // Keep only the last 500 entries to avoid bloat
        let trimmed = Array(existing.prefix(500))
        if let data = try? JSONEncoder().encode(trimmed) {
            AppGroup.defaults.set(data, forKey: AppGroup.Keys.reflectionEntries)
        }
    }

    /// Grouped by relative date string (Today, Yesterday, or formatted date).
    static func groupedByDate(_ entries: [ReflectionEntry]) -> [(String, [ReflectionEntry])] {
        let calendar = Calendar.current
        var groups: [(String, [ReflectionEntry])] = []
        var seen: [String: Int] = [:]

        for entry in entries {
            let label: String
            if calendar.isDateInToday(entry.timestamp) {
                label = "Today"
            } else if calendar.isDateInYesterday(entry.timestamp) {
                label = "Yesterday"
            } else {
                label = entry.timestamp.formatted(.dateTime.weekday(.wide).month().day())
            }

            if let idx = seen[label] {
                groups[idx].1.append(entry)
            } else {
                seen[label] = groups.count
                groups.append((label, [entry]))
            }
        }
        return groups
    }
}
