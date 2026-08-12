import SwiftUI
import WidgetKit
import ActivityKit
import AppIntents

struct StrideWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusAttributes.self) { context in

            HStack(spacing: 10) {

                Image(systemName: "target")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundStyle(Color("AccentColor"))

                VStack(alignment: .leading, spacing: 3) {

                    Text("FOCUS")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)

                    Text(context.attributes.taskName)
                        .font(.headline)
                        .lineLimit(1)

                    if context.state.isRunning,
                       let startDate = context.state.startDate,
                       let endDate = context.state.endDate {

                        Text(
                            timerInterval: startDate...endDate,
                            countsDown: false,
                            showsHours: true
                        )
                        .font(
                            .system(
                                .title3,
                                design: .monospaced
                            )
                        )
                        .bold()

                    } else {

                        Text(
                            formatElapsedTime(
                                context.state.elapsedTime
                            )
                        )
                        .font(
                            .system(
                                .title3,
                                design: .monospaced
                            )
                        )
                        .bold()
                    }
                }

                Spacer(minLength: 4)

                if context.state.isRunning {

                    HStack(spacing: 6) {

                        Button(
                            intent: PauseFocusIntent()
                        ) {
                            Text("PAUSE")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)

                        Button(
                            intent: EndFocusIntent()
                        ) {
                            Text("END")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }

                } else if context.state.isPaused {

                    HStack(spacing: 6) {

                        Button(
                            intent: StartFocusIntent()
                        ) {
                            Text("RESUME")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)

                        Button(
                            intent: EndFocusIntent()
                        ) {
                            Text("END")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }

                } else {

                    Button(
                        intent: StartFocusIntent()
                    ) {
                        Text("START")
                            .font(.caption.bold())
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

        } dynamicIsland: { context in

            DynamicIsland {

                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "target")
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 3) {

                        Text(context.attributes.taskName)
                            .font(.headline)

                        if context.state.isRunning,
                           let startDate = context.state.startDate,
                           let endDate = context.state.endDate {

                            Text(
                                timerInterval: startDate...endDate,
                                countsDown: false,
                                showsHours: true
                            )
                            .font(
                                .system(
                                    .title3,
                                    design: .monospaced
                                )
                            )
                            .bold()

                        } else {

                            Text(
                                formatElapsedTime(
                                    context.state.elapsedTime
                                )
                            )
                            .font(
                                .system(
                                    .title3,
                                    design: .monospaced
                                )
                            )
                            .bold()
                        }
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.isRunning {

                        Button(
                            intent: PauseFocusIntent()
                        ) {
                            Image(
                                systemName: "pause.fill"
                            )
                        }

                    } else {

                        Button(
                            intent: StartFocusIntent()
                        ) {
                            Image(
                                systemName: "play.fill"
                            )
                        }
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 12) {

                        if context.state.isRunning {

                            Button(
                                intent: PauseFocusIntent()
                            ) {
                                Label(
                                    "Pause",
                                    systemImage: "pause.fill"
                                )
                            }

                            Button(
                                intent: EndFocusIntent()
                            ) {
                                Label(
                                    "End",
                                    systemImage: "stop.fill"
                                )
                            }

                        } else if context.state.isPaused {

                            Button(
                                intent: StartFocusIntent()
                            ) {
                                Label(
                                    "Resume",
                                    systemImage: "play.fill"
                                )
                            }

                            Button(
                                intent: EndFocusIntent()
                            ) {
                                Label(
                                    "End",
                                    systemImage: "stop.fill"
                                )
                            }

                        } else {

                            Button(
                                intent: StartFocusIntent()
                            ) {
                                Label(
                                    "Start",
                                    systemImage: "play.fill"
                                )
                            }
                        }
                    }
                }

            } compactLeading: {

                Image(systemName: "target")

            } compactTrailing: {

                if context.state.isRunning,
                   let startDate = context.state.startDate,
                   let endDate = context.state.endDate {

                    Text(
                        timerInterval: startDate...endDate,
                        countsDown: false,
                        showsHours: false
                    )
                    .monospacedDigit()

                } else {

                    Text(
                        formatElapsedTime(
                            context.state.elapsedTime
                        )
                    )
                    .monospacedDigit()
                }

            } minimal: {

                Image(systemName: "target")
            }
        }
    }
}

private func formatElapsedTime(
    _ time: TimeInterval
) -> String {

    let totalSeconds =
        max(0, Int(time))

    let hours =
        totalSeconds / 3600

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
