// ShieldConfigurationProvider.swift
// DetoxShieldUI Extension – Shield UI Configuration
//
// This class is the extension's entry point.
// Apple calls it when a shielded app is tapped.
// It returns a ShieldConfiguration that renders ShieldInterceptionView.

import ManagedSettings
import ManagedSettingsUI
import SwiftUI

/// Provides the custom shield UI for blocked apps.
/// The class name must match the NSExtensionPrincipalClass in Info.plist.
final class ShieldConfigurationProvider: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // We use the native shield infrastructure but supply a fully custom view.
        // The title/subtitle are hidden behind our overlay — but required by the API.
        ShieldConfiguration(
            backgroundBlurStyle: .none,
            backgroundColor: .black,
            icon: nil,
            title: ShieldConfiguration.Label(
                text: "Detox",
                color: .clear      // We render our own header in ShieldInterceptionView
            ),
            subtitle: ShieldConfiguration.Label(
                text: "",
                color: .clear
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "",          // Buttons handled in SwiftUI overlay
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

// MARK: – Extension Host View
// NOTE: To render full SwiftUI over the shield, embed ShieldInterceptionView
// in your extension's SwiftUI scene via a UIHostingController in the
// extension's principal view controller. Wire it here or in the extension's
// Info.plist NSExtensionMainStoryboard / NSExtensionPrincipalClass.
//
// Minimal wiring — add to extension's Info.plist:
// NSExtensionPrincipalClass = DetoxShieldUI.ShieldConfigurationProvider
