import SwiftUI

struct GoalPageView: View {
    @Binding var completedMinutes: Int

    let targetMinutes: Int
    let goal: String
    let targetDate: Date
    let goalStartDate: Date
    let currentDay: Date

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalendarView(
                    goalStartDate: goalStartDate
                )

                ProgressCardView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes,
                    goal: goal,
                    targetDate: targetDate,
                    goalStartDate: goalStartDate,
                    currentDay: currentDay
                )

                EnergyCheckInView()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
        .background(Color("AppBackground"))
    }
}

#Preview {
    GoalPageView(
        completedMinutes: .constant(90),
        targetMinutes: 120,
        goal: "Sample Goal",
        targetDate: Calendar.current.date(
            byAdding: .month,
            value: 3,
            to: Date()
        )!,
        goalStartDate: Date(),
        currentDay: Date()
    )
}
