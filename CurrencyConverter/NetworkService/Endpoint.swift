//
//  Agent.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 16.09.2022.
//

import Foundation

struct Endpoint<Response: Decodable> {
    private let urlModel = URLModel()
    var date: Date?
    
    func makeRequest() -> URLRequest? {
        guard let url = createURL(with: date) else {
            print(NetworkServiceError.cannotCreateURL)
            return nil
        }
        let request = URLRequest(url: url)
        return request
    }
    
    private func createURL(with date: Date?) -> URL? {
        if Response.self == [MonoBankExchangeRate].self {
            return urlModel.createMonoURL()
        } else if Response.self == [PrivatBankExchangeRate].self {
            guard let date = date else { return nil }
            return urlModel.createPrivatURL(with: date.forURL)
        } else {
            print(NetworkServiceError.cannotRecognizeType.rawValue)
            return nil
        }
    }
}

extension Endpoint where Response == [MonoBankExchangeRate] {
    static var monoBank: Self {
        return Endpoint()
    }
}

extension Endpoint where Response == [PrivatBankExchangeRate] {
    static func privatBank(with date: Date) -> Self {
        return Endpoint(date: date)
    }
}
