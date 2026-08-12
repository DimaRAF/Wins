import AppIntents
import SwiftUI
import WidgetKit

struct StrideWidgetControl: ControlWidget {

    static let kind =
        "com.stride.app.FocusControl"

    var body: some ControlWidgetConfiguration {

        StaticControlConfiguration(
            kind: Self.kind
        ) {

            ControlWidgetButton(
                action: StartFocusIntent()
            ) {

                Label(
                    "Start Focus",
                    systemImage: "target"
                )
            }
        }
        .displayName("Stride Focus")
        .description(
            "Start your focus session without opening Stride."
        )
    }
}
