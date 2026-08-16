//
//  LocalStorage.swift
//  Win2
//
//  Created by Dima Rafat on 02/03/1448 AH.
//

import Foundation

final class LocalStorage {

    static let shared = LocalStorage()

    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Yesterday

    var yesterdayActualTime: Int {
        get {
            defaults.integer(forKey: "yesterdayActualTime")
        }
        set {
            defaults.set(newValue, forKey: "yesterdayActualTime")
        }
    }

    var yesterdayTarget: Int {
        get {
            defaults.integer(forKey: "yesterdayTarget")
        }
        set {
            defaults.set(newValue, forKey: "yesterdayTarget")
        }
    }

    var yesterdayEnergy: String {
        get {
            defaults.string(forKey: "yesterdayEnergy") ?? "Medium"
        }
        set {
            defaults.set(newValue, forKey: "yesterdayEnergy")
        }
    }

    // MARK: - Today

    var todayEnergy: String {
        get {
            defaults.string(forKey: "todayEnergy") ?? "Medium"
        }
        set {
            defaults.set(newValue, forKey: "todayEnergy")
        }
    }

    // MARK: - User Availability

    var maxAvailableTime: Int {
        get {
            defaults.integer(forKey: "maxAvailableTime")
        }
        set {
            defaults.set(newValue, forKey: "maxAvailableTime")
        }
    }

    // MARK: - Target

    var currentTarget: Int {
        get {
            defaults.integer(forKey: "currentTarget")
        }
        set {
            defaults.set(newValue, forKey: "currentTarget")
        }
    }
}
