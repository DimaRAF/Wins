import SwiftUI

@main
struct Win2App: App {
    // 0: Splash, 1: Onboarding, 2: Main App
    @AppStorage("onboardingStep")
    private var onboardingStep: Int = 0

    var body: some Scene {
        WindowGroup {
            switch onboardingStep {

            case 0:
                SplashView()

            case 1:
                OnboardingView()

            default:
                if let savedGoal =
                    GoalStore.shared.loadGoal() {

                    ContentView(
                        goal: savedGoal.goal,
                        whyGoalMatters:
                            savedGoal.whyGoalMatters,
                        minimumMinutes:
                            savedGoal.minimumMinutes,
                        maximumMinutes:
                            savedGoal.maximumMinutes,
                        targetDate:
                            savedGoal.targetDate,
                        goalStartDate:
                            savedGoal.goalStartDate,
                        onStartNewGoal: {
                            onboardingStep = 1
                        }
                    )

                } else {

                    OnboardingView()
                        .onAppear {
                            onboardingStep = 1
                        }
                }
            }
        }
    }
}
