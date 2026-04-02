import Foundation
import FamilyControls

struct AppSelectionStore {
    static func save(_ selection: FamilyActivitySelection) {
        if let data = try? JSONEncoder().encode(selection) {
            AppGroup.defaults.set(data, forKey: AppGroup.Keys.selectedAppsData)
        }
    }

    static func load() -> FamilyActivitySelection {
        guard let data = AppGroup.defaults.data(forKey: AppGroup.Keys.selectedAppsData),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return FamilyActivitySelection() }
        return selection
    }

    static var hasSelection: Bool {
        let s = load()
        return !s.applications.isEmpty || !s.categories.isEmpty
    }
}
