import SwiftUI

struct ContentView: View {
    @State private var completedMinutes = 0
    @State private var targetMinutes = 120

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
                GoalPageView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes
                )
            }
        }
        .weeklyRecap()
    }
}

#Preview {
    ContentView()
}
