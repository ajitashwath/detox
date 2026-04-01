# Detox – Xcode Project Setup Guide

> **Platform**: iOS 17+  
> **Language**: Swift 5.9 / SwiftUI  
> **Bundle ID**: `com.ajitashwath.detox`  
> **App Group**: `group.com.ajitashwath.detox`

---

## Prerequisites

- Xcode 15+
- A **paid Apple Developer account** (FamilyControls requires it)
- A **physical iPhone** (FamilyControls cannot be tested in Simulator)
- FamilyControls entitlement activated in your developer portal

---

## Step 1 – Create the Xcode Project

1. Open Xcode → **File → New → Project**
2. Choose **iOS → App**
3. Fill in:
   - **Product Name**: `Detox`
   - **Bundle Identifier**: `com.ajitashwath.detox`
   - **Team**: your Apple Developer team
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Minimum Deployment**: iOS 17.0
4. Set the project location to this repository root (`e:/detox/`)
5. **Uncheck** "Create Git repository" (we already have one)

---

## Step 2 – Add All Source Files

After creating the project, add the existing source files by **dragging into the Xcode navigator**:

### Main Target (`Detox`)
Drag these folder groups into the `Detox` target:
```
Detox/App/
Detox/Core/
Detox/Features/
```

Also drag in (as shared files, not a separate target):
```
Shared/
```
> In the file inspector, uncheck "Target Membership" for all Shared files — we'll re-add them to every target manually in Step 4.

---

## Step 3 – Create Extension Targets

For each extension, go to **File → New → Target** in Xcode:

### 3a. Shield UI Extension
- Template: **Shield Configuration Extension**
- Product Name: `DetoxShieldUI`
- Bundle ID: `com.ajitashwath.detox.shieldui`
- Embed in: `Detox`

After creation:
- Delete the auto-generated stub files
- Add `DetoxShieldUI/ShieldConfigurationProvider.swift`
- Add `DetoxShieldUI/ShieldInterceptionView.swift`
- Add all `Shared/` files with membership in `DetoxShieldUI`

### 3b. Shield Action Extension
- Template: **Shield Action Extension**
- Product Name: `DetoxShieldAction`
- Bundle ID: `com.ajitashwath.detox.shieldaction`
- Embed in: `Detox`

After creation:
- Delete auto-generated stubs
- Add `DetoxShieldAction/ShieldActionProvider.swift`
- Add all `Shared/` files with membership in `DetoxShieldAction`

### 3c. Device Activity Extension
- Template: **Device Activity Report Extension**
- Product Name: `DetoxDeviceActivity`
- Bundle ID: `com.ajitashwath.detox.deviceactivity`
- Embed in: `Detox`

After creation:
- Delete auto-generated stubs
- Add `DetoxDeviceActivity/DeviceActivityReportExtension.swift`

---

## Step 4 – Configure Target Memberships for Shared Files

Select each file in `Shared/` and in the **File Inspector (right panel)** check the box for every target that needs it:

| File | Detox | DetoxShieldUI | DetoxShieldAction | DetoxDeviceActivity |
|---|:---:|:---:|:---:|:---:|
| `AppGroup.swift` | ✓ | ✓ | ✓ | ✓ |
| `ReflectionEntry.swift` | ✓ | ✓ | ✓ | — |
| `AppSelection.swift` | ✓ | ✓ | ✓ | — |
| `DetoxSession.swift` | ✓ | — | — | — |

Also share these Core files with the Shield extension:
| File | DetoxShieldUI | DetoxShieldAction |
|---|:---:|:---:|
| `Core/Theme/Typography.swift` | ✓ | — |
| `Core/Theme/Spacing.swift` | ✓ | — |
| `Core/Theme/Animations.swift` | ✓ | — |
| `Core/Extensions/View+Modifiers.swift` | ✓ | — |
| `Core/Storage/UserDefaultsManager.swift` | ✓ | ✓ |
| `Core/Managers/VoiceInputManager.swift` | ✓ | — |

---

## Step 5 – Configure Signing & Capabilities

For **each target** (Detox, DetoxShieldUI, DetoxShieldAction, DetoxDeviceActivity):

1. Select the target → **Signing & Capabilities** tab
2. Set **Team** to your Apple Developer team
3. Click **+ Capability** and add:
   - **App Groups** → add `group.com.ajitashwath.detox`
