//
//  MonobankNetworkService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

// protocol Networking {
// }

class NetworkService {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10
        configuration.timeoutIntervalForRequest = 30.0
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    
    func getMonoBankExchangeRate(url: URL?, comletion: @escaping (Result<[ExchangeRate], NetworkServiceError>) -> Void ) {
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
    
//    func getMonoBankExchangeRate(url: URL?, comletion: @escaping (Result<[ExchangeRate], NetworkServiceError>, Date) -> Void ) {
//        guard let url = url else {
//            comletion(.failure(NetworkServiceError.cannotCreateURL), Date())
//            return
//        }
//        urlSession.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                if let error = error {
//                    comletion((.failure(self.checkErrorCode(error))), Date())
//                }
//                return
//            }
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
//                    response.statusCode else {
//                comletion((.failure(NetworkServiceError.httpRequestFailed)), Date())
//                return
//            }
//            guard let data = data else {
//                comletion((.failure(NetworkServiceError.didNotRecieveData)), Date())
//                return
//            }
//
//            if let exchangeRates = self.monoBankJSONHandle(data: data) {
//                if let updateDate = self.updateDate(from: response) {
//                    print("Complition")
//                    comletion(.success(exchangeRates), updateDate)
//                } else {
//                    comletion(.failure((NetworkServiceError.cannotParseJSON)), Date())
//                }
//            } else {
//                if let exchangeRates = self.privatBankJSONHandle(data: data) {
//                    if let updateDate = self.updateDate(from: response) {
//                        print("Complition")
//                        comletion(.success(exchangeRates), updateDate)
//                    } else {
//                        comletion(.failure((NetworkServiceError.cannotParseJSON)), Date())
//                    }
//                }
//            }
//        }
//        .resume()
//    }
    
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
        guard let privatData = try? JSONDecoder().decode(NationalBankBulletin.self, from: data) else {
            return nil
        }
        let privatExchangeRates = privatData.exchangeRate
        privatExchangeRates.forEach {
            exchangeRates.append($0.convertToExchangeRate())
        }
        return exchangeRates
    }
    
    //    func getMonoBankExchangeRate(url: URL, comletion: @escaping (Result<[MonoBankExchangeRate], NetworkServiceError>, Date) -> Void ) {
    //        urlSession.dataTask(with: url) { data, response, error in
    //            guard error == nil else {
    //                if let error = error {
    //                    comletion((.failure(self.checkErrorCode(error))), Date())
    //                }
    //                return
    //            }
    //            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
    //                response.statusCode else {
    //                comletion((.failure(NetworkServiceError.httpRequestFailed)), Date())
    //                return
    //            }
    //            guard let data = data else {
    //                comletion((.failure(NetworkServiceError.didNotRecieveData)), Date())
    //                return
    //            }
    //
    //            guard let exchangeRate = try? JSONDecoder().decode([MonoBankExchangeRate].self, from: data) else {
    //                comletion(.failure((NetworkServiceError.cannotParseJSON)), Date())
    //                return
    //            }
    //
    //            guard let updateDate = self.updateDate(from: response) else { return }
    //            comletion(.success(exchangeRate), updateDate)
    //        }
    //        .resume()
    //    }
    
//    func getNationalBankHistoricalRates(url: URL) {
//        urlSession.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                if let error = error {
//                    print(error)
//                }
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                return
//            }
//
//            guard let data = data else { return }
//
//            guard let bulletin = try? JSONDecoder().decode(NationalBankBulletin.self, from: data) else { return }
//            print(bulletin)
//        }
//        .resume()
//    }
    
//    func getPrivatExchangeRate(url: URL, comletion: @escaping (Result<[PrivatBankExchangeRate], NetworkServiceError>) -> Void ) {
//        urlSession.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                if let error = error {
//                    comletion(.failure(self.checkErrorCode(error)))
//                }
//                return
//            }
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~=
//                    response.statusCode else {
//                comletion(.failure(NetworkServiceError.httpRequestFailed))
//                return
//            }
//            guard let data = data else {
//                comletion(.failure(NetworkServiceError.didNotRecieveData))
//                return
//            }
//            guard let exchangeRate = try? JSONDecoder().decode([PrivatBankExchangeRate].self, from: data) else {
//                comletion(.failure(NetworkServiceError.cannotParseJSON))
//                return
//            }
//            comletion(.success(exchangeRate))
//        }
//        .resume()
//    }
    
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
    
//   private func updateDate(from response: HTTPURLResponse) -> Date? {
//        guard let dateString = response.allHeaderFields["Date"] as? String else { return nil }
//        let dateFormater = DateFormatter()
//        dateFormater.locale = Locale(identifier: "en_US_POSIX")
//        dateFormater.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//        let date = dateFormater.date(from: dateString)
//        return date
//    }
}
