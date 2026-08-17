//
//  DailyDataStore.swift
//  Win2
//
//  Created by Dima Rafat on 04/03/1448 AH.
//

import Foundation

struct DailyData: Codable {
    let actualMinutes: Int
    let targetMinutes: Int
    let energy: String?
}

final class DailyDataStore {

    static let shared = DailyDataStore()

    private let key = "daily_focus_data"

    private init() {}

    // MARK: - Stored Data

    private var data: [String: DailyData] {

        guard let savedData =
                UserDefaults.standard.data(forKey: key)
        else {
            return [:]
        }

        do {

            return try JSONDecoder().decode(
                [String: DailyData].self,
                from: savedData
            )

        } catch {

            return [:]
        }
    }

    // MARK: - Save

    private func save(
        _ data: [String: DailyData]
    ) {

        do {

            let encoded =
                try JSONEncoder().encode(data)

            UserDefaults.standard.set(
                encoded,
                forKey: key
            )

        } catch {

            print(
                "Failed to save daily data: \(error)"
            )
        }
    }

    // MARK: - Date Key

    private func key(
        for date: Date
    ) -> String {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(
            from: date
        )
    }

    // MARK: - Save Day

    func saveDay(
        date: Date,
        actualMinutes: Int,
        targetMinutes: Int,
        energy: String?
    ) {

        var currentData = data

        currentData[key(for: date)] =
            DailyData(
                actualMinutes: actualMinutes,
                targetMinutes: targetMinutes,
                energy: energy
            )

        save(currentData)

        // Tell the Journey screen that
        // daily data has changed.
        NotificationCenter.default.post(
            name: .dailyDataDidChange,
            object: nil
        )
    }

    // MARK: - Get Day

    func getDay(
        date: Date
    ) -> DailyData? {

        return data[key(for: date)]
    }
    func deleteAllData() {
        UserDefaults.standard.removeObject(
            forKey: key
        )

        NotificationCenter.default.post(
            name: .dailyDataDidChange,
            object: nil
        )
    }
}

// MARK: - Notifications

extension Notification.Name {

    static let dailyDataDidChange =
        Notification.Name(
            "dailyDataDidChange"
        )
    
    // MARK: - Delete All Daily Data

 
}
