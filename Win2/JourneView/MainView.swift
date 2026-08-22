import SwiftUI

struct MainView: View {

    // MARK: - Input

    let currentWeekMinutes: [Int]
    let previousWeeks: [[Int]]

    let targetDate: Date
    let goalStartDate: Date

    // MARK: - State

    @State private var dataRefreshID = UUID()

    @State private var selectedMonth = 1

    @State private var selectedWeekTitle = "Week 1"

    @State private var selectedChartDay: String? = nil

    // MARK: - Data Store

    private let dailyDataStore = DailyDataStore.shared

    // MARK: - Calendar

    private var appCalendar: Calendar {

        var calendar = Calendar.current

        // Sunday = first day of week
        calendar.firstWeekday = 1

        return calendar
    }

    // MARK: - Start Of Week

    private func startOfWeek(
        for date: Date
    ) -> Date {

        let calendar = appCalendar

        let startOfDay =
            calendar.startOfDay(
                for: date
            )

        let weekday =
            calendar.component(
                .weekday,
                from: startOfDay
            )

        let daysFromSunday = weekday - 1

        return calendar.date(
            byAdding: .day,
            value: -daysFromSunday,
            to: startOfDay
        ) ?? startOfDay
    }

    // MARK: - Current Week Number

    private var currentWeekNumber: Int {

        previousWeeks.count + 1
    }

    // MARK: - Total Weeks

    private var totalWeeks: Int {

        let calendar = Calendar.current

        let start =
            calendar.startOfDay(
                for: goalStartDate
            )

        let end =
            calendar.startOfDay(
                for: targetDate
            )

        let difference =
            calendar.dateComponents(
                [.day],
                from: start,
                to: end
            ).day ?? 0

        // Count both the start date and
        // the final date.
        let totalDays =
            difference + 1

        // At least one week.
        return max(
            1,
            Int(
                ceil(
                    Double(
                        max(totalDays, 1)
                    ) / 7.0
                )
            )
        )
    }

    // MARK: - Total Months

    private var totalMonths: Int {

        return max(
            1,
            Int(
                ceil(
                    Double(totalWeeks) / 4.0
                )
            )
        )
    }

    // MARK: - Daily Data From Store

    private func makeDailyData(
        forWeekNumber weekNumber: Int,
        fallbackMinutes: [Int],
        markToday: Bool
    ) -> [DailyFocus] {

        let calendar = appCalendar

        let goalStart =
            calendar.startOfDay(
                for: goalStartDate
            )

        let firstWeekStart =
            startOfWeek(
                for: goalStart
            )

        guard let weekStart =
                calendar.date(
                    byAdding: .day,
                    value: (weekNumber - 1) * 7,
                    to: firstWeekStart
                )
        else {
            return []
        }

        let today =
            calendar.startOfDay(
                for: Date()
            )

        let days = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]

