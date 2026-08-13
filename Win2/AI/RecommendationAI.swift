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
            self.model = try MyTabularClassifier_dataset1_1(
                configuration: MLModelConfiguration()
            )
        } catch {
            fatalError("Failed to load AI model: \(error)")
        }
    }

    func recommend(
        yesterdayEnergy: String,
        todayEnergy: String,
        yesterdayActualTime: Int,
        yesterdayTarget: Int,
        maxAvailableTime: Int,
        minimumTime: Int
    ) -> Int {

        do {

            let prediction = try model.prediction(
                Yesterday_Energy: yesterdayEnergy,
                Today_Energy: todayEnergy,
                Yesterday_Actual_Time: Int64(yesterdayActualTime),
                Yesterday_Target: Int64(yesterdayTarget),
                Max_Available_Time: Int64(maxAvailableTime)
            )

            let aiRecommendation =
                Int(prediction.Recommended_Time)

            // 1. Never go below the minimum
            let minimumSafe =
                max(aiRecommendation, minimumTime)

            // 2. Never exceed user's maximum availability
            let maximumSafe =
                min(minimumSafe, maxAvailableTime)

            // 3. Recommendations must be multiples of 5
            let rounded =
                (maximumSafe / 5) * 5

            // 4. Final safety check
            return max(
                minimumTime,
                min(rounded, maxAvailableTime)
            )

        } catch {

            print("AI prediction failed: \(error)")

            // Safe fallback
            return minimumTime
        }
    }
}
