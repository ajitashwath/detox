import SwiftUI
import FamilyControls

@Observable
final class OnboardingViewModel {

    var isPickerPresented = false
    var isRequestingPermission = false
    var permissionError: String?
    var hasSelection: Bool { AppSelectionStore.hasSelection }

    var selection: FamilyActivitySelection {
        get { FamilyControlsManager.shared.selection }
        set { FamilyControlsManager.shared.selection = newValue }
    }

    @MainActor
    func requestPermissionAndShowPicker() async {
        isRequestingPermission = true
        await FamilyControlsManager.shared.requestAuthorization()

        switch FamilyControlsManager.shared.authorizationStatus {
        case .approved:
            isPickerPresented = true
        case .denied:
            permissionError = """
                Screen Time access is required.
                Go to Settings → Screen Time and enable access for Detox.
                """
        case .notDetermined:
            break
        }

        isRequestingPermission = false
    }

    func completeOnboarding() {

        DeviceActivityManager.shared.startDailyMonitoring()

        AppCoordinator.shared.completeOnboarding()
    }
}
