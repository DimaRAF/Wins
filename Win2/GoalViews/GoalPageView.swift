import SwiftUI

struct GoalPageView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalendarView()
                ProgressCardView()
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
    GoalPageView()
}
