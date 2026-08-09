import SwiftUI

struct MainView: View {
    let currentWeekMinutes: [Int]
    let previousWeeks: [[Int]]

    @State private var selectedWeekTitle: String = "Week 1"

    private var weeks: [WeekItem] {
        var result: [WeekItem] = []

        for (index, weekData) in previousWeeks.enumerated() {
            result.append(
                WeekItem(
                    title: "Week \(index + 1)",
                    dateRange: "Previous Week",
                    isCompleted: true,
                    isLocked: false,
                    dailyData: makeDailyData(
                        from: weekData,
                        markToday: false
                    ),
                    insights: []
                )
            )
        }

        let currentWeekNumber = previousWeeks.count + 1

        result.append(
            WeekItem(
                title: "Week \(currentWeekNumber)",
                dateRange: "Current Week",
                isCompleted: false,
                isLocked: false,
                dailyData: makeDailyData(
                    from: currentWeekMinutes,
                    markToday: true
                ),
                insights: []
            )
        )

        return result
    }

    private var selectedWeek: WeekItem? {
        weeks.first {
            $0.title == selectedWeekTitle
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {

                HeaderView()

                WeekSelectorBarView(
                    weeks: weeks,
                    selectedWeekTitle: $selectedWeekTitle
                )
                .padding(.top, 8)

                if let currentWeek = selectedWeek {
                    VStack(alignment: .leading, spacing: 12) {

                        WeekCardView(
                            week: currentWeek
                        )

                        Text("DAILY FOCUS TIME")
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
                            weekTitle: currentWeek.title,
                            dailyData: currentWeek.dailyData
                        )

                        Text("WEEKLY REFLECTION")
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
                            insights: currentWeek.insights
                        )
                    }
                    .transition(
                        .opacity.combined(
                            with: .scale(scale: 0.98)
                        )
                    )
                    .id(currentWeek.id)
                }

                Spacer()
            }
        }
        .animation(
            .easeInOut,
            value: selectedWeekTitle
        )
        .onAppear {
            selectedWeekTitle =
                "Week \(previousWeeks.count + 1)"
        }
    }

    private func makeDailyData(
        from minutes: [Int],
        markToday: Bool
    ) -> [DailyFocus] {
        let days = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]

        let todayIndex =
            Calendar.current.component(
                .weekday,
                from: Date()
            ) - 1

        return days.enumerated().map {
            index,
            day in

            DailyFocus(
                day: day,
                minutes:
                    index < minutes.count
                    ? Double(minutes[index])
                    : 0,
                isToday:
                    markToday
                    && index == todayIndex
            )
        }
    }
}

#Preview {
    MainView(
        currentWeekMinutes: [
            30, 45, 20, 60, 0, 0, 0
        ],
        previousWeeks: [
            [10, 20, 23, 27, 30, 35, 40]
        ]
    )
}
