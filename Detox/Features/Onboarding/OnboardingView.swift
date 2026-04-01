// OnboardingView.swift
// Detox – Screen 1: App Selection

import SwiftUI
import FamilyControls

struct OnboardingView: View {

    @State private var viewModel = OnboardingViewModel()
    @State private var titleVisible = false
    @State private var subtitleVisible = false
    @State private var ctaVisible = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Spacer()

                // MARK: – Hero Question
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Which apps")
                        .font(DetoxFont.displayLarge)
                        .foregroundStyle(Color.black)
                        .opacity(titleVisible ? 1 : 0)
                        .offset(y: titleVisible ? 0 : 20)

                    Text("waste your time?")
                        .font(DetoxFont.displayLarge)
                        .foregroundStyle(Color.black)
                        .opacity(subtitleVisible ? 1 : 0)
                        .offset(y: subtitleVisible ? 0 : 20)
                }
                .screenPadding()

                Spacer().frame(height: Spacing.xxl)

                // MARK: – Selection State Indicator
                if viewModel.hasSelection {
                    selectionConfirmation
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    selectionPrompt
                        .transition(.opacity)
                }

                Spacer()

                // MARK: – Permission Error
                if let error = viewModel.permissionError {
                    Text(error)
                        .font(DetoxFont.caption)
                        .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
                        .multilineTextAlignment(.center)
                        .screenPadding()
                        .transition(.opacity)
                }

                // MARK: – CTA
                VStack(spacing: Spacing.md) {
                    if !viewModel.hasSelection {
                        Button {
                            Task {
                                await viewModel.requestPermissionAndShowPicker()
                            }
                        } label: {
                            HStack(spacing: Spacing.sm) {
                                if viewModel.isRequestingPermission {
                                    ProgressView()
                                        .tint(.black)
                                        .scaleEffect(0.8)
                                }
                                Text(viewModel.isRequestingPermission ? "Requesting access…" : "Select Apps")
                            }
                        }
                        .buttonStyle(DetoxPrimaryButtonStyle())
                    } else {
                        Button("Continue →") {
                            viewModel.completeOnboarding()
                        }
                        .buttonStyle(DetoxPrimaryButtonStyle())
                    }
                }
                .screenPadding()
                .padding(.bottom, Spacing.xl)
                .opacity(ctaVisible ? 1 : 0)
                .offset(y: ctaVisible ? 0 : 16)
            }
            .animation(DetoxAnimation.standard, value: viewModel.hasSelection)
        }
        .familyActivityPicker(
            isPresented: $viewModel.isPickerPresented,
            selection: $viewModel.selection
        )
        .onAppear { animateIn() }
    }

    // MARK: – Sub-Components

    private var selectionPrompt: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("No apps selected yet.")
                .font(DetoxFont.body)
                .foregroundStyle(Color.black)

            Text("Tap below to choose which apps to pause before.")
                .font(DetoxFont.caption)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))
        }
        .screenPadding()
    }

    private var selectionConfirmation: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Apps selected.")
                .font(DetoxFont.body)
                .foregroundStyle(Color.black)

            Text("You'll see a reflection moment before opening them.")
                .font(DetoxFont.caption)
                .foregroundStyle(Color.black.opacity(DetoxOpacity.secondary))

            Button("Change selection") {
                viewModel.isPickerPresented = true
            }
            .font(DetoxFont.caption)
            .foregroundStyle(Color.black.opacity(DetoxOpacity.tertiary))
            .padding(.top, Spacing.xs)
        }
        .screenPadding()
    }

    // MARK: – Entrance Animation

    private func animateIn() {
        withAnimation(DetoxAnimation.slow.delay(0.2)) { titleVisible = true }
        withAnimation(DetoxAnimation.slow.delay(0.5)) { subtitleVisible = true }
        withAnimation(DetoxAnimation.slow.delay(0.9)) { ctaVisible = true }
    }
}
