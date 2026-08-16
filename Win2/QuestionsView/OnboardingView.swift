//
//  OnboardingView.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 26/02/1448 AH.
//

import SwiftUI

struct OnboardingView: View {

    @State private var currentQuestion = 1

    @State private var goal = ""
    @State private var whyGoalMatters = ""

    @State private var minimumMinutes = 10
    @State private var maximumMinutes = 45

    @State private var targetDate = Date()
    @State private var goalStartDate = Date()

    @State private var isOnboardingComplete = false

    @State private var savedGoal: SavedGoal?

    init() {

        let saved =
            GoalStore.shared.loadGoal()

        _savedGoal =
            State(
                initialValue: saved
            )

        _isOnboardingComplete =
            State(
                initialValue: saved != nil
            )
    }

    var body: some View {

        Group {

            if let savedGoal {

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
                        savedGoal.goalStartDate
                )

            } else if currentQuestion == 1 {

                Question1(
                    goal: $goal,
                    next: {
                        currentQuestion = 2
                    }
                )

            } else if currentQuestion == 2 {

                Question2(
                    whyGoalMatters:
                        $whyGoalMatters,
                    next: {
                        currentQuestion = 3
                    },
                    back: {
                        currentQuestion = 1
                    }
                )

            } else if currentQuestion == 3 {

                Question3(
                    selectedMinimumMinutes:
                        $minimumMinutes,
                    next: {
                        currentQuestion = 4
                    },
                    back: {
                        currentQuestion = 2
                    }
                )

            } else if currentQuestion == 4 {

                Question4(
                    selectedMaximumMinutes:
                        $maximumMinutes,
                    next: {
                        currentQuestion = 5
                    },
                    back: {
                        currentQuestion = 3
                    }
                )

            } else if currentQuestion == 5 {

                Question5(
                    selectedDate: $targetDate,
                    next: {

                        goalStartDate =
                            Calendar.current
                            .startOfDay(
                                for: Date()
                            )

                        GoalStore.shared.saveGoal(
                            goal: goal,
                            whyGoalMatters:
                                whyGoalMatters,
                            minimumMinutes:
                                minimumMinutes,
                            maximumMinutes:
                                maximumMinutes,
                            targetDate:
                                targetDate,
                            goalStartDate:
                                goalStartDate
                        )

                        savedGoal =
                            GoalStore.shared.loadGoal()

                    },
                    back: {
                        currentQuestion = 4
                    }
                )
            }
        }
    }
}

#Preview {
    OnboardingView()
}
