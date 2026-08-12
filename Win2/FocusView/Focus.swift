//
//  Wins.swift
//  WinsApp
//
//  Created by Fajer on 20/02/1448 AH.
//

import SwiftUI
import ActivityKit
import Combine

struct FocusView: View {
    @Binding var completedMinutes: Int
    let targetMinutes: Int

    private let primaryBlue = Color(hex: "2A92C9")
    private let secondaryBlue = Color(hex: "9ED2F1")
    private let backgroundColor = Color("AppBackground")
    private let textColor = Color(hex: "8E8E95")

    @State private var isRunning = false
    @State private var isPaused = false
    @State private var elapsedTime: Double = 0
    @State private var startDate: Date?

    private let timer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    )
    .autoconnect()

    // MARK: - Remaining Target

    private var remainingMinutes: Int {
        max(
            targetMinutes - completedMinutes,
            0
        )
    }

    // MARK: - Timer Text

    private var formattedTime: String {
        let totalSeconds = max(
            0,
            Int(elapsedTime)
        )

        let hours = totalSeconds / 3600

        let minutes =
            (totalSeconds % 3600) / 60

        let seconds =
            totalSeconds % 60

        if hours > 0 {
            return String(
                format: "%02d:%02d:%02d",
                hours,
                minutes,
                seconds
            )
        }

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    // MARK: - Circle Progress

    private var progressRatio: Double {
        guard isRunning || isPaused else {
            return 0
        }

        let targetSeconds =
            Double(remainingMinutes * 60)

        guard targetSeconds > 0 else {
            return 1
        }

        return min(
            elapsedTime / targetSeconds,
            1
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {

                HeaderSection(
                    textColor: textColor
                )
                .padding(.top, -9)
                .offset(y: 70)

                Spacer()

                VStack(spacing: 80) {

                    CircularProgressView(
                        progress: progressRatio,
                        timeString: formattedTime,
                        primaryColor: primaryBlue,
                        secondaryColor: secondaryBlue,
                        textColor: textColor
                    )

                    ControlButtonsView(
                        isRunning: isRunning,
                        isPaused: isPaused,
                        primaryColor: primaryBlue,
                        onStart: startTimer,
                        onPause: pauseTimer,
                        onResume: resumeTimer,
                        onEnd: endTimer
                    )
                    .padding(.top, -35)
                }

                Spacer()
            }
            .padding(.horizontal, 28)
        }

        // Keeps FocusView synced with Live Activity.
        .onReceive(timer) { _ in
            syncWithLiveActivity()
            syncCompletedMinutes()

            if isRunning,
               let startDate {

                elapsedTime =
                    Date().timeIntervalSince(
                        startDate
                    )
            }
        }

        .onAppear {
            syncWithLiveActivity()
            syncCompletedMinutes()
        }
    }

    // MARK: - Start

    private func startTimer() {
        triggerHaptic()

        Task {
            // If a Live Activity already exists,
            // reuse it instead of creating another one.
            if let activity =
                Activity<FocusAttributes>
                    .activities
                    .first {

                let now = Date()

                let newState =
                    FocusAttributes.ContentState(
                        isRunning: true,
                        isPaused: false,
                        startDate: now,
                        endDate:
                            now.addingTimeInterval(
                                24 * 60 * 60
                            ),
                        elapsedTime: 0
                    )

                await activity.update(
                    ActivityContent(
                        state: newState,
                        staleDate: nil
                    )
                )

            } else {

                await createLiveActivity()
            }

            await MainActor.run {
                isRunning = true
                isPaused = false
                elapsedTime = 0
                startDate = Date()
            }
        }
    }

    // MARK: - Pause

    private func pauseTimer() {
        triggerHaptic()

        guard let activity =
            Activity<FocusAttributes>
                .activities
                .first
        else {
            return
        }

        let currentElapsed =
            calculateElapsedTime(
                from: activity.content.state
            )

        Task {
            let pausedState =
                FocusAttributes.ContentState(
                    isRunning: false,
                    isPaused: true,
                    startDate: nil,
                    endDate: nil,
                    elapsedTime: currentElapsed
                )

            await activity.update(
                ActivityContent(
                    state: pausedState,
                    staleDate: nil
                )
            )

            await MainActor.run {
                isRunning = false
                isPaused = true
                elapsedTime = currentElapsed
                startDate = nil
            }
        }
    }

    // MARK: - Resume

    private func resumeTimer() {
        triggerHaptic()

        guard let activity =
            Activity<FocusAttributes>
                .activities
                .first
        else {
            return
        }

        let previousElapsed =
            activity.content.state.elapsedTime

        let now = Date()

        let resumedStartDate =
            now.addingTimeInterval(
                -previousElapsed
            )

        Task {
            let resumedState =
                FocusAttributes.ContentState(
                    isRunning: true,
                    isPaused: false,
                    startDate: resumedStartDate,
                    endDate:
                        resumedStartDate
                            .addingTimeInterval(
                                24 * 60 * 60
                            ),
                    elapsedTime: previousElapsed
                )

            await activity.update(
                ActivityContent(
                    state: resumedState,
                    staleDate: nil
                )
            )

            await MainActor.run {
                isRunning = true
                isPaused = false
                elapsedTime = previousElapsed
                startDate = resumedStartDate
            }
        }
    }

    // MARK: - End

    private func endTimer() {
        triggerHaptic()

        guard let activity =
            Activity<FocusAttributes>
                .activities
                .first
        else {
            resetLocalTimer()
            return
        }

        let sessionDuration =
            calculateElapsedTime(
                from: activity.content.state
            )

        // Save today's completed focus time.
        let newTotal =
            SharedFocusData.addSession(
                sessionDuration
            )

        completedMinutes =
            Int(newTotal / 60)

        Task {
            let resetState =
                FocusAttributes.ContentState(
                    isRunning: false,
                    isPaused: false,
                    startDate: nil,
                    endDate: nil,
                    elapsedTime: 0
                )

            await activity.update(
                ActivityContent(
                    state: resetState,
                    staleDate: nil
                )
            )

            await MainActor.run {
                resetLocalTimer()
            }
        }
    }

    // MARK: - Create Live Activity

    private func createLiveActivity() async {
        guard ActivityAuthorizationInfo()
            .areActivitiesEnabled else {
            return
        }

        let now = Date()

        let attributes =
            FocusAttributes(
                taskName: "Focus Session"
            )

        let initialState =
            FocusAttributes.ContentState(
                isRunning: true,
                isPaused: false,
                startDate: now,
                endDate:
                    now.addingTimeInterval(
                        24 * 60 * 60
                    ),
                elapsedTime: 0
            )

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: ActivityContent(
                    state: initialState,
                    staleDate: nil
                ),
                pushType: nil
            )
        } catch {
            print(
                "Error starting Live Activity: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Sync Live Activity → App

    private func syncWithLiveActivity() {
        guard let activity =
            Activity<FocusAttributes>
                .activities
                .first
        else {
            return
        }

        let state =
            activity.content.state

        isRunning =
            state.isRunning

        isPaused =
            state.isPaused

        if state.isRunning,
           let activityStartDate =
            state.startDate {

            startDate =
                activityStartDate

            elapsedTime =
                Date().timeIntervalSince(
                    activityStartDate
                )

        } else {

            startDate = nil

            elapsedTime =
                state.elapsedTime
        }
    }

    // MARK: - Sync Widget Completed Time → App

    private func syncCompletedMinutes() {
        let sharedMinutes =
            Int(
                SharedFocusData
                    .completedFocusSeconds
                / 60
            )

        if sharedMinutes >
            completedMinutes {

            completedMinutes =
                sharedMinutes
        }
    }

    // MARK: - Calculate Session Time

    private func calculateElapsedTime(
        from state:
            FocusAttributes.ContentState
    ) -> TimeInterval {

        if state.isRunning,
           let startDate =
            state.startDate {

            return max(
                0,
                Date().timeIntervalSince(
                    startDate
                )
            )
        }

        return max(
            0,
            state.elapsedTime
        )
    }

    // MARK: - Reset Local UI

    private func resetLocalTimer() {
        isRunning = false
        isPaused = false
        elapsedTime = 0
        startDate = nil
    }

    // MARK: - Haptic

    private func triggerHaptic() {
        let generator =
            UIImpactFeedbackGenerator(
                style: .medium
            )

        generator.impactOccurred()
    }
}


// MARK: - Header

private struct HeaderSection: View {
    let textColor: Color

    var body: some View {
        VStack(spacing: 8) {

            Text("FOCUS")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text(
                "Start a focus session and track your\nprogress without distractions"
            )
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .foregroundStyle(textColor)
            .lineSpacing(3)
        }
    }
}


// MARK: - Circular Progress

private struct CircularProgressView: View {
    let progress: Double
    let timeString: String
    let primaryColor: Color
    let secondaryColor: Color
    let textColor: Color

    var body: some View {
        ZStack {

            Circle()
                .stroke(
                    secondaryColor.opacity(0.4),
                    lineWidth: 16
                )

            Circle()
                .trim(
                    from: 0,
                    to: progress
                )
                .stroke(
                    primaryColor,
                    style: StrokeStyle(
                        lineWidth: 16,
                        lineCap: .round
                    )
                )
                .rotationEffect(
                    .degrees(-90)
                )
                .animation(
                    .linear(duration: 0.1),
                    value: progress
                )

            Text(timeString)
                .font(
                    .system(
                        size: 42,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    textColor
                )
        }
        .frame(
            width: 260,
            height: 260
        )
    }
}


// MARK: - Buttons

private struct ControlButtonsView: View {
    let isRunning: Bool
    let isPaused: Bool

    let primaryColor: Color

    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onEnd: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            if isRunning {

                Button(
                    action: onEnd
                ) {
                    Text("End")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            28
                        )
                        .padding(
                            .vertical,
                            10
                        )
                        .background(
                            primaryColor
                        )
                        .clipShape(
                            Capsule()
                        )
                }

                Button(
                    action: onPause
                ) {
                    Image(
                        systemName:
                            "pause.fill"
                    )
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .vertical,
                        10
                    )
                    .background(
                        primaryColor
                    )
                    .clipShape(
                        Capsule()
                    )
                }

            } else if isPaused {

                Button(
                    action: onEnd
                ) {
                    Text("End")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            28
                        )
                        .padding(
                            .vertical,
                            10
                        )
                        .background(
                            primaryColor
                        )
                        .clipShape(
                            Capsule()
                        )
                }

                Button(
                    action: onResume
                ) {
                    Image(
                        systemName:
                            "play.fill"
                    )
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .vertical,
                        10
                    )
                    .background(
                        primaryColor
                    )
                    .clipShape(
                        Capsule()
                    )
                }

            } else {

                Button(
                    action: onStart
                ) {
                    Text("Start")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            36
                        )
                        .padding(
                            .vertical,
                            10
                        )
                        .background(
                            primaryColor
                        )
                        .clipShape(
                            Capsule()
                        )
                }
            }
        }
    }
}


// MARK: - Hex Color

extension Color {
    init(hex: String) {
        let scanner =
            Scanner(string: hex)

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(
            &rgbValue
        )

        let red =
            Double(
                (rgbValue & 0xFF0000)
                >> 16
            ) / 255

        let green =
            Double(
                (rgbValue & 0x00FF00)
                >> 8
            ) / 255

        let blue =
            Double(
                rgbValue & 0x0000FF
            ) / 255

        self.init(
            red: red,
            green: green,
            blue: blue
        )
    }
}


// MARK: - Preview

#Preview {
    FocusView(
        completedMinutes: .constant(60),
        targetMinutes: 120
    )
}
