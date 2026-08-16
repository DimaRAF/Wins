import SwiftUI

struct GoalPageView: View {
    @Binding var completedMinutes: Int
    @Binding var todayEnergy: EnergyLevel?

    let targetMinutes: Int
    let goal: String
    let targetDate: Date
    let goalStartDate: Date
    let currentDay: Date
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalendarView(
                    goalStartDate: goalStartDate,
                    selectedDate: $selectedDate
                )
                
                ProgressCardView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes,
                    goal: goal,
                    targetDate: targetDate,
                    goalStartDate: goalStartDate,
                    currentDay: currentDay
                )

                EnergyCheckInView(
                    selectedEnergy: $todayEnergy
                )
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
        todayEnergy: .constant(.medium),
        targetMinutes: 120,
        goal: "Sample Goal",
        targetDate: Calendar.current.date(
            byAdding: .month,
            value: 3,
            to: Date()
        )!,
        goalStartDate: Date(),
        currentDay: Date(),
        selectedDate: .constant(Date())
    )
}
