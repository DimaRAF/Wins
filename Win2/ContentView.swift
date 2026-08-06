import SwiftUI
import Combine

struct ContentView: View {
    @State private var completedMinutes = 0
    @State private var targetMinutes = 1

    @State private var currentDay =
        Calendar.current.startOfDay(for: Date())

    private let dayCheckTimer = Timer.publish(
        every: 60,
        on: .main,
        in: .common
    )
    .autoconnect()

    var body: some View {
        TabView {

            Tab("Goal", systemImage: "target") {
                GoalPageView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes
                )
            }

            Tab(
                "Journey",
                systemImage: "point.topleft.down.curvedto.point.bottomright.up"
            ) {
                MainView()
            }

            Tab("Focus", systemImage: "timer") {
                FocusView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes
                )
            }
        }
        .weeklyRecap()
        .onReceive(dayCheckTimer) { _ in
            checkForNewDay()
        }
    }

    private func checkForNewDay() {
        let today =
            Calendar.current.startOfDay(for: Date())

        if today != currentDay {
            completedMinutes = 0
            currentDay = today
        }
    }
}

#Preview {
    ContentView()
}
