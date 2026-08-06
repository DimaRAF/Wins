import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {

            Tab("Goal", systemImage: "target") {
                GoalPageView()
            }

            Tab("Journey", systemImage: "point.topleft.down.curvedto.point.bottomright.up") {
                MainView()
            }

            Tab("Focus", systemImage: "timer") {
                GoalPageView()
            }
        }
    }
}

#Preview {
    ContentView()
}
