import Foundation

struct SharedFocusData {
    static let appGroupID = "group.com.stride.app"

    private static let completedFocusSecondsKey =
        "completedFocusSeconds"

    private static let goalNameKey =
        "goalName"

    private static let lastFocusDateKey =
        "lastFocusDate"

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

    // MARK: - Daily Reset Check

    private static func resetIfNewDay() {
        let calendar = Calendar.current
        let today =
            calendar.startOfDay(
                for: Date()
            )

        guard let savedDate =
            defaults.object(
                forKey: lastFocusDateKey
            ) as? Date
        else {
            defaults.set(
                today,
                forKey: lastFocusDateKey
            )
            return
        }

        let savedDay =
            calendar.startOfDay(
                for: savedDate
            )

        if savedDay != today {
            defaults.set(
                0,
                forKey: completedFocusSecondsKey
            )

            defaults.set(
                today,
                forKey: lastFocusDateKey
            )
        }
    }

    // MARK: - Completed Focus Time

    static var completedFocusSeconds: TimeInterval {
        resetIfNewDay()

        return defaults.double(
            forKey: completedFocusSecondsKey
        )
    }

    static func setCompletedFocusSeconds(
        _ value: TimeInterval
    ) {
        resetIfNewDay()

        defaults.set(
            max(0, value),
            forKey: completedFocusSecondsKey
        )

        defaults.set(
            Calendar.current.startOfDay(
                for: Date()
            ),
            forKey: lastFocusDateKey
        )
    }

    // MARK: - Goal Name

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

    // MARK: - Add Session

    @discardableResult
    static func addSession(
        _ duration: TimeInterval
    ) -> TimeInterval {

        resetIfNewDay()

        let newTotal =
            completedFocusSeconds
            + max(0, duration)

        setCompletedFocusSeconds(
            newTotal
        )

        return newTotal
    }

    // MARK: - Manual Daily Reset

    static func resetDailyFocus() {
        defaults.set(
            0,
            forKey: completedFocusSecondsKey
        )

        defaults.set(
            Calendar.current.startOfDay(
                for: Date()
            ),
            forKey: lastFocusDateKey
        )
    }
}
