import SwiftUI

struct GoalPageView: View {
    @Binding var completedMinutes: Int

    let targetMinutes: Int
    let goal: String

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalendarView()

                ProgressCardView(
                    completedMinutes: $completedMinutes,
                    targetMinutes: targetMinutes,
                    goal: goal
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
        goal: "Learn Python"
    )
}
