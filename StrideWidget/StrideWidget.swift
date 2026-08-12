import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Timeline Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
}

// MARK: - Timeline Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        completion(
            SimpleEntry(date: Date())
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date()
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .never
        )

        completion(timeline)
    }
}

// MARK: - Lock Screen Widget View

struct StrideFocusWidgetView: View {

    var entry: Provider.Entry

    var body: some View {

        HStack(spacing: 4) {

            VStack(
                alignment: .leading,
                spacing: 0
            ) {

                Text("FOCUS")
                    .font(
                        .system(
                            size: 10,
                            weight: .semibold
                        )
                    )

                Text("Stride")
                    .font(
                        .system(
                            size: 11,
                            weight: .bold
                        )
                    )
                    .lineLimit(1)
            }

            Spacer(minLength: 2)

            Button(
                intent: StartFocusIntent()
            ) {
                Text("START")
                    .font(
                        .system(
                            size: 9,
                            weight: .bold
                        )
                    )
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.mini)
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

// MARK: - Widget

struct StrideWidget: Widget {

    let kind: String = "StrideWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in

            StrideFocusWidgetView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Stride Focus"
        )
        .description(
            "Start your focus session from the Lock Screen."
        )
        .supportedFamilies([
            .accessoryRectangular
        ])
    }
}
