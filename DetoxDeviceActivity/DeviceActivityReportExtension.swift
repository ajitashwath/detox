// DeviceActivityReportExtension.swift
// DetoxDeviceActivity Extension – Usage Reporting
//
// Apple calls this extension periodically based on the DeviceActivitySchedule.
// We use it to flush daily/weekly aggregations into the shared App Group.

import DeviceActivity
import Foundation
import SwiftUI

/// Extension entry point for DeviceActivity reporting callbacks.
@main
struct DetoxDeviceActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        DetoxActivityReport()
    }
}

/// Handles interval start/end events for the daily schedule.
struct DetoxActivityReport: DeviceActivityReportScene {

    let context: DeviceActivityReport.Context = .init(rawValue: "detox.daily.report")

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) -> some DeviceActivityReportConfiguration {
        DetoxReportConfiguration(data: data)
    }
}

struct DetoxReportConfiguration: DeviceActivityReportConfiguration {
    let data: DeviceActivityResults<DeviceActivityData>

    func body(context: DeviceActivityReport.Context) -> some View {
        // This view is not visible to the user — it's a background aggregation point.
        // Real aggregation happens in the main app by reading ReflectionEntry records.
        // This extension exists mainly to satisfy the DeviceActivity API requirement.
        Color.clear
            .onAppear { aggregate() }
    }

    private func aggregate() {
        // Future: Walk `data` to extract per-app screen time and store in App Group.
        // For MVP, the main app derives stats from ReflectionEntry records directly.
        print("[DetoxDeviceActivity] Aggregation callback fired.")
    }
}
