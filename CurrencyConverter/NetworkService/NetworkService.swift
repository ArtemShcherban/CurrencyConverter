//
//  MonobankNetworkService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit
import Combine

final class NetworkService {
    static var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10.0
        configuration.timeoutIntervalForRequest = 30.0
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }()
    private var urlModel = URLModel()
    private var cancellable: AnyCancellable?
    
    func loadData<Response>(
        for endpoint: Endpoint<Response>,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        let publisher = NetworkService.urlSession.publisher(for: endpoint)
        createSubscription(for: publisher) { result in
            completion(result)
        }
    }
    
    private func createSubscription<Response>(
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
    
    private func checkErrorCode(_ error: Error) -> NetworkServiceError {
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
