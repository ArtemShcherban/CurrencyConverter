//
//  MonobankNetworkService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class NetworkService {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10.0
        configuration.timeoutIntervalForRequest = 30.0
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    
    func performQuery(with url: URL?, comletion: @escaping (Result<[ExchangeRate], NetworkServiceError>) -> Void ) {
        guard let url = url else {
            comletion(.failure(NetworkServiceError.cannotCreateURL))
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let error = error {
                    comletion((.failure(self.checkErrorCode(error))))
                }
                return
            }
            guard
                let response = response as? HTTPURLResponse, (200 ..< 299) ~=
                    response.statusCode else {
                comletion((.failure(NetworkServiceError.httpRequestFailed)))
                return
            }
            guard let data = data else {
                comletion((.failure(NetworkServiceError.didNotRecieveData)))
                return
            }
            if let exchangeRates = self.monoBankJSONHandle(data: data) {
                print("Complition")
                comletion(.success(exchangeRates))
            } else if let exchangeRates = self.privatBankJSONHandle(data: data) {
                print("Complition")
                comletion(.success(exchangeRates))
            } else {
                comletion(.failure((NetworkServiceError.cannotParseJSON)))
            }
        }
        .resume()
    }
    
    private func monoBankJSONHandle(data: Data) -> [ExchangeRate]? {
        var exchangeRates: [ExchangeRate] = []
        guard let monoExchangeRates = try? JSONDecoder().decode([MonoBankExchangeRate].self, from: data) else {
            return nil
        }
        monoExchangeRates.forEach {
            exchangeRates.append($0.convertToExchangeRate())
        }
        return exchangeRates
    }
    
    private func privatBankJSONHandle(data: Data) -> [ExchangeRate]? {
        var exchangeRates: [ExchangeRate] = []
        guard let privatData = try? JSONDecoder().decode(PrivatBankData.self, from: data) else {
            return nil
        }
        let privatExchangeRates = privatData.exchangeRates
        privatExchangeRates.forEach {
            exchangeRates.append($0.convertToExchangeRate())
        }
        return exchangeRates
    }
    
    func checkErrorCode(_ error: Error) -> NetworkServiceError {
        switch error._code {
        case -1001:
            return NetworkServiceError.badNetworkQuality
        case -1004:
            return NetworkServiceError.couldNotConnect
        case -1200:
            return NetworkServiceError.sslConectError
        default:
            return NetworkServiceError.errorCallingGET
        }
    }
}