        return (0..<7).map { index in

            let date =
                calendar.date(
                    byAdding: .day,
                    value: index,
                    to: weekStart
                )!

            let isToday =
                calendar.isDate(
                    date,
                    inSameDayAs: today
                )

            // Future day
            if date > today {

                return DailyFocus(
                    date: date,
                    day: days[index],
                    minutes: 0,
                    targetMinutes: 0,
                    isToday: false
                )
            }

            // Before goal started
            if date < goalStart {

                return DailyFocus(
                    date: date,
                    day: days[index],
                    minutes: 0,
                    targetMinutes: 0,
                    isToday: false
                )
            }

            // Read latest saved data
            let savedDay =
                dailyDataStore.getDay(
                    date: date
                )

            let actualMinutes =
                savedDay?.actualMinutes
                ?? (
                    index < fallbackMinutes.count
                    ? fallbackMinutes[index]
                    : 0
                )

            let targetMinutes =
                savedDay?.targetMinutes ?? 0

            return DailyFocus(
                date: date,
                day: days[index],
                minutes: Double(actualMinutes),
                targetMinutes: targetMinutes,
                isToday:
                    markToday && isToday
            )
        }
    }

    // MARK: - Generate Weekly Insights

    private func generateInsights(
        for dailyData: [DailyFocus]
    ) -> [InsightItem] {

        // Days where the user actually worked
        let completedDays =
            dailyData.filter {
                $0.minutes > 0
            }

        let completedCount =
            completedDays.count

        // --------------------------------------------------
        // 1. Completion
        // --------------------------------------------------

        let completionInsight =
            InsightItem(
                icon: "bolt.fill",
                text:
                    "You completed \(completedCount) out of 7 days this week.",
                theme: .orange
            )

        // --------------------------------------------------
        // 2. Highest productivity
        // --------------------------------------------------

        let highestDay =
            completedDays.max {
                $0.minutes < $1.minutes
            }

        let highestInsight: InsightItem

        if let highestDay {

            let energy =
                dailyDataStore
                    .getDay(
                        date: highestDay.date
                    )?
                    .energy

            let energyText =
                energy?.lowercased() ?? "medium"

            highestInsight =
                InsightItem(
                    icon:
                        "chart.line.uptrend.xyaxis",
                    text:
                        "Your highest productivity was on \(highestDay.day) when your energy level was \(energyText).",
                    theme: .green
                )

        } else {

            highestInsight =
                InsightItem(
                    icon:
                        "chart.line.uptrend.xyaxis",
                    text:
                        "Complete a few more sessions to see your productivity pattern.",
                    theme: .green
                )
        }

        // --------------------------------------------------
        // 3. Focus time insight
        // --------------------------------------------------

        let targets =
            dailyData.compactMap {
                data -> Int? in

                guard data.targetMinutes > 0
                else {
                    return nil
                }

                return data.targetMinutes
            }

        let actuals =
            completedDays.map {
                Int($0.minutes)
            }

        let averageActual: Int

        if actuals.isEmpty {

            averageActual = 0

        } else {

            averageActual =
                Int(
                    round(
                        Double(
                            actuals.reduce(
                                0,
                                +
                            )
                        )
                        /
                        Double(
                            actuals.count
                        )
                    )
                )
        }

        let currentTarget =
            targets.last ?? averageActual

        let recommendedTarget =
            max(
                currentTarget,
                Int(
                    ceil(
                        Double(
                            averageActual
                        ) / 5.0
                    ) * 5
                )
            )

        let targetInsight: InsightItem

        if recommendedTarget > currentTarget {

            targetInsight =
                InsightItem(
                    icon: "flame.fill",
                    text:
                        "You're ready to increase your daily focus time from \(currentTarget) to \(recommendedTarget) minutes next week.",
                    theme: .yellow
                )

        } else {

            targetInsight =
                InsightItem(
                    icon: "flame.fill",
                    text:
                        "You're maintaining your current daily focus target well. Keep building your consistency.",
                    theme: .yellow
                )
        }

        // --------------------------------------------------
        // 4. Consistency
        // --------------------------------------------------

        let totalFocusMinutes =
            dailyData.reduce(0) { total, day in
                total + Int(day.minutes)
            }

        let focusTimeInsight =
            InsightItem(
                icon: "star.fill",
                text:
                    "You focused for \(totalFocusMinutes) minutes this week. Keep building your momentum!",
                theme: .purple
            )

        return [
            completionInsight,
            highestInsight,
            targetInsight,
            focusTimeInsight
        ]
    }

    // MARK: - Weeks For Selected Month

    private var weeksForSelectedMonth: [WeekItem] {

        let firstWeek =
            ((selectedMonth - 1) * 4) + 1

        // The last week of this month
        // cannot exceed the actual goal duration.
        let lastWeek =
            min(
                firstWeek + 3,
                totalWeeks
            )

        // Safety check
        guard firstWeek <= lastWeek else {
            return []
        }

        return (firstWeek...lastWeek).map {
            weekNumber in

            // ------------------------------------------------
            // Completed Week
            // ------------------------------------------------

            if weekNumber < currentWeekNumber {

                let fallbackMinutes: [Int] =

                    weekNumber - 1 <
                    previousWeeks.count

                    ? previousWeeks[
                        weekNumber - 1
                    ]

                    : Array(
                        repeating: 0,
                        count: 7
                    )

                let dailyData =
                    makeDailyData(
                        forWeekNumber:
                            weekNumber,
                        fallbackMinutes:
                            fallbackMinutes,
                        markToday:
                            false
                    )

                return WeekItem(
                    title:
                        "Week \(weekNumber)",

                    dateRange:
                        "Previous Week",

                    isCompleted:
                        true,

                    isLocked:
                        false,

                    dailyData:
                        dailyData,

                    insights:
                        generateInsights(
                            for: dailyData
                        )
                )
            }

            // ------------------------------------------------
            // Current / Active Week
            // ------------------------------------------------

            if weekNumber == currentWeekNumber {

                let dailyData =
                    makeDailyData(
                        forWeekNumber:
                            weekNumber,
                        fallbackMinutes:
                            currentWeekMinutes,
                        markToday:
                            true
                    )

                return WeekItem(
                    title:
                        "Week \(weekNumber)",

                    dateRange:
                        "Current Week",

                    isCompleted:
                        false,

                    isLocked:
                        false,

                    dailyData:
                        dailyData,

                    insights:
                        generateInsights(
                            for: dailyData
                        )
                )
            }

            // ------------------------------------------------
            // Future / Locked Week
            // ------------------------------------------------

            let dailyData =
                makeDailyData(
                    forWeekNumber:
                        weekNumber,
                    fallbackMinutes:
                        Array(
                            repeating: 0,
                            count: 7
                        ),
                    markToday:
                        false
                )

            return WeekItem(
                title:
                    "Week \(weekNumber)",

                dateRange:
                    "Upcoming",

                isCompleted:
                    false,

                isLocked:
                    true,

                dailyData:
                    dailyData,

                // Future weeks don't have insights yet.
                insights: []
            )
        }
    }

    // MARK: - Selected Week

    private var selectedWeek: WeekItem? {

        weeksForSelectedMonth.first {
            $0.title ==
                selectedWeekTitle
        }
    }

    // MARK: - Body

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(
                spacing: 12
            ) {

                // ------------------------------------------------
                // Month Selector
                // ------------------------------------------------

                HeaderView(
                    targetDate:
                        targetDate,

                    goalStartDate:
                        goalStartDate,

                    totalMonths:
                        totalMonths,

                    selectedMonth:
                        $selectedMonth
                )

                // ------------------------------------------------
                // Week Selector
                // ------------------------------------------------

                WeekSelectorBarView(
                    weeks:
                        weeksForSelectedMonth,

                    selectedWeekTitle:
                        $selectedWeekTitle
                )
                .padding(.top, 8)

                // ------------------------------------------------
                // Selected Week Content
                // ------------------------------------------------

                if let selectedWeek {

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        // Week Card

                        WeekCardView(
                            week:
                                selectedWeek
                        )

                        // Daily Focus Time

                        Text(
                            "DAILY FOCUS TIME"
                        )
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundColor(
                            .gray
                        )
                        .padding(
                            .horizontal,
                            20
                        )
                        .padding(
                            .top,
                            4
                        )

                        // Chart

                        FocusChartCardView(
                            weekTitle:
                                selectedWeek.title,

                            dailyData:
                                selectedWeek.dailyData,

                            selectedDay:
                                $selectedChartDay
                        )
                        .id(
                            dataRefreshID
                        )

                        // Weekly Reflection

                        Text(
                            "WEEKLY REFLECTION"
                        )
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundColor(
                            .gray
                        )
                        .padding(
                            .horizontal,
                            20
                        )
                        .padding(
                            .top,
                            4
                        )

                        WeeklyReflectionCardView(
                            insights:
                                selectedWeek.insights
                        )
                    }
                    .transition(
                        .opacity.combined(
                            with:
                                .scale(
                                    scale: 0.98
                                )
                        )
                    )
                    .id(
                        selectedWeek.id
                    )
                    .contentShape(
                        Rectangle()
                    )
                    .onTapGesture {
                        selectedChartDay = nil
                    }
                }

                Spacer()
            }
        }

        // --------------------------------------------------------
        // Animation
        // --------------------------------------------------------

        .animation(
            .easeInOut,
            value:
                selectedWeekTitle
        )

        // --------------------------------------------------------
        // Initial State
        // --------------------------------------------------------

        .onAppear {

            selectedMonth =
                monthForWeek(
                    currentWeekNumber
                )

            selectedWeekTitle =
                "Week \(currentWeekNumber)"
        }

        // --------------------------------------------------------
        // Month Changed
        // --------------------------------------------------------

        .onChange(
            of: selectedMonth
        ) { _, newMonth in

            selectedChartDay = nil

            let firstWeek =
                ((newMonth - 1) * 4) + 1

            let lastWeek =
                min(
                    firstWeek + 3,
                    totalWeeks
                )

            // If current week belongs
            // to the selected month,
            // keep it selected.

            if currentWeekNumber >= firstWeek &&
                currentWeekNumber <= lastWeek {

                selectedWeekTitle =
                    "Week \(currentWeekNumber)"

            } else {

                // Otherwise select the first
                // available week in this month.

                selectedWeekTitle =
                    "Week \(firstWeek)"
            }
        }

        // --------------------------------------------------------
        // Daily Data Changed
        // --------------------------------------------------------

        .onReceive(
            NotificationCenter.default.publisher(
                for:
                    .dailyDataDidChange
            )
        ) { _ in

            // Refresh the Journey data
            // after Actual Work changes.

            selectedChartDay = nil

            dataRefreshID =
                UUID()
        }
    }

    // MARK: - Month For Week

    private func monthForWeek(
        _ weekNumber: Int
    ) -> Int {

        let month =
            ((weekNumber - 1) / 4) + 1

        return min(
            max(
                month,
                1
            ),
            totalMonths
        )
    }
}

// MARK: - Preview

#Preview {

    MainView(

        currentWeekMinutes: [
            30,
            45,
            20,
            60,
            0,
            0,
            0
        ],

        previousWeeks: [
            [
                10,
                20,
                23,
                27,
                30,
                35,
                40
            ]
        ],

        targetDate:
            Calendar.current.date(
                byAdding: .day,
                value: 120,
                to: Date()
            )!,

        goalStartDate:
            Date()
    )
}
