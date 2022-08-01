//
//  MonobankNetworkService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

protocol Networking {
}

class NetworkService: Networking {
    lazy var updateDate = String()
    
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10
        configuration.timeoutIntervalForRequest = 30.0
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    
    func getMonoBankExchangeRate(url: URL, comletion: @escaping (Result<[MonoBankExchangeRate], NetworkServiceError>) -> Void ) {
        urlSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let error = error {
                    comletion(.failure(self.checkErrorCode(error)))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
                response.statusCode else {
                comletion(.failure(NetworkServiceError.httpRequestFailed))
                return
            }
            guard let data = data else {
                comletion(.failure(NetworkServiceError.didNotRecieveData))
                return
            }
            
            guard let exchangeRate = try? JSONDecoder().decode([MonoBankExchangeRate].self, from: data) else {
                comletion(.failure(NetworkServiceError.cannotParseJSON))
                return
            }
            self.setUpdateDate(from: response)
            comletion(.success(exchangeRate))
        }
        .resume()
    }
    
    func getPrivatExchangeRate(url: URL, comletion: @escaping (Result<[PrivatBankExchangeRate], NetworkServiceError>) -> Void ) {
        urlSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let error = error {
                    comletion(.failure(self.checkErrorCode(error)))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
                response.statusCode else {
                comletion(.failure(NetworkServiceError.httpRequestFailed))
                return
            }
            guard let data = data else {
                comletion(.failure(NetworkServiceError.didNotRecieveData))
                return
            }
            guard let exchangeRate = try? JSONDecoder().decode([PrivatBankExchangeRate].self, from: data) else {
                comletion(.failure(NetworkServiceError.cannotParseJSON))
                return
            }
            comletion(.success(exchangeRate))
        }
        .resume()
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
    
    func setUpdateDate(from response: HTTPURLResponse) {
        guard let dateString = response.allHeaderFields["Date"] as? String else { return }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        
        if let date = dateFormater.date(from: dateString) {
            dateFormater.dateFormat = "d MMM yyyy HH:mm:ss"
            updateDate = dateFormater.string(from: date)
        }
    }
    
//    func setUpdateDate(from response: HTTPURLResponse) {
//        guard let dateString = response.allHeaderFields["Date"] as? String else { return }
//        let dateFormater = DateFormatter()
//        dateFormater.timeZone = TimeZone(abbreviation: "GMT")
//        dateFormater.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//
//        if let date = dateFormater.date(from: dateString) {
//            dateFormater.dateFormat = "d MMM yyyy HH:mm:ss"
//            dateFormater.timeZone = .current
//            updateDate = dateFormater.string(from: date)
//        }
//    }
}
