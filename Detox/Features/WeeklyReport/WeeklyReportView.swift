import SwiftUI

struct WeeklyReportView: View {

    @State private var viewModel = WeeklyReportViewModel()
    @State private var contentVisible = false
    @State private var barsAnimated = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        heroSection
                            .opacity(contentVisible ? 1 : 0)
                            .offset(y: contentVisible ? 0 : 20)
                            .padding(.top, Spacing.xxl)
                            .screenPadding()

                        DetoxDivider()
                            .padding(.vertical, Spacing.xxl)
                            .padding(.horizontal, Spacing.screenHorizontal)

                        barChartSection
                            .opacity(contentVisible ? 1 : 0)
                            .screenPadding()

                        DetoxDivider()
                            .padding(.vertical, Spacing.xxl)
                            .padding(.horizontal, Spacing.screenHorizontal)

                        insightsSection
                            .opacity(contentVisible ? 1 : 0)
                            .screenPadding()

                        Spacer().frame(height: Spacing.massive)
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
            withAnimation(DetoxAnimation.slow.delay(0.2)) { contentVisible = true }
            withAnimation(DetoxAnimation.slow.delay(0.5)) { barsAnimated = true }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Weekly")
                    .font(DetoxFont.title)
                    .foregroundStyle(Color.black)

                if let stats = viewModel.weeklyStats {
                    Text(stats.weekStartDate.weekDisplayString)
                        .font(DetoxFont.micro)
                        .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
                }
            }

            Spacer()

            Button { viewModel.dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .ultraLight))
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
                    .frame(width: 36, height: 36)
            }
        }
        .screenPadding()
        .padding(.top, Spacing.xl)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("You took back")
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))

            if let stats = viewModel.weeklyStats {
                Text(stats.timeReclaimedDisplay)
                    .font(DetoxFont.displayMedium)
                    .foregroundStyle(Color.black)
            } else {
                Text("— min")
                    .font(DetoxFont.displayMedium)
                    .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
            }

            Text("this week")
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
        }
    }

    private var barChartSection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("Daily pauses")
                .font(DetoxFont.micro)
                .tracking(2)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))

            HStack(alignment: .bottom, spacing: Spacing.sm) {
                let heights = viewModel.normalisedBarHeights
                let labels = viewModel.weekDayLabels
                let dailyStats = viewModel.weeklyStats?.dailyStats ?? []

                ForEach(Array(zip(heights.indices, heights)), id: \.0) { idx, normHeight in
                    let count = dailyStats.indices.contains(idx) ? dailyStats[idx].pauseCount : 0

                    VStack(spacing: Spacing.xs) {

                        Text(count > 0 ? "\(count)" : "")
                            .font(DetoxFont.micro)
                            .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
                            .frame(height: 14)

                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.black)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: barsAnimated ? normHeight * 160 : 2
                            )
                            .animation(
                                DetoxAnimation.slow.delay(Double(idx) * 0.07),
                                value: barsAnimated
                            )

                        Text(labels.indices.contains(idx) ? labels[idx] : "")
                            .font(DetoxFont.micro)
                            .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)
        }
    }

    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("Insights")
                .font(DetoxFont.micro)
                .tracking(2)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))

            insightRow(
                label: "Most blocked app",
                value: viewModel.topAppName
            )

            DetoxDivider()

            if let stats = viewModel.weeklyStats {
                insightRow(
                    label: "Total pauses",
                    value: "\(stats.totalPauses)"
                )

                DetoxDivider()

                insightRow(
                    label: "Est. time reclaimed",
                    value: stats.timeReclaimedDisplay
                )
            }
        }
    }

    private func insightRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))

            Spacer()

            Text(value)
                .font(DetoxFont.body)
                .foregroundStyle(Color.black)
        }
        .padding(.vertical, Spacing.xs)
    }
}
