import SwiftUI

struct WeeklyRecapModifier: ViewModifier {
    let goalStartDate: Date
    let targetDate: Date

    @State private var currentPage = 0
    @State private var showAlert = false
    @State private var showRecap = false
    @State private var hasSeenRecapInThisSession = false

    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content
            .alert(
                "Your Weekly Story Is Ready!",
                isPresented: $showAlert
            ) {
                Button("View Weekly Recap") {
                    currentPage = 0
                    showRecap = true
                    hasSeenRecapInThisSession = true
                }

                Button("Maybe Later", role: .cancel) { }
            } message: {
                Text(
                    "Discover your wins and progress this week and celebrate your journey."
                )
            }
            .fullScreenCover(isPresented: $showRecap) {
                TabView(selection: $currentPage) {
                    Recap_1(currentPage: $currentPage).tag(0)
                    Recap_2(currentPage: $currentPage).tag(1)
                    Recap_3(currentPage: $currentPage).tag(2)
                    Recap_4(currentPage: $currentPage).tag(3)
                    Recap_5(currentPage: $currentPage).tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
            }
            .onAppear {
                checkIfSundayAndShowAlert()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    checkIfSundayAndShowAlert()
                }
            }
    }

    private func checkIfSundayAndShowAlert() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1 // الأحد = 1

        let today = Date()

        // 1. تحديد بداية الأيام لتجاهل فرق ا
        let startOfGoal = calendar.startOfDay(for: goalStartDate)
        let startOfToday = calendar.startOfDay(for: today)

        // 2. هل اليوم هو الأحد؟
        let isSunday = calendar.component(.weekday, from: today) == 1

        // 3. حساب عدد الأيام الفاصلة (نحتاج فقط أن تكون أكثر من 0 لتفادي نفس يوم التسجيل)
        let daysPassed = calendar.dateComponents([.day], from: startOfGoal, to: startOfToday).day ?? 0

        // 🔍 طباعة للتأكد
        print("🔍 --- DEBUG RECAP CHECK ---")
        print("📅 Is Sunday?: \(isSunday)")
        print("⏱️ Days Passed: \(daysPassed)")
        print("---------------------------")

        // الشرط: اليوم أحد + مرّ يوم واحد على الأقل من التسجيل + لم يُشاهد سابقاً في الجلسة
        if isSunday && daysPassed > 0 && !hasSeenRecapInThisSession {
            showAlert = true
        }
    }
}

extension View {
    func weeklyRecap(goalStartDate: Date, targetDate: Date) -> some View {
        modifier(WeeklyRecapModifier(goalStartDate: goalStartDate, targetDate: targetDate))
    }
}
