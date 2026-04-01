import SwiftUI

@Observable
final class ReflectionViewModel {

    var groupedEntries: [(String, [ReflectionEntry])] = []
    var isLoading = false

    func onAppear() {
        load()
    }

    func load() {
        isLoading = true
        let all = ReflectionEntry.loadAll()
        groupedEntries = ReflectionEntry.groupedByDate(all)
        isLoading = false
    }

    func dismiss() {
        AppCoordinator.shared.navigate(to: .home)
    }

    var totalCount: Int {
        groupedEntries.reduce(0) { $0 + $1.1.count }
    }

    var isEmpty: Bool {
        groupedEntries.isEmpty
    }
}
