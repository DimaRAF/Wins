import SwiftUI

@main
struct Win2App: App {
    // 0: Splash, 1: Onboarding, 2: Main App (ContentView)
    @AppStorage("onboardingStep") private var onboardingStep: Int = 0
    
    var body: some Scene {
        WindowGroup {
            switch onboardingStep {
            case 0:
                SplashView()
            case 1:
                OnboardingView() // الآن لن يتم تجاهلها!
            default:
                ContentView(
                    goal: "Sample Goal",
                    whyGoalMatters: "Sample reason",
                    minimumMinutes: 10,
                    maximumMinutes: 60,
                    targetDate: Date().addingTimeInterval(86400 * 30),
                    goalStartDate: Date()
                )
            }
        }
    }
}
