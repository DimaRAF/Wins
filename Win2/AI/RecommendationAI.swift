//
//  RecommendationAI.swift
//  Win2
//
//  Created by Dima Rafat on 29/02/1448 AH.
//

import CoreML

final class RecommendationAI {

    private let model: MyTabularClassifier_dataset1_1

    init() {
        do {
            self.model =
                try MyTabularClassifier_dataset1_1(
                    configuration: MLModelConfiguration()
                )
        } catch {
            fatalError(
                "Failed to load AI model: \(error)"
            )
        }
    }

    func recommend(
        yesterdayEnergy: String,
        todayEnergy: String,
        yesterdayActualTime: Int,
        yesterdayTarget: Int,
        maxAvailableTime: Int
    ) -> Int {

        do {

            let prediction =
                try model.prediction(
                    Yesterday_Energy:
                        yesterdayEnergy,

                    Today_Energy:
                        todayEnergy,

                    Yesterday_Actual_Time:
                        Int64(yesterdayActualTime),

                    Yesterday_Target:
                        Int64(yesterdayTarget),

                    Max_Available_Time:
                        Int64(maxAvailableTime)
                )

            let aiRecommendation =
                Int(
                    prediction.Recommended_Time
                )

            // =================================================
            // IMPORTANT
            //
            // Minimum is NOT a constraint for AI.
            //
            // The onboarding minimum is used only for Day 1.
            //
            // From Day 2 onward:
            //
            // AI can recommend below the minimum.
            // =================================================

            let maximumSafe =
                min(
                    aiRecommendation,
                    maxAvailableTime
                )

            // Keep recommendations in 5-minute increments.
            let rounded =
                (maximumSafe / 5) * 5

            // Final protection:
            // AI recommendation must never exceed
            // the user's maximum available time.
            return min(
                rounded,
                maxAvailableTime
            )

        } catch {

            print(
                "AI prediction failed: \(error)"
            )

            // Safe fallback.
            //
            // We do NOT use minimum here because
            // minimum is not an AI constraint.
            //
            // If the model fails, return 0.
            return 0
        }
    }
}
