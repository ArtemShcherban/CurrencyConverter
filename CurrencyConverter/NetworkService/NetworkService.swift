//
//  MonobankNetworkService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import Combine

final class NetworkService {
    private var urlModel = URLModel()
    private var cancellable: AnyCancellable?
    
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10.0
        configuration.timeoutIntervalForRequest = 30.0
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    
    func loadData<Response>(
        for endpoint: Endpoint<Response>,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        //        urlSession.getDataWithDataTask(for: endpoint) { result in
        //            completion(result)
        //        }
        let publisher = urlSession.publisher(for: endpoint)
        createSubscription(for: publisher) { result in
            completion(result)
        }
    }
    
    func createSubscription<Response>(
        for publisher: AnyPublisher<Response?, Error>,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        cancellable = publisher
            .sink(receiveCompletion: { handler in
                switch handler {
                case .failure(let error):
                    completion(.failure(self.checkErrorCode(error)))
                case .finished:
                    break
                }
            }, receiveValue: { response in
                guard let result = response else { return }
                completion(.success(result))
            })
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
            return NetworkServiceError.connectivityError
        }
    }
}

// extension URLSession {
//    func getDataWithDataTask<Response>(
//        for endpoint: Endpoint<Response>,
//        decoder: JSONDecoder = .init(),
//        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
//    ) {
//        guard let request = endpoint.makeRequest() else {
//            print("CANNOT CREATE REQUEST")
//            completion(.failure(NetworkServiceError.cannotCreateRequest))
//            return
//        }
//
//        dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                completion(.failure(NetworkServiceError.connectivityError))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
//                completion(.failure(NetworkServiceError.httpRequestFailed))
//                return
//            }
//
//            guard let data = data, !data.isEmpty else {
//                completion(.failure(NetworkServiceError.didNotRecieveData))
//                return
//            }
//
//            guard let tempResult = try? decoder.decode(NetworkResponse<Response>.self, from: data) else {
//                completion(.failure(NetworkServiceError.cannotParseJSON))
//                return
//            }
//            guard let webResult = tempResult.result else {
//                completion(.failure(NetworkServiceError.sslConectError))
//                return
//            }
//            completion(.success(webResult))
//        }
//        .resume()
//    }
// }

private extension URLSession {
    func publisher<Response>(
        for endpoint: Endpoint<Response>,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Response?, Error> {
        guard let request = endpoint.makeRequest() else {
            return Fail(error: NetworkServiceError.cannotCreateRequest).eraseToAnyPublisher()
        }
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<Response>.self, decoder: decoder)
            .map(\.result)
            .eraseToAnyPublisher()
    }
}
