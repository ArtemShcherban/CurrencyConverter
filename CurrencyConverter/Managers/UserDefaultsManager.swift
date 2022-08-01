//
//  UserDefaultsManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.07.2022.
//

import Foundation

class UserDefaultsManager: UserDefaults {
    func save<T: Codable>(data: T) {
        let encoder = JSONEncoder()
        do {
            if let rate = data as? ExchangeRate {
                let recordingData = try encoder.encode(rate)
                set(recordingData, forKey: rate.currency)
            }
            if let rates = data as? [Int: ExchangeRate] {
                let recordingData = try encoder.encode(rates)
                set(recordingData, forKey: "rates")
            }
            if let currencies = data as? [Currency] {
                let recordingData = try encoder.encode(currencies)
                set(recordingData, forKey: "currencies")
            }
            if let date = data as? String {
                let recordingData = try encoder.encode(date)
                set(recordingData, forKey: "Date")
            }
        } catch {
            print("Error: cannot create data. \(error)")
        }
    }
    
    func getData(for key: String) -> Codable? {
        guard let data = object(forKey: key) as? Data else { return nil }
        if let obtainedData = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            return obtainedData
        }
        if let obobtainedData = try? JSONDecoder().decode([Int: ExchangeRate].self, from: data) {
            return obobtainedData
        }
        if let obtainedData = try? JSONDecoder().decode([Currency].self, from: data) {
            return obtainedData
        }
        if let obtainedData = try? JSONDecoder().decode(String.self, from: data) {
            return obtainedData
        }
        return nil
    }
}