4. For the main `Detox` target only, also add:
   - **Family Controls**
   - **Microphone** (via Privacy – Microphone Usage Description in Info.plist)

---

## Step 6 – Info.plist Entries

### Main App (`Detox/Info.plist`)
Add these keys:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Detox records a short voice note when you pause before opening an app.</string>

<key>NSFaceIDUsageDescription</key>
<string>Used for secure access to your reflection history.</string>
```

### DetoxShieldUI Info.plist
Ensure `NSExtensionPrincipalClass` is set to:
```
$(PRODUCT_MODULE_NAME).ShieldConfigurationProvider
```

### DetoxShieldAction Info.plist
Ensure `NSExtensionPrincipalClass` is set to:
```
$(PRODUCT_MODULE_NAME).ShieldActionProvider
```

---

## Step 7 – Assign Entitlements Files

For each target, go to **Build Settings** → search **Code Signing Entitlements** → set the path:

| Target | Entitlements Path |
|---|---|
| Detox | `Detox/Detox.entitlements` |
| DetoxShieldUI | `DetoxShieldUI/DetoxShieldUI.entitlements` |
| DetoxShieldAction | `DetoxShieldAction/DetoxShieldAction.entitlements` |
| DetoxDeviceActivity | `DetoxDeviceActivity/DetoxDeviceActivity.entitlements` |

---

## Step 8 – Build & Run

1. Select your **physical iPhone** as the build target (not Simulator)
2. Build with **⌘ + B** — resolve any import errors first
3. Run with **⌘ + R**
4. Complete the onboarding flow:
   - Grant FamilyControls permission (Settings → Screen Time → This is My iPhone)
   - Select one or more apps
   - Toggle the shield ON
5. Open a blocked app — the interception screen should appear

---

## Project Structure Reference

```
e:/detox/
├── Detox/                          ← Main app target
│   ├── App/
│   │   ├── DetoxApp.swift
│   │   └── AppCoordinator.swift
│   ├── Core/
│   │   ├── Theme/
│   │   │   ├── Typography.swift
│   │   │   ├── Spacing.swift
│   │   │   └── Animations.swift
│   │   ├── Extensions/
│   │   │   ├── View+Modifiers.swift
│   │   │   └── Date+Formatting.swift
│   │   ├── Storage/
│   │   │   └── UserDefaultsManager.swift
│   │   └── Managers/
│   │       ├── FamilyControlsManager.swift
│   │       ├── DeviceActivityManager.swift
│   │       └── VoiceInputManager.swift
│   ├── Features/
│   │   ├── Onboarding/
│   │   ├── Home/
│   │   ├── Reflection/
│   │   └── WeeklyReport/
│   └── Detox.entitlements
│
├── DetoxShieldUI/                  ← ShieldConfigurationExtension
│   ├── ShieldConfigurationProvider.swift
│   ├── ShieldInterceptionView.swift
│   └── DetoxShieldUI.entitlements
│
├── DetoxShieldAction/              ← ShieldActionExtension
│   ├── ShieldActionProvider.swift
│   └── DetoxShieldAction.entitlements
│
├── DetoxDeviceActivity/            ← DeviceActivityReportExtension
│   ├── DeviceActivityReportExtension.swift
│   └── DetoxDeviceActivity.entitlements
│
└── Shared/                         ← Shared between all targets
    ├── AppGroup.swift
    └── Models/
        ├── ReflectionEntry.swift
        ├── AppSelection.swift
        └── DetoxSession.swift
```

---

## Common Issues

| Issue | Fix |
|---|---|
| `FamilyControls` import error in Simulator | Switch destination to a physical device |
| `ManagedSettings` shield doesn't appear | Ensure shield is applied via `ManagedSettingsStore` AND the device has Screen Time enabled |
| App Group not shared | Double-check capability is added to **every** target, not just the main app |
| Voice recording permission crash | Add `NSMicrophoneUsageDescription` to main app's Info.plist |
| Shield extension not loading | Verify `NSExtensionPrincipalClass` matches the exact class name |

---

## Architecture Notes

- All shared state flows through the **App Group container** (`group.com.ajitashwath.detox`)
- The main app and extensions never communicate via XPC or URLs — only through the **shared UserDefaults suite** and **files in the shared container**
- `@Observable` (iOS 17 macro) is used throughout for reactive state — no `ObservableObject`/`@Published` needed
- All animations are expressed as named tokens in `Animations.swift` — never hardcode durations inline
