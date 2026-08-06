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
    @State private var accumulatedTime: Double = 0

    private let timer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    )
    .autoconnect()

    @State private var currentActivity:
        Activity<FocusAttributes>?

    private var remainingMinutes: Int {
        max(
            targetMinutes - completedMinutes,
            0
        )
    }

    private var formattedTime: String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    private var progressRatio: Double {
        guard isRunning else {
            return 0
        }

        let remainingSeconds =
            Double(remainingMinutes * 60)

        guard remainingSeconds > 0 else {
            return 1
        }

        return min(
            elapsedTime / remainingSeconds,
            1
        )
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderSection(textColor: textColor)
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
                        isRunning: $isRunning,
                        isPaused: $isPaused,
                        primaryColor: primaryBlue,
                        onStart: startTimer,
                        onPause: togglePauseTimer,
                        onEnd: endTimer
                    )
                    .padding(.top, -35)
                }

                Spacer()
            }
            .padding(.horizontal, 28)
        }
        .onReceive(timer) { _ in
            guard
                isRunning,
                !isPaused,
                let startDate
            else {
                return
            }

            elapsedTime =
                accumulatedTime
                + Date().timeIntervalSince(startDate)
        }
    }

    private func startLiveActivity() {
        guard ActivityAuthorizationInfo()
            .areActivitiesEnabled else {
            return
        }

        let attributes = FocusAttributes(
            sessionName: "Focus Session"
        )

        let duration =
            TimeInterval(remainingMinutes * 60)

        let activityStartDate = Date()
        let activityEndDate =
            activityStartDate.addingTimeInterval(
                duration
            )

        let initialState = FocusAttributes.ContentState(
            isRunning: true,
            timerRange:
                activityStartDate...activityEndDate,
            taskTitle: "Focus Session",
            totalMinutes: "\(remainingMinutes) min"
        )

        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(
                    state: initialState,
                    staleDate: nil
                )
            )
        } catch {
            print(
                "Error starting Live Activity: \(error.localizedDescription)"
            )
        }
    }

    private func updateLiveActivity(
        running: Bool
    ) {
        guard let activity = currentActivity else {
            return
        }

        let remainingSessionSeconds = max(
            Double(remainingMinutes * 60)
                - elapsedTime,
            0
        )

        let activityStartDate = Date()
        let activityEndDate =
            activityStartDate.addingTimeInterval(
                remainingSessionSeconds
            )

        let updatedState = FocusAttributes.ContentState(
            isRunning: running,
            timerRange:
                activityStartDate...activityEndDate,
            taskTitle: "Focus Session",
            totalMinutes: "\(remainingMinutes) min"
        )

        Task {
            await activity.update(
                ActivityContent(
                    state: updatedState,
                    staleDate: nil
                )
            )
        }
    }

    private func endLiveActivity() {
        Task {
            for activity
                in Activity<FocusAttributes>.activities {

                await activity.end(
                    nil,
                    dismissalPolicy: .immediate
                )
            }

            currentActivity = nil
        }
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(
            style: .medium
        )

        generator.impactOccurred()
    }

    private func startTimer() {
        triggerHaptic()

        withAnimation(
            .spring(
                response: 0.4,
                dampingFraction: 0.8
            )
        ) {
            isRunning = true
            isPaused = false
            elapsedTime = 0
            accumulatedTime = 0
            startDate = Date()
        }

        startLiveActivity()
    }

    private func togglePauseTimer() {
        triggerHaptic()

        withAnimation(
            .spring(
                response: 0.3,
                dampingFraction: 0.8
            )
        ) {
            if isPaused {
                startDate = Date()
                isPaused = false
            } else {
                accumulatedTime = elapsedTime
                startDate = nil
                isPaused = true
            }
        }

        updateLiveActivity(
            running: !isPaused
        )
    }

    private func endTimer() {
        let sessionMinutes =
            Int(elapsedTime / 60)

        completedMinutes = min(
            completedMinutes + sessionMinutes,
            24 * 60
        )

        resetTimer()
    }

    private func resetTimer() {
        triggerHaptic()

        withAnimation(
            .spring(
                response: 0.3,
                dampingFraction: 0.8
            )
        ) {
            isRunning = false
            isPaused = false
            elapsedTime = 0
            accumulatedTime = 0
            startDate = nil
        }

        endLiveActivity()
    }
}

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
                .rotationEffect(.degrees(-90))
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
                .foregroundStyle(textColor)
        }
        .frame(
            width: 260,
            height: 260
        )
    }
}

private struct ControlButtonsView: View {
    @Binding var isRunning: Bool
    @Binding var isPaused: Bool

    let primaryColor: Color
    let onStart: () -> Void
    let onPause: () -> Void
    let onEnd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if !isRunning {
                Button(action: onStart) {
                    Text("Start")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 10)
                        .background(primaryColor)
                        .clipShape(Capsule())
                }
            } else {
                Button(action: onEnd) {
                    Text("End")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(primaryColor)
                        .clipShape(Capsule())
                }

                Button(action: onPause) {
                    Image(
                        systemName:
                            isPaused
                            ? "play.fill"
                            : "pause.fill"
                    )
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(primaryColor)
                    .clipShape(Capsule())
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red =
            Double(
                (rgbValue & 0xFF0000) >> 16
            ) / 255

        let green =
            Double(
                (rgbValue & 0x00FF00) >> 8
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

#Preview {
    FocusView(
        completedMinutes: .constant(60),
        targetMinutes: 120
    )
}
