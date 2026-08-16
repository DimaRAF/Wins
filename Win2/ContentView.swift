import SwiftUI
import Combine
import WidgetKit


struct ContentView: View {
    let goal: String
    let whyGoalMatters: String
    let minimumMinutes: Int
    let maximumMinutes: Int
    let targetDate: Date
    let goalStartDate: Date

    @State private var completedMinutes = 0
    @State private var targetMinutes: Int
    @State private var selectedDate =
        Calendar.current.startOfDay(for: Date())
    
    @Environment(\.scenePhase) private var scenePhase

    private let recommendationAI = RecommendationAI()
    private let dailyDataStore = DailyDataStore.shared

    @State private var yesterdayEnergy: EnergyLevel? = nil
    @State private var todayEnergy: EnergyLevel? = nil

    @State private var yesterdayActualTime = 0
    @State private var yesterdayTarget = 0

    @State private var displayedCompletedMinutes = 0
    @State private var displayedTargetMinutes: Int
    @State private var displayedEnergy: EnergyLevel? = nil

    @State private var currentDay =
        Calendar.current.startOfDay(for: Date())

    @State private var currentWeekMinutes =
        Array(repeating: 0, count: 7)

    @State private var previousWeeks: [[Int]] = []

    private let dayCheckTimer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    )
    .autoconnect()

    init(
        goal: String,
        whyGoalMatters: String,
        minimumMinutes: Int,
        maximumMinutes: Int,
        targetDate: Date,
        goalStartDate: Date
    ) {
        self.goal = goal
        self.whyGoalMatters = whyGoalMatters
        self.minimumMinutes = minimumMinutes
        self.maximumMinutes = maximumMinutes
        self.targetDate = targetDate
        self.goalStartDate = goalStartDate

        // Day 1 starts with the onboarding minimum.
        _targetMinutes = State(initialValue: minimumMinutes)
        _displayedTargetMinutes = State(initialValue: minimumMinutes)
    }

    var body: some View {
        TabView {
            Tab("Goal", systemImage: "target") {
                GoalPageView(
                    completedMinutes: displayedCompletedBinding,
                    todayEnergy: displayedEnergyBinding,
                    targetMinutes: displayedTargetMinutes,
                    goal: goal,
                    targetDate: targetDate,
                    goalStartDate: goalStartDate,
                    currentDay: currentDay,
                    selectedDate: $selectedDate
                )
            }

            Tab(
                "Journey",
                systemImage: "point.topleft.down.curvedto.point.bottomright.up"
            ) {
                MainView(
                    currentWeekMinutes: currentWeekMinutes,
                    previousWeeks: previousWeeks,
                    targetDate: targetDate,
                    goalStartDate: goalStartDate
                )
            }

            Tab("Focus", systemImage: "timer") {
                FocusView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes
                )
            }
        }
        .weeklyRecap(
            goalStartDate: goalStartDate,
            targetDate: targetDate
        )
        .onAppear {
            checkForNewDay()

            SharedFocusData.setGoalName(goal)

            loadCurrentDayData()
            loadLatestYesterdayData()
            loadDataForSelectedDate()

            // AI starts only from Day 2.
            updateAIRecommendationIfPossible()

            WidgetCenter.shared.reloadTimelines(
                ofKind: "StrideWidget"
            )
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                checkForNewDay()
            }
        }
        .onChange(of: completedMinutes) { _, _ in
            updateCurrentDayInWeek()
        }
        .onChange(of: todayEnergy) { _, _ in
            // Today's Energy is an AI input.
            updateAIRecommendationIfPossible()
        }
        .onChange(of: selectedDate) { _, _ in
            loadDataForSelectedDate()
        }
        .onReceive(dayCheckTimer) { _ in
            checkForNewDay()
        }
    }

    // MARK: - Calendar Helpers

    private var calendar: Calendar {
        Calendar.current
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDate(
            date,
            inSameDayAs: Date()
        )
    }

    private func isYesterday(_ date: Date) -> Bool {
        guard let yesterday = calendar.date(
            byAdding: .day,
            value: -1,
            to: calendar.startOfDay(for: Date())
        ) else {
            return false
        }

        return calendar.isDate(
            date,
            inSameDayAs: yesterday
        )
    }

    private func isGoalStartDay(
        _ date: Date = Date()
    ) -> Bool {
        calendar.isDate(
            calendar.startOfDay(for: date),
            inSameDayAs: calendar.startOfDay(for: goalStartDate)
        )
    }

    // MARK: - Loading

    private func loadCurrentDayData() {
        let today = calendar.startOfDay(
            for: Date()
        )

        guard let savedDay = dailyDataStore.getDay(
            date: today
        ) else {
            completedMinutes = 0
            todayEnergy = nil

            // Day 1 starts with minimum.
            targetMinutes = minimumMinutes

            displayedCompletedMinutes = 0
            displayedTargetMinutes = minimumMinutes
            displayedEnergy = nil

            return
        }

        completedMinutes = savedDay.actualMinutes

        todayEnergy = savedDay.energy.flatMap {
            EnergyLevel(rawValue: $0.lowercased())
        }

        if isGoalStartDay(today) {
            // Day 1 target is ALWAYS minimum.
            targetMinutes = minimumMinutes
        } else {
            // From Day 2 onward, use the latest AI target saved for today.
            targetMinutes = savedDay.targetMinutes
        }

        displayedCompletedMinutes = completedMinutes
        displayedTargetMinutes = targetMinutes
        displayedEnergy = todayEnergy
    }

    private func loadLatestYesterdayData() {
        guard let yesterdayDate = calendar.date(
            byAdding: .day,
            value: -1,
            to: calendar.startOfDay(for: Date())
        ) else {
            return
        }

        guard let savedDay = dailyDataStore.getDay(
            date: yesterdayDate
        ) else {
            yesterdayActualTime = 0
            yesterdayTarget = minimumMinutes
            yesterdayEnergy = nil
            return
        }

        // Always use the latest saved data from DailyDataStore.
        yesterdayActualTime = savedDay.actualMinutes
        yesterdayTarget = savedDay.targetMinutes

        yesterdayEnergy = savedDay.energy.flatMap {
            EnergyLevel(rawValue: $0.lowercased())
        }

        print("""
        =========================
        LATEST YESTERDAY DATA

        Yesterday Energy: \(yesterdayEnergy?.title ?? "nil")
        Yesterday Actual: \(yesterdayActualTime)
        Yesterday Target: \(yesterdayTarget)
        Maximum: \(maximumMinutes)
        =========================
        """)
    }

    private func loadDataForSelectedDate() {
        // Today
        if isToday(selectedDate) {
            displayedCompletedMinutes = completedMinutes
            displayedTargetMinutes = targetMinutes
            displayedEnergy = todayEnergy
            return
        }

        // Previous days
        if let savedDay = dailyDataStore.getDay(
            date: selectedDate
        ) {
            displayedCompletedMinutes =
                savedDay.actualMinutes

            displayedTargetMinutes =
                savedDay.targetMinutes

            displayedEnergy =
                savedDay.energy.flatMap {
                    EnergyLevel(
                        rawValue: $0.lowercased()
                    )
                }
        } else {
            displayedCompletedMinutes = 0
            displayedTargetMinutes = minimumMinutes
            displayedEnergy = nil
        }
    }

    // MARK: - Actual Work Binding

    private var displayedCompletedBinding:
        Binding<Int> {

        Binding(
            get: {
                displayedCompletedMinutes
            },
            set: { newValue in

                // User can edit Actual Work only
                // for Today and Yesterday.
                guard isToday(selectedDate)
                        || isYesterday(selectedDate)
                else {
                    loadDataForSelectedDate()
                    return
                }

                displayedCompletedMinutes = newValue

                // MARK: Today

                if isToday(selectedDate) {
                    completedMinutes = newValue

                    dailyDataStore.saveDay(
                        date: selectedDate,
                        actualMinutes: newValue,
                        targetMinutes: targetMinutes,
                        energy: todayEnergy?.rawValue
                    )

                    return
                }

                // MARK: Yesterday

                let existing =
                    dailyDataStore.getDay(
                        date: selectedDate
                    )

                dailyDataStore.saveDay(
                    date: selectedDate,
                    actualMinutes: newValue,
                    targetMinutes:
                        existing?.targetMinutes
                        ?? minimumMinutes,
                    energy: existing?.energy
                )

                // IMPORTANT:
                // Reload the latest Yesterday data,
                // then recalculate Today's target.
                loadLatestYesterdayData()
                updateAIRecommendationIfPossible()
            }
        )
    }

    // MARK: - Energy Binding

    private var displayedEnergyBinding:
        Binding<EnergyLevel?> {

        Binding(
            get: {
                displayedEnergy
            },
            set: { newValue in

                // Energy can be edited only for
                // Today and Yesterday.
                guard isToday(selectedDate)
                        || isYesterday(selectedDate)
                else {
                    loadDataForSelectedDate()
                    return
                }

                displayedEnergy = newValue

                // MARK: Today

                if isToday(selectedDate) {
                    todayEnergy = newValue

                    dailyDataStore.saveDay(
                        date: selectedDate,
                        actualMinutes: completedMinutes,
                        targetMinutes: targetMinutes,
                        energy: newValue?.rawValue
                    )

                    // Today's Energy changed.
                    // Recalculate Today's Target.
                    updateAIRecommendationIfPossible()

                    return
                }

                // MARK: Yesterday

                let existing =
                    dailyDataStore.getDay(
                        date: selectedDate
                    )

                dailyDataStore.saveDay(
                    date: selectedDate,
                    actualMinutes:
                        existing?.actualMinutes
                        ?? displayedCompletedMinutes,
                    targetMinutes:
                        existing?.targetMinutes
                        ?? minimumMinutes,
                    energy: newValue?.rawValue
                )

                // Yesterday Energy changed.
                // Reload latest data and recalculate AI.
                loadLatestYesterdayData()
                updateAIRecommendationIfPossible()
            }
        )
    }

    // MARK: - AI Recommendation

    private func updateAIRecommendationIfPossible() {

        // =====================================================
        // DAY 1
        // =====================================================
        // No AI on the first day.
        // Target = onboarding minimum.
        // =====================================================

        guard !isGoalStartDay() else {

            targetMinutes = minimumMinutes

            if isToday(selectedDate) {
                displayedTargetMinutes = minimumMinutes
            }

            return
        }

        // =====================================================
        // DAY 2+
        // =====================================================

        // Always load the latest Yesterday data.
        loadLatestYesterdayData()

        // =====================================================
        // DEFAULT ENERGY
        //
        // If the user has not selected today's energy yet,
        // AI uses Medium automatically.
        // =====================================================

        let effectiveTodayEnergy =
            todayEnergy ?? .medium

        // If Yesterday has no saved energy,
        // use Medium as the default as well.
        let effectiveYesterdayEnergy =
            yesterdayEnergy ?? .medium

        // =====================================================
        // AI INPUTS
        //
        // 1. Yesterday Actual Work
        // 2. Yesterday Target Work
        // 3. Yesterday Energy
        // 4. Today's Energy
        // 5. Maximum Time
        // =====================================================

        let recommendation =
            recommendationAI.recommend(
                yesterdayEnergy:
                    effectiveYesterdayEnergy.rawValue.capitalized,

                todayEnergy:
                    effectiveTodayEnergy.rawValue.capitalized,

                yesterdayActualTime:
                    yesterdayActualTime,

                yesterdayTarget:
                    yesterdayTarget,

                maxAvailableTime:
                    maximumMinutes
            )

        // =====================================================
        // AI OWNS THE TARGET
        // =====================================================

        targetMinutes = recommendation

        if isToday(selectedDate) {
            displayedTargetMinutes = recommendation
        }

        // Save today's latest AI-generated target.
        //
        // IMPORTANT:
        // We keep the user's actual work unchanged.
        dailyDataStore.saveDay(
            date: calendar.startOfDay(
                for: Date()
            ),
            actualMinutes: completedMinutes,
            targetMinutes: recommendation,
            energy: effectiveTodayEnergy.rawValue
        )

        print("""
        =========================
        AI RECOMMENDATION

        Yesterday Energy:
        \(effectiveYesterdayEnergy.title)

        Today Energy:
        \(effectiveTodayEnergy.title)

        Yesterday Actual:
        \(yesterdayActualTime)

        Yesterday Target:
        \(yesterdayTarget)

        Maximum:
        \(maximumMinutes)

        Today's Target:
        \(recommendation)
        =========================
        """)
    }

    // MARK: - Day Transition

    private func updateCurrentDayInWeek() {
        let index = weekdayIndex(
            for: currentDay
        )

        currentWeekMinutes[index] =
            completedMinutes
    }

    private func checkForNewDay() {

        var calendar = Calendar.current
        calendar.firstWeekday = 1

        let today =
            calendar.startOfDay(
                for: Date()
            )

        guard today != currentDay else {
            return
        }

        let previousDayIndex =
            weekdayIndex(
                for: currentDay
            )

        currentWeekMinutes[previousDayIndex] =
            completedMinutes

        if calendar.component(
            .weekday,
            from: today
        ) == 1 {

            previousWeeks.append(
                currentWeekMinutes
            )

            currentWeekMinutes =
                Array(
                    repeating: 0,
                    count: 7
                )
        }

        // Save the previous day's final data.
        dailyDataStore.saveDay(
            date: currentDay,
            actualMinutes: completedMinutes,
            targetMinutes: targetMinutes,
            energy: todayEnergy?.rawValue
        )

        // Move to the new day.
        completedMinutes = 0

        SharedFocusData.resetDailyFocus()

        currentDay = today
        selectedDate = today

        todayEnergy = nil

        // Every new day starts with the minimum
        // until today's Energy is entered and AI
        // calculates the new target.
        targetMinutes = minimumMinutes

        displayedCompletedMinutes = 0
        displayedTargetMinutes = minimumMinutes
        displayedEnergy = nil

        // Load the latest previous day.
        loadLatestYesterdayData()
    }

    private func weekdayIndex(
        for date: Date
    ) -> Int {

        var calendar = Calendar.current
        calendar.firstWeekday = 1

        return calendar.component(
            .weekday,
            from: date
        ) - 1
    }
}

#Preview {
    ContentView(
        goal: "Sample Goal",
        whyGoalMatters: "Sample reason",
        minimumMinutes: 10,
        maximumMinutes: 60,
        targetDate: Calendar.current.date(
            byAdding: .month,
            value: 3,
            to: Date()
        )!,
        goalStartDate: Date()
    )
}
