import ManagedSettings
import ManagedSettingsUI
import SwiftUI

final class ShieldConfigurationProvider: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {

        ShieldConfiguration(
            backgroundBlurStyle: .none,
            backgroundColor: .black,
            icon: nil,
            title: ShieldConfiguration.Label(
                text: "Detox",
                color: .clear
            ),
            subtitle: ShieldConfiguration.Label(
                text: "",
                color: .clear
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "",
                color: .clear
            ),
            primaryButtonBackgroundColor: .clear,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "",
                color: .clear
            )
        )
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        configuration(shielding: application)
    }
}
