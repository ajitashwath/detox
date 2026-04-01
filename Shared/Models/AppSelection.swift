// AppSelection.swift
// Detox – App Selection Model

import Foundation
import FamilyControls

/// Wraps `FamilyActivitySelection` for persistence via the App Group container.
/// The shield extension reads this to know which apps to intercept.
struct AppSelectionStore {

    // MARK: – Persistence

    /// Save a `FamilyActivitySelection` to the shared container.
    static func save(_ selection: FamilyActivitySelection) {
        if let data = try? JSONEncoder().encode(selection) {
            AppGroup.defaults.set(data, forKey: AppGroup.Keys.selectedAppsData)
        }
    }

    /// Load the stored `FamilyActivitySelection`, or return an empty selection.
    static func load() -> FamilyActivitySelection {
        guard let data = AppGroup.defaults.data(forKey: AppGroup.Keys.selectedAppsData),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return FamilyActivitySelection() }
        return selection
    }

    /// `true` if the user has selected at least one app.
    static var hasSelection: Bool {
        let s = load()
        return !s.applications.isEmpty || !s.categories.isEmpty
    }
}
