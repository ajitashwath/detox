import DeviceActivity
import Foundation
import SwiftUI

@main
struct DetoxDeviceActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        DetoxActivityReport()
    }
}

struct DetoxActivityReport: DeviceActivityReportScene {

    let context: DeviceActivityReport.Context = .init(rawValue: "detox.daily.report")

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) -> some DeviceActivityReportConfiguration {
        DetoxReportConfiguration(data: data)
    }
}

struct DetoxReportConfiguration: DeviceActivityReportConfiguration {
    let data: DeviceActivityResults<DeviceActivityData>

    func body(context: DeviceActivityReport.Context) -> some View {

        Color.clear
            .onAppear { aggregate() }
    }

    private func aggregate() {

        print("[DetoxDeviceActivity] Aggregation callback fired.")
    }
}
