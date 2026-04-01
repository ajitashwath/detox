# Detox – Digital Wellbeing iOS App

> A hyper-minimalist iOS app that introduces a moment of pause before opening distracting apps.
> 
> *"The app should feel like a mirror, not a wall."*

---

## Overview

Detox gently intercepts impulsive app-opening behaviour by surfacing a single reflective question:

> **Why are you opening this?**

Users can record a voice note, type a reason, or hold to continue. Over time, the act of pausing builds awareness — without ever blocking.

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI (iOS 17+, `@Observable`) |
| App Blocking | FamilyControls + ManagedSettings |
| Usage Tracking | DeviceActivity |
| Voice Input | AVFoundation |
| Storage | UserDefaults via App Group |
| Architecture | MVVM + Features-based modular structure |

---

## Project Structure

```
Detox/          → Main app (5 screens)
DetoxShieldUI/  → Interception screen extension
DetoxShieldAction/ → "Continue anyway" handler
DetoxDeviceActivity/ → Background usage aggregation
Shared/         → Models shared across all targets
```

---

## Screens

1. **Onboarding** — App selection via native FamilyActivityPicker
2. **Home** — Animated pause count, monochrome toggle
3. **Interception Shield** — Full black screen, character-reveal headline, voice/type/skip
4. **Reflection Timeline** — Chronological log of all pauses
5. **Weekly Report** — Pure SwiftUI bar chart, time-reclaimed headline

---

## Setup

See **[SETUP.md](./SETUP.md)** for complete Xcode project configuration instructions.

**Requirements:**
- Xcode 15+
- iOS 17+ physical device
- Paid Apple Developer account (FamilyControls entitlement)

---

## Design Principles

- **Strictly black & white** — no colors, no gradients
- **8pt grid** — all spacing derived from `Spacing.swift`
- **Slow animations only** — all motion tokens in `Animations.swift`
- **Typography as hierarchy** — weight and opacity, never color
- **Offline-first** — zero backend required for MVP

---

*Calm. Controlled. Reflective. Premium.*
