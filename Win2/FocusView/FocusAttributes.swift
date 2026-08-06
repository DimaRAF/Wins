//
//  FocusAttributes.swift
//  WinsApp
//
//  Created by Fajer  on 21/02/1448 AH.
//


import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

struct FocusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isRunning: Bool
        var timerRange: ClosedRange<Date>
        var taskTitle: String
        var totalMinutes: String
    }
    
    var sessionName: String
}

struct PauseTimerIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pause Timer"
    init() {}
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct StopTimerIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Timer"
    init() {}
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct StartTimerIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start Timer"
    init() {}
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct FocusLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusAttributes.self) { context in
       
            HStack(spacing: 12) {
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Text("🎯")
                        .font(.system(size: 24))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("FOCUS BLOCK")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text(context.state.taskTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("Timer")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Text(timerInterval: context.state.timerRange, countsDown: true)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.primary)
                    }
                }
                
                Spacer(minLength: 4)
                
                HStack(spacing: 6) {
                    Button(intent: PauseTimerIntent()) {
                        HStack(spacing: 3) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 10, weight: .bold))
                            Text("PAUSE")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.primary.opacity(0.12)))
                    }
                    .buttonStyle(.plain)
                    
                    Button(intent: StopTimerIntent()) {
                        HStack(spacing: 3) {
                            Image(systemName: "square.fill")
                                .font(.system(size: 9, weight: .bold))
                            Text("END")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.primary.opacity(0.12)))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .activityBackgroundTint(Color.black.opacity(0.6))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Text("🎯")
                        Text(context.state.taskTitle)
                            .font(.headline)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: context.state.timerRange, countsDown: true)
                        .monospacedDigit()
                        .font(.title3)
                }
            } compactLeading: {
                Text("🎯")
            } compactTrailing: {
                Text(timerInterval: context.state.timerRange, countsDown: true)
                    .monospacedDigit()
                    .font(.caption2)
            } minimal: {
                Text("🎯")
            }
        }
    }
}

#Preview("Lock Screen", as: .content, using: FocusAttributes(sessionName: "Python Study")) {
    FocusLiveActivityWidget()
} contentStates: {
    FocusAttributes.ContentState(
        isRunning: true,
        timerRange: Date()...Date().addingTimeInterval(1800),
        taskTitle: "Learn Python",
        totalMinutes: "30 min left"
    )
}
