import SwiftUI
import ManagedSettings

struct ShieldInterceptionView: View {
    @State private var headlineVisible = false
    @State private var actionsVisible = false
    @State private var isTyping = false
    @State private var typedText = ""
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var continueHoldProgress: CGFloat = 0
    @State private var isContinueHolding = false

    var appDisplayName: String = "this app"
    var appBundleID: String = ""

    var onVoiceNote: ((URL) -> Void)?
    var onTypedNote: ((String) -> Void)?
    var onContinueAnyway: (() -> Void)?

    @State private var voiceManager = VoiceInputManager.shared

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isTyping {
                typingPanel
                    .transition(DetoxAnimation.slideUp)
            } else {
                mainPanel
            }
        }.animation(DetoxAnimation.standard, value: isTyping).onAppear { animateIn() }
    }

    private var mainPanel: some View {
        VStack(spacing: 0) {
            Spacer()

            headlineView
                .padding(.horizontal, Spacing.screenHorizontal)
                .opacity(headlineVisible ? 1 : 0)

            Spacer().frame(height: Spacing.massive)

            VStack(spacing: Spacing.md) {

                voiceButton

                Button {
                    withAnimation(DetoxAnimation.standard) { isTyping = true }
                } label: {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .ultraLight))
                        Text("Type Instead")
                            .font(DetoxFont.body)
                    }
                }
                .buttonStyle(DetoxGhostButtonStyle())
            }
            .padding(.horizontal, Spacing.screenHorizontal)
            .opacity(actionsVisible ? 1 : 0)
            .offset(y: actionsVisible ? 0 : 20)

            Spacer().frame(height: Spacing.xxl)

            continueButton.opacity(actionsVisible ? DetoxOpacity.ghost : 0).padding(.bottom, Spacing.xxl + Spacing.xl)
        }
    }

    private var headlineView: some View {
        VStack(alignment: .center, spacing: Spacing.xs) {
            characterReveal("Why are you")
            characterReveal("opening this?")
        }.multilineTextAlignment(.center)
    }

    private func characterReveal(_ text: String) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { idx, char in
                Text(String(char))
                    .font(DetoxFont.interceptionHeadline)
                    .foregroundStyle(Color.white)
                    .opacity(headlineVisible ? 1 : 0)
                    .offset(y: headlineVisible ? 0 : 8)
                    .animation(
                        DetoxAnimation.verySlow
                            .delay(DetoxAnimation.interceptionDelay + DetoxAnimation.characterDelay(index: idx)),
                        value: headlineVisible
                    )
            }
        }
    }

    private var voiceButton: some View {
        Button {
            Task {
                if isRecording {
                    voiceManager.stopRecording()
                    isRecording = false
                    if let url = voiceManager.lastRecordingURL {
                        saveVoiceEntry(url: url)
                        onVoiceNote?(url)
                    }
                } else {
                    do {
                        try await voiceManager.startRecording()
                        isRecording = true
                    } catch {
                        print("[Shield] Voice recording failed: \(error)")
                    }
                }
            }
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: isRecording ? "stop.circle" : "waveform")
                    .font(.system(size: 16, weight: .ultraLight))
                    .symbolEffect(.pulse, isActive: isRecording)

                if isRecording {
                    Text("Stop · \(voiceManager.durationDisplayString)")
                        .font(DetoxFont.body)
                        .contentTransition(.numericText())
                } else {
                    Text("Record Voice")
                        .font(DetoxFont.body)
                }
            }
        }
        .buttonStyle(DetoxGhostButtonStyle())
        .animation(DetoxAnimation.micro, value: isRecording)
    }

    private var continueButton: some View {
        ZStack {
            if isContinueHolding {
                Circle()
                    .trim(from: 0, to: continueHoldProgress)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 80)
                    .transition(.opacity)
            }

            Text("Continue anyway")
                .font(DetoxFont.ghostAction)
                .foregroundStyle(Color.white)
        }
        .contentShape(Rectangle())
        .frame(height: 80)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 1.5)
                .onChanged { _ in
                    isContinueHolding = true
                    withAnimation(.linear(duration: 1.5)) {
                        continueHoldProgress = 1.0
                    }
                }
                .onEnded { _ in
                    isContinueHolding = false
                    continueHoldProgress = 0
                    saveSkippedEntry()
                    onContinueAnyway?()
                }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onEnded { _ in
                    if !isContinueHolding { return }
                    isContinueHolding = false
                    withAnimation(DetoxAnimation.micro) { continueHoldProgress = 0 }
                }
        )
    }

    private var typingPanel: some View {
        VStack(spacing: 0) {

            HStack {
                Button {
                    withAnimation(DetoxAnimation.standard) { isTyping = false }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .ultraLight))
                        .foregroundStyle(Color.white.opacity(DetoxOpacity.secondary))
                }
                Spacer()
            }
            .screenPadding()
            .padding(.top, Spacing.xxl)

            Spacer()
            VStack(alignment: .leading, spacing: Spacing.xl) {
                Text("Why are you\nopening this?")
                    .font(DetoxFont.interceptionHeadline)
                    .foregroundStyle(Color.white)
                    .screenPadding()

                ZStack(alignment: .topLeading) {
                    if typedText.isEmpty {
                        Text("Write your reason here…")
                            .font(DetoxFont.bodyLight)
                            .foregroundStyle(Color.white.opacity(DetoxOpacity.tertiary))
                            .padding(Spacing.md)
                    }

                    TextEditor(text: $typedText)
                        .font(DetoxFont.bodyLight)
                        .foregroundStyle(Color.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .tint(Color.white)
                        .padding(Spacing.sm)
                        .frame(minHeight: 120, maxHeight: 200)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: DetoxRadius.small, style: .continuous)
                        .stroke(Color.white.opacity(DetoxOpacity.ghost), lineWidth: DetoxStroke.hairline)
                )
                .padding(.horizontal, Spacing.screenHorizontal)
            }

            Spacer()

            Button("Save & Continue") {
                saveTypedEntry(text: typedText)
                onTypedNote?(typedText)
            }
            .buttonStyle(DetoxGhostButtonStyle())
            .disabled(typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.horizontal, Spacing.screenHorizontal)
            .padding(.bottom, Spacing.massive)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func saveVoiceEntry(url: URL) {
        let entry = ReflectionEntry(
            appBundleID: appBundleID,
            appDisplayName: appDisplayName,
            responseType: .voice,
            voiceFileURL: url,
            didContinue: false
        )
        ReflectionEntry.save(entry)
        UserDefaultsManager.shared.incrementPauseCount()
        UserDefaultsManager.shared.incrementWeeklyPauseCount(forBundleID: appBundleID)
    }

    private func saveTypedEntry(text: String) {
        let entry = ReflectionEntry(
            appBundleID: appBundleID,
            appDisplayName: appDisplayName,
            responseType: .typed,
            textContent: text,
            didContinue: false
        )
        ReflectionEntry.save(entry)
        UserDefaultsManager.shared.incrementPauseCount()
        UserDefaultsManager.shared.incrementWeeklyPauseCount(forBundleID: appBundleID)
    }

    private func saveSkippedEntry() {
        let entry = ReflectionEntry(
            appBundleID: appBundleID,
            appDisplayName: appDisplayName,
            responseType: .skipped,
            didContinue: true
        )
        ReflectionEntry.save(entry)
        UserDefaultsManager.shared.incrementPauseCount()
        UserDefaultsManager.shared.incrementWeeklyPauseCount(forBundleID: appBundleID)
    }

    private func animateIn() {
        headlineVisible = true
        let totalRevealTime = DetoxAnimation.interceptionDelay + DetoxAnimation.characterDelay(index: 20) + 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + totalRevealTime) {
            withAnimation(DetoxAnimation.slow) { actionsVisible = true }
        }
    }
}
