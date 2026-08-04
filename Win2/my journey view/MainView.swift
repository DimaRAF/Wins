//test
import SwiftUI

struct MainView: View {
    let weeks = [
        WeekItem(
            title: "Week 1",
            dateRange: "July 1 – July 7",
            isCompleted: true,
            isLocked: false,
            dailyData: [
                DailyFocus(day: "Sun", minutes: 10, isToday: false),
                DailyFocus(day: "Mon", minutes: 20, isToday: false),
                DailyFocus(day: "Tue", minutes: 23, isToday: false),
                DailyFocus(day: "Wed", minutes: 27, isToday: false),
                DailyFocus(day: "Thu", minutes: 30, isToday: false),
                DailyFocus(day: "Fri", minutes: 35, isToday: false),
                DailyFocus(day: "Sat", minutes: 40, isToday: true)
            ],
            insights: [
                InsightItem(icon: "bolt.fill", text: "You completed 5 out of 7 days this week.", theme: .orange),
                InsightItem(icon: "chart.line.uptrend.xyaxis", text: "Your highest productivity was on Thursday when your energy level was high.", theme: .green),
                InsightItem(icon: "flame.fill", text: "You're ready to increase your daily focus time from 35 to 40 minutes next week.", theme: .yellow),
                InsightItem(icon: "star.fill", text: "Sessions after 10 PM were completed more consistently.", theme: .purple)
            ]
        ),
        WeekItem(
            title: "Week 2",
            dateRange: "July 8 – July 14",
            isCompleted: false,
            isLocked: false,
            dailyData: [
                DailyFocus(day: "Sun", minutes: 30, isToday: false),
                DailyFocus(day: "Mon", minutes: 40, isToday: false),
                DailyFocus(day: "Tue", minutes: 40, isToday: false),
                DailyFocus(day: "Wed", minutes: 42, isToday: false),
                DailyFocus(day: "Thu", minutes: 45, isToday: false),
                DailyFocus(day: "Fri", minutes: 20, isToday: true),
                DailyFocus(day: "Sat", minutes: 0, isToday: false)
            ],
            insights: [
                InsightItem(icon: "bolt.fill", text: "You maintained a solid streak during the first half of the week.", theme: .yellow),
                InsightItem(icon: "chart.line.uptrend.xyaxis", text: "Thursday peaked with 45 minutes of total focus time.", theme: .green)
            ]
        ),
        WeekItem(title: "Week 3", dateRange: "July 15 – July 21", isCompleted: false, isLocked: true, dailyData: [], insights: []),
        WeekItem(title: "Week 4", dateRange: "July 22 – July 28", isCompleted: false, isLocked: true, dailyData: [], insights: [])
    ]
    
    @State private var selectedWeekTitle: String = "Week 1"
    
    var selectedWeek: WeekItem? {
        weeks.first(where: { $0.title == selectedWeekTitle })
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                
                WeekSelectorBarView(weeks: weeks, selectedWeekTitle: $selectedWeekTitle)
                    .padding(.top, 8)
                
                if let currentWeek = selectedWeek {
                    if !currentWeek.isLocked {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            WeekCardView(week: currentWeek)
                            
                            Text("DAILY FOCUS TIME")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                            
                            FocusChartCardView(weekTitle: currentWeek.title, dailyData: currentWeek.dailyData)
                            
                            Text("WEEKLY REFLECTION")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                            
                            WeeklyReflectionCardView(insights: currentWeek.insights)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        .id(currentWeek.id)
                    } else {
                        Text("This week is locked.")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    }
                }
                
                Spacer()
            }
        }
        
        .animation(.easeInOut, value: selectedWeekTitle)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
