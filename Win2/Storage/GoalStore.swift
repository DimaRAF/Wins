//
//  GoalStore.swift
//  Win2
//
//  Created by Dima Rafat on 04/03/1448 AH.
//

import Foundation

struct SavedGoal: Codable {
    let goal: String
    let whyGoalMatters: String
    let minimumMinutes: Int
    let maximumMinutes: Int
    let targetDate: Date
    let goalStartDate: Date
}

final class GoalStore {

    static let shared = GoalStore()

    private let key = "saved_current_goal"

    private init() {}

    // MARK: - Save

    func saveGoal(
        goal: String,
        whyGoalMatters: String,
        minimumMinutes: Int,
        maximumMinutes: Int,
        targetDate: Date,
        goalStartDate: Date
    ) {

        let savedGoal = SavedGoal(
            goal: goal,
            whyGoalMatters: whyGoalMatters,
            minimumMinutes: minimumMinutes,
            maximumMinutes: maximumMinutes,
            targetDate: targetDate,
            goalStartDate: goalStartDate
        )

        do {

            let encoded =
                try JSONEncoder().encode(
                    savedGoal
                )

            UserDefaults.standard.set(
                encoded,
                forKey: key
            )

        } catch {

            print(
                "Failed to save goal: \(error)"
            )
        }
    }

    // MARK: - Load

    func loadGoal() -> SavedGoal? {

        guard let savedData =
            UserDefaults.standard.data(
                forKey: key
            )
        else {
            return nil
        }

        do {

            return try JSONDecoder().decode(
                SavedGoal.self,
                from: savedData
            )

        } catch {

            print(
                "Failed to load goal: \(error)"
            )

            return nil
        }
    }

    // MARK: - Has Goal

    var hasSavedGoal: Bool {
        loadGoal() != nil
    }

    // MARK: - Delete

    func deleteGoal() {

        UserDefaults.standard.removeObject(
            forKey: key
        )
    }
}
