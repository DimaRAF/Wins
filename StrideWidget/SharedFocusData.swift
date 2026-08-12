import Foundation

struct SharedFocusData {
    static let appGroupID = "group.com.stride.app"

    private static let completedFocusSecondsKey =
        "completedFocusSeconds"

    private static let goalNameKey =
        "goalName"

    private static var defaults: UserDefaults {
        guard let defaults =
            UserDefaults(
                suiteName: appGroupID
            ) else {
            fatalError(
                "App Group is not configured correctly."
            )
        }

        return defaults
    }

    static var completedFocusSeconds: TimeInterval {
        defaults.double(
            forKey: completedFocusSecondsKey
        )
    }

    static func setCompletedFocusSeconds(
        _ value: TimeInterval
    ) {
        defaults.set(
            max(0, value),
            forKey: completedFocusSecondsKey
        )
    }

    static var goalName: String {
        defaults.string(
            forKey: goalNameKey
        ) ?? "Focus Session"
    }

    static func setGoalName(
        _ name: String
    ) {
        defaults.set(
            name,
            forKey: goalNameKey
        )
    }

    @discardableResult
    static func addSession(
        _ duration: TimeInterval
    ) -> TimeInterval {

        let newTotal =
            completedFocusSeconds
            + max(0, duration)

        setCompletedFocusSeconds(
            newTotal
        )

        return newTotal
    }

    static func resetDailyFocus() {
        setCompletedFocusSeconds(0)
    }
}
