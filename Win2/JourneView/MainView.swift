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
        calendar.firstWeekday = 1
        return calendar
    }

    // MARK: - Current Week Number

    private var currentWeekNumber: Int {

        let calendar = appCalendar

        let startDate = calendar.startOfDay(
            for: goalStartDate
        )

        let today = calendar.startOfDay(
            for: Date()
        )

        // Before the goal starts
        if today < startDate {
            return 1
        }

        // Find the first Saturday
        // of the first week.
        let weekday = calendar.component(
            .weekday,
            from: startDate
        )

        // Sunday = 1
        // Monday = 2
        // ...
        // Saturday = 7
        let daysUntilSaturday = 7 - weekday

        guard let firstSaturday = calendar.date(
            byAdding: .day,
            value: daysUntilSaturday,
            to: startDate
        ) else {
            return 1
        }

        // Week 1:
        // Goal Start → Saturday
        if today <= firstSaturday {
            return 1
        }

        // Week 2 starts on Sunday
        guard let firstSunday = calendar.date(
            byAdding: .day,
            value: 1,
            to: firstSaturday
        ) else {
            return 1
        }

        let daysSinceFirstSunday =
            calendar.dateComponents(
                [.day],
                from: firstSunday,
                to: today
            ).day ?? 0

        let calculatedWeek =
            2 + (daysSinceFirstSunday / 7)

        // Never go beyond the actual goal duration
        return min(
            max(calculatedWeek, 1),
            totalWeeks
        )
    }

    // MARK: - Total Weeks

    private var totalWeeks: Int {

        let calendar = appCalendar

        let start = calendar.startOfDay(
            for: goalStartDate
        )

        let end = calendar.startOfDay(
            for: targetDate
        )

        guard start <= end else {
            return 1
        }

        // Week 1:
        // Goal Start → Saturday

        let weekday = calendar.component(
            .weekday,
            from: start
        )

        let daysUntilSaturday = 7 - weekday

        guard let firstSaturday = calendar.date(
            byAdding: .day,
            value: daysUntilSaturday,
            to: start
        ) else {
            return 1
        }

        // Goal finishes during Week 1
        if end <= firstSaturday {
            return 1
        }

        // Week 2 starts on Sunday
        guard let firstSunday = calendar.date(
            byAdding: .day,
            value: 1,
            to: firstSaturday
        ) else {
            return 1
        }

        let remainingDays =
            calendar.dateComponents(
                [.day],
                from: firstSunday,
                to: end
            ).day ?? 0

        let remainingWeeks = Int(
            ceil(
                Double(remainingDays + 1) / 7.0
            )
        )

        return 1 + remainingWeeks
    }

    // MARK: - Total Months

    private var totalMonths: Int {
        max(
            1,
            Int(
                ceil(
                    Double(totalWeeks) / 4.0
                )
            )
        )
    }

    // MARK: - Week Start Date

    private func weekStartDate(
        forWeekNumber weekNumber: Int
    ) -> Date {

        let calendar = appCalendar

        let goalStart = calendar.startOfDay(
            for: goalStartDate
        )

        // Week 1 starts exactly on
        // the goal start date.
        if weekNumber == 1 {
            return goalStart
        }

        let weekday = calendar.component(
            .weekday,
            from: goalStart
        )

        // Sunday = 1
        // Saturday = 7
        let daysUntilSaturday = 7 - weekday

        guard let firstSaturday = calendar.date(
            byAdding: .day,
            value: daysUntilSaturday,
            to: goalStart
        ) else {
            return goalStart
        }

        // Week 2 starts on Sunday.
        guard let firstSunday = calendar.date(
            byAdding: .day,
            value: 1,
            to: firstSaturday
        ) else {
            return goalStart
        }

        // Week 3, 4, 5...
        // each starts 7 days later.
        return calendar.date(
            byAdding: .day,
            value: (weekNumber - 2) * 7,
            to: firstSunday
        ) ?? firstSunday
    }

    // MARK: - Real Week Date Range

    private func weekDateRange(
        forWeekNumber weekNumber: Int
    ) -> String {

        let calendar = appCalendar

        let goalStart = calendar.startOfDay(
            for: goalStartDate
        )

        let goalEnd = calendar.startOfDay(
            for: targetDate
        )

        let weekStart: Date

        if weekNumber == 1 {

            // Week 1 starts exactly on the
            // user's goal start date.
            weekStart = goalStart

        } else {

            // Find the first Saturday after
            // the goal start date.

            let weekday = calendar.component(
                .weekday,
                from: goalStart
            )

            // Sunday = 1
            // Monday = 2
            // ...
            // Saturday = 7

            let daysUntilSaturday =
                (7 - weekday + 7) % 7

            guard let firstSaturday =
                calendar.date(
                    byAdding: .day,
                    value: daysUntilSaturday,
                    to: goalStart
                )
            else {
                return ""
            }

            // Week 2 starts on Sunday
            // immediately after that Saturday.
            guard let firstSunday =
                calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: firstSaturday
                )
            else {
                return ""
            }

            // Every week after Week 1
            // starts on Sunday.
            guard let calculatedStart =
                calendar.date(
                    byAdding: .day,
                    value: (weekNumber - 2) * 7,
                    to: firstSunday
                )
            else {
                return ""
            }

            weekStart = calculatedStart
        }

        guard weekStart <= goalEnd else {
            return ""
        }

        // Normal weeks end on Saturday.
        guard let normalWeekEnd =
            calendar.date(
                byAdding: .day,
                value:
                    weekNumber == 1
                    ? (
                        7 -
                        calendar.component(
                            .weekday,
                            from: goalStart
                        )
                    )
                    : 6,
                to: weekStart
            )
        else {
            return ""
        }

        // The final week cannot go beyond
        // the user's selected target date.
        let weekEnd = min(
            normalWeekEnd,
            goalEnd
        )

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d MMM"

        return "\(formatter.string(from: weekStart)) – \(formatter.string(from: weekEnd))"
    }

    // MARK: - Daily Data

    private func makeDailyData(
        forWeekNumber weekNumber: Int,
        fallbackMinutes: [Int],
        markToday: Bool
    ) -> [DailyFocus] {

        let calendar = appCalendar

        let goalStart = calendar.startOfDay(
            for: goalStartDate
        )

        // IMPORTANT:
        // This is ONLY for the chart.
        // The chart still displays Sun-Sat.
        let firstWeekStart = startOfWeek(
            for: goalStart
        )

        guard let weekStart = calendar.date(
            byAdding: .day,
            value: (weekNumber - 1) * 7,
            to: firstWeekStart
        ) else {
            return []
        }

        let today = calendar.startOfDay(
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

            let date = calendar.date(
                byAdding: .day,
                value: index,
                to: weekStart
            )!

            let isToday = calendar.isDate(
                date,
                inSameDayAs: today
            )

            if date > today {

                return DailyFocus(
                    date: date,
                    day: days[index],
                    minutes: 0,
                    targetMinutes: 0,
                    isToday: false
                )
            }

            if date < goalStart {

                return DailyFocus(
                    date: date,
                    day: days[index],
                    minutes: 0,
                    targetMinutes: 0,
                    isToday: false
                )
            }

            let savedDay =
                dailyDataStore.getDay(
                    date: date
                )

            let actualMinutes =
                savedDay?.actualMinutes ??
                (
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

    // MARK: - Start Of Week
    // Used ONLY by the chart.

    private func startOfWeek(
        for date: Date
    ) -> Date {

        let calendar = appCalendar

        let startOfDay = calendar.startOfDay(
            for: date
        )

        let weekday = calendar.component(
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

    // MARK: - Weekly Insights

    private func generateInsights(
        for dailyData: [DailyFocus]
    ) -> [InsightItem] {

        let completedDays =
            dailyData.filter {
                let date = appCalendar.startOfDay(
                    for: $0.date
                )

                let start =
                    appCalendar.startOfDay(
                        for: goalStartDate
                    )

                let end =
                    appCalendar.startOfDay(
                        for: targetDate
                    )

                return date >= start &&
                       date <= end &&
                       $0.minutes > 0
            }

        let validDays =
            dailyData.filter {
                let date = appCalendar.startOfDay(
                    for: $0.date
                )

                let start =
                    appCalendar.startOfDay(
                        for: goalStartDate
                    )

                let end =
                    appCalendar.startOfDay(
                        for: targetDate
                    )

                return date >= start &&
                       date <= end
            }

        let completedCount =
            completedDays.count

        let totalDays =
            validDays.count

        let completionInsight =
            InsightItem(
                icon: "bolt.fill",
                text:
                    "You completed \(completedCount) out of \(totalDays) days this week.",
                theme: .orange
            )

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

        let targets =
            dailyData.compactMap {
                data -> Int? in

                guard data.targetMinutes > 0 else {
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

        let totalFocusMinutes =
            dailyData.reduce(0) {
                total,
                day in

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

        let lastWeek =
            min(
                firstWeek + 3,
                totalWeeks
            )

        guard firstWeek <= lastWeek else {
            return []
        }

        return (firstWeek...lastWeek).map {
            weekNumber in

            // MARK: Completed Week

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

                    weekDateRange:
                        weekDateRange(
                            forWeekNumber:
                                weekNumber
                        ),

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

            // MARK: Current Week

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

                    weekDateRange:
                        weekDateRange(
                            forWeekNumber:
                                weekNumber
                        ),

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

            // MARK: Future Week

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

                weekDateRange:
                    weekDateRange(
                        forWeekNumber:
                            weekNumber
                    ),

                isCompleted:
                    false,

                isLocked:
                    true,

                dailyData:
                    dailyData,

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

                WeekSelectorBarView(
                    weeks:
                        weeksForSelectedMonth,

                    selectedWeekTitle:
                        $selectedWeekTitle
                )
                .padding(.top, 8)

                if let selectedWeek {

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        WeekCardView(
                            week:
                                selectedWeek
                        )

                        Text(
                            "DAILY FOCUS TIME"
                        )
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

                        FocusChartCardView(
                            weekTitle:
                                selectedWeek.title,

                            dailyData:
                                selectedWeek.dailyData,

                            selectedDay:
                                $selectedChartDay
                        )
                        .id(dataRefreshID)

                        Text(
                            "WEEKLY REFLECTION"
                        )
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)

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
                    .id(selectedWeek.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedChartDay = nil
                    }
                }

                Spacer()
            }
        }

        .animation(
            .easeInOut,
            value: selectedWeekTitle
        )

        .onAppear {

            selectedMonth =
                monthForWeek(
                    currentWeekNumber
                )

            selectedWeekTitle =
                "Week \(currentWeekNumber)"
        }

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

            if currentWeekNumber >= firstWeek &&
                currentWeekNumber <= lastWeek {

                selectedWeekTitle =
                    "Week \(currentWeekNumber)"

            } else {

                selectedWeekTitle =
                    "Week \(firstWeek)"
            }
        }

        .onReceive(
            NotificationCenter.default.publisher(
                for:
                    .dailyDataDidChange
            )
        ) { _ in

            selectedChartDay = nil

            dataRefreshID = UUID()
        }
    }

    // MARK: - Month For Week

    private func monthForWeek(
        _ weekNumber: Int
    ) -> Int {

        let month =
            ((weekNumber - 1) / 4) + 1

        return min(
            max(month, 1),
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
