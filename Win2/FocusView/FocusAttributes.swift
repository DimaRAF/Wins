import ActivityKit
import Foundation

nonisolated struct FocusAttributes: ActivityAttributes {

    nonisolated struct ContentState: Codable, Hashable {
        var isRunning: Bool
        var isPaused: Bool
        var startDate: Date?
        var endDate: Date?
        var elapsedTime: TimeInterval
    }

    var taskName: String
}
