// VoiceInputManager.swift
// Detox – AVFoundation Audio Recording
//
// MVP: Records voice notes as .m4a files saved to the App Group container.
// v2 TODO: Plug in SFSpeechRecognizer for on-device transcription.

import Foundation
import AVFoundation
import Combine

enum VoiceInputError: LocalizedError {
    case permissionDenied
    case sessionSetupFailed(Error)
    case recordingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:      return "Microphone access denied. Enable it in Settings."
        case .sessionSetupFailed(let e): return "Audio session error: \(e.localizedDescription)"
        case .recordingFailed(let e):    return "Recording error: \(e.localizedDescription)"
        }
    }
}

@Observable
final class VoiceInputManager: NSObject {

    static let shared = VoiceInputManager()

    // MARK: – State

    var isRecording = false
    var lastRecordingURL: URL?
    var recordingDuration: TimeInterval = 0
    var error: VoiceInputError?

    private var recorder: AVAudioRecorder?
    private var durationTimer: Timer?

    // MARK: – Permission

    func requestPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    // MARK: – Recording Lifecycle

    func startRecording() async throws {
        let granted = await requestPermission()
        guard granted else { throw VoiceInputError.permissionDenied }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            throw VoiceInputError.sessionSetupFailed(error)
        }

        let filename = "reflection_\(Date().timeIntervalSince1970).m4a"
        let fileURL = AppGroup.containerURL
            .appendingPathComponent("VoiceNotes", isDirectory: true)
            .appendingPathComponent(filename)

        // Ensure directory exists
        try? FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            lastRecordingURL = fileURL
            isRecording = true
            recordingDuration = 0
            startDurationTimer()
        } catch {
            throw VoiceInputError.recordingFailed(error)
        }
    }

    func stopRecording() {
        recorder?.stop()
        recorder = nil
        isRecording = false
        durationTimer?.invalidate()
        durationTimer = nil

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch { }
    }

    func cancelRecording() {
        recorder?.stop()
        if let url = lastRecordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        recorder = nil
        lastRecordingURL = nil
        isRecording = false
        durationTimer?.invalidate()
        recordingDuration = 0
    }

    // MARK: – Duration Timer

    private func startDurationTimer() {
        durationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.recordingDuration += 0.1
        }
    }

    // MARK: – Duration Display

    var durationDisplayString: String {
        let seconds = Int(recordingDuration)
        let ms = Int((recordingDuration - Double(seconds)) * 10)
        return String(format: "%02d.%01d", seconds, ms)
    }
}

// MARK: – AVAudioRecorderDelegate

extension VoiceInputManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            lastRecordingURL = nil
        }
        isRecording = false
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let e = error {
            self.error = .recordingFailed(e)
        }
        isRecording = false
    }
}
