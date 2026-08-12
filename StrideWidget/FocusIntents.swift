import ActivityKit
import AppIntents
import Foundation

// MARK: - START / RESUME

struct StartFocusIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start Focus"

    init() {}

    func perform() async throws -> some IntentResult {

        if let activity = Activity<FocusAttributes>.activities.first {

            let currentState = activity.content.state

            if currentState.isRunning {
                return .result()
            }

            let now = Date()

            let elapsedTime: TimeInterval
            let startDate: Date

            if currentState.isPaused {

                elapsedTime = currentState.elapsedTime

                startDate = now.addingTimeInterval(
                    -elapsedTime
                )

            } else {

                elapsedTime = 0
                startDate = now
            }

            let endDate = startDate.addingTimeInterval(
                24 * 60 * 60
            )

            let newState = FocusAttributes.ContentState(
                isRunning: true,
                isPaused: false,
                startDate: startDate,
                endDate: endDate,
                elapsedTime: elapsedTime
            )

            await activity.update(
                ActivityContent(
                    state: newState,
                    staleDate: nil
                )
            )

            return .result()
        }

        // MARK: - No Live Activity

        guard ActivityAuthorizationInfo()
            .areActivitiesEnabled else {
            return .result()
        }

        let now = Date()

        let attributes = FocusAttributes(
            taskName: "Focus Session"
        )

        let initialState = FocusAttributes.ContentState(
            isRunning: true,
            isPaused: false,
            startDate: now,
            endDate: now.addingTimeInterval(
                24 * 60 * 60
            ),
            elapsedTime: 0
        )

        let activity = try Activity.request(
            attributes: attributes,
            content: ActivityContent(
                state: initialState,
                staleDate: nil
            ),
            pushType: nil
        )

        print(
            "Started Focus Activity: \(activity.id)"
        )

        return .result()
    }
}

// MARK: - PAUSE

struct PauseFocusIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pause Focus"

    init() {}

    func perform() async throws -> some IntentResult {

        guard let activity =
            Activity<FocusAttributes>.activities.first
        else {
            return .result()
        }

        let currentState = activity.content.state

        var elapsedTime = currentState.elapsedTime

        if currentState.isRunning,
           let startDate = currentState.startDate {

            elapsedTime = Date().timeIntervalSince(
                startDate
            )
        }

        let pausedState = FocusAttributes.ContentState(
            isRunning: false,
            isPaused: true,
            startDate: nil,
            endDate: nil,
            elapsedTime: elapsedTime
        )

        await activity.update(
            ActivityContent(
                state: pausedState,
                staleDate: nil
            )
        )

        return .result()
    }
}

// MARK: - END

struct EndFocusIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "End Focus"

    init() {}

    func perform() async throws -> some IntentResult {

        guard let activity =
            Activity<FocusAttributes>.activities.first
        else {
            return .result()
        }

        let currentState = activity.content.state

        var sessionDuration = currentState.elapsedTime

        if currentState.isRunning,
           let startDate = currentState.startDate {

            sessionDuration = Date().timeIntervalSince(
                startDate
            )
        }

        sessionDuration = max(
            0,
            sessionDuration
        )

        let newTotal = SharedFocusData.addSession(
            sessionDuration
        )

        print(
            """
            =========================
            FOCUS SESSION ENDED
            Session: \(sessionDuration) sec
            New Total: \(newTotal) sec
            =========================
            """
        )

        let resetState = FocusAttributes.ContentState(
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

        return .result()
    }
}
