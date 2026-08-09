import SwiftUI
import Combine

struct ContentView: View {
    let goal: String
    let whyGoalMatters: String
    let minimumMinutes: Int
    let maximumMinutes: Int
    let targetDate: Date

    @State private var completedMinutes = 0
    @State private var targetMinutes = 120

    @State private var currentDay =
        Calendar.current.startOfDay(for: Date())

    @State private var currentWeekMinutes =
        Array(repeating: 0, count: 7)

    @State private var previousWeeks: [[Int]] = []

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
                MainView(
                    currentWeekMinutes: currentWeekMinutes,
                    previousWeeks: previousWeeks
                )
            }

            Tab("Focus", systemImage: "timer") {
                FocusView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes
                )
            }
        }
        .weeklyRecap()
        .onChange(of: completedMinutes) { _, _ in
            updateCurrentDayInWeek()
        }
        .onReceive(dayCheckTimer) { _ in
            checkForNewDay()
        }
    }

    private func updateCurrentDayInWeek() {
        let index = weekdayIndex(for: currentDay)
        currentWeekMinutes[index] = completedMinutes
    }

    private func checkForNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard today != currentDay else {
            return
        }

        let previousDayIndex =
            weekdayIndex(for: currentDay)

        currentWeekMinutes[previousDayIndex] =
            completedMinutes

        if calendar.component(
            .weekday,
            from: today
        ) == 1 {
            previousWeeks.append(currentWeekMinutes)

            currentWeekMinutes =
                Array(repeating: 0, count: 7)
        }

        completedMinutes = 0
        currentDay = today
    }

    private func weekdayIndex(for date: Date) -> Int {
        Calendar.current.component(
            .weekday,
            from: date
        ) - 1
    }
}

#Preview {
    
    
    ContentView(
        goal: "Learn Python",
        whyGoalMatters: "For my career",
        minimumMinutes: 10,
        maximumMinutes: 60,
        targetDate: Date()
    )
}
