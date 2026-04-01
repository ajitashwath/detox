// HomeView.swift
// Detox – Screen 2: Home Dashboard

import SwiftUI

struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @State private var displayedCount: Int = 0
    @State private var contentVisible = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: – Top Bar
                topBar
                    .padding(.top, Spacing.xl)
                    .screenPadding()

                Spacer()

                // MARK: – Hero Stat
                heroStat
                    .opacity(contentVisible ? 1 : 0)
                    .offset(y: contentVisible ? 0 : 24)

                Spacer().frame(height: Spacing.xxl)

                // MARK: – Toggle
                shieldToggle
                    .opacity(contentVisible ? 1 : 0)
                    .screenPadding()

                Spacer().frame(height: Spacing.xl)

                // MARK: – Insight
                insightText
                    .opacity(contentVisible ? DetoxOpacity.secondary : 0)
                    .screenPadding()

                Spacer()

                // MARK: – Bottom Nav
                bottomNav
                    .screenPadding()
                    .padding(.bottom, Spacing.xl)
                    .opacity(contentVisible ? 1 : 0)
            }
        }
        .onAppear {
            viewModel.onAppear()
            animateIn()
        }
    }

    // MARK: – Top Bar

    private var topBar: some View {
        HStack {
            Text("detox")
                .font(.system(size: 15, weight: .light, design: .default))
                .tracking(4)
                .foregroundStyle(Color.black)

            Spacer()

            // Today date, subtle
            Text(Date().formatted(.dateTime.weekday(.wide).month().day()))
                .font(DetoxFont.micro)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
        }
    }

    // MARK: – Hero Stat

    private var heroStat: some View {
        VStack(spacing: Spacing.sm) {
            Text("You paused")
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))

            Text("\(displayedCount)")
                .font(DetoxFont.hero)
                .foregroundStyle(Color.black)
                .contentTransition(.numericText())
                .animation(DetoxAnimation.breathe, value: displayedCount)

            Text(displayedCount == 1 ? "time today" : "times today")
                .font(DetoxFont.bodyLight)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
        }
        .multilineTextAlignment(.center)
    }

    // MARK: – Shield Toggle

    private var shieldToggle: some View {
        HStack(spacing: 0) {
            toggleLabel("ON", isSelected: viewModel.isShieldActive)

            // Track
            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.06))
                    .frame(width: 72, height: 32)

                Circle()
                    .fill(Color.black)
                    .frame(width: 24, height: 24)
                    .offset(x: viewModel.isShieldActive ? -16 : 16)
                    .animation(DetoxAnimation.breathe, value: viewModel.isShieldActive)
            }
            .onTapGesture { viewModel.toggleShield() }
            .padding(.horizontal, Spacing.lg)

            toggleLabel("OFF", isSelected: !viewModel.isShieldActive)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    private func toggleLabel(_ text: String, isSelected: Bool) -> some View {
        Text(text)
            .font(.system(size: 12, weight: isSelected ? .medium : .light))
            .tracking(2)
            .foregroundStyle(Color.black.opacity(isSelected ? DetoxOpacity.primary : DetoxOpacity.ghost))
            .animation(DetoxAnimation.micro, value: isSelected)
            .frame(width: 36)
    }

    // MARK: – Insight Text

    private var insightText: some View {
        Text(viewModel.insightText)
            .font(DetoxFont.caption)
            .italic()
            .foregroundStyle(Color.black)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: – Bottom Navigation

    private var bottomNav: some View {
        HStack {
            Button {
                viewModel.openReflections()
            } label: {
                VStack(spacing: Spacing.xs) {
                    Image(systemName: "text.alignleft")
                        .font(.system(size: 18, weight: .ultraLight))
                    Text("Reflections")
                        .font(DetoxFont.micro)
                        .tracking(1)
                }
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
            }

            Spacer()

            Button {
                viewModel.openWeeklyReport()
            } label: {
                VStack(spacing: Spacing.xs) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 18, weight: .ultraLight))
                    Text("Weekly")
                        .font(DetoxFont.micro)
                        .tracking(1)
                }
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
            }
        }
    }

    // MARK: – Animation

    private func animateIn() {
        withAnimation(DetoxAnimation.slow.delay(0.1)) { contentVisible = true }
        withAnimation(DetoxAnimation.breathe.delay(0.4)) {
            displayedCount = viewModel.pauseCount
        }
    }
}
