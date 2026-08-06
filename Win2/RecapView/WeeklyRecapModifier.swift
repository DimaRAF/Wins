import SwiftUI

struct WeeklyRecapModifier: ViewModifier {
    @State private var currentPage = 0
    @State private var showAlert = false
    @State private var showRecap = false

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
                }

                Button("Maybe Later", role: .cancel) { }
            } message: {
                Text(
                    "Discover your wins and progress this week and celebrate your journey."
                )
            }
            .fullScreenCover(isPresented: $showRecap) {
                TabView(selection: $currentPage) {
                    Recap_1(currentPage: $currentPage)
                        .tag(0)

                    Recap_2(currentPage: $currentPage)
                        .tag(1)

                    Recap_3(currentPage: $currentPage)
                        .tag(2)

                    Recap_4(currentPage: $currentPage)
                        .tag(3)

                    Recap_5(currentPage: $currentPage)
                        .tag(4)
                }
                .tabViewStyle(
                    .page(indexDisplayMode: .never)
                )
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
        let weekday = Calendar.current.component(
            .weekday,
            from: Date()
        )

        if weekday == 1 {
            showAlert = true
            }
    }
}

extension View {
    func weeklyRecap() -> some View {
        modifier(WeeklyRecapModifier())
    }
}
