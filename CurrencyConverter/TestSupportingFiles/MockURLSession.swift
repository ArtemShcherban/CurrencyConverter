//
//  MockURLSession.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 24.10.2022.
//

import Foundation

final class MockURLSession {
    private var data: Data?
    private var error: NSError?
    private var requestURL: URL?
    private lazy var response: HTTPURLResponse? = {
        guard let url = requestURL else { return nil }
        let tempResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        return tempResponse
    }()
    
    static func defaultWithBankData<Response>(bank: Endpoint<Response>) -> URLSession {
        ExchangeService.coreDataStack = MockCoreDataStack.create()
        let session = MockURLSession()
        session.createTestData(for: bank)
        return session.defaultSession
    }
    
    private func createTestData<Response>(for endpoint: Endpoint<Response>) {
        var dataURL: URL?
        
        if Response.self == [MonoBankExchangeRate].self {
            dataURL = Bundle.main.url(forResource: "monoBankTest", withExtension: "json")
            requestURL = endpoint.makeRequest()?.url
        }
        if Response.self == [PrivatBankExchangeRate].self {
            dataURL = Bundle.main.url(forResource: "privatBankTest", withExtension: "json")
            requestURL = endpoint.makeRequest()?.url
        }
        
        guard let dataURL = dataURL else { return }
        data = try? Data(contentsOf: dataURL)
    }
    
    private lazy var sessionConfig: URLSessionConfiguration = {
        let tempConfiguration = URLSessionConfiguration.ephemeral
        tempConfiguration.protocolClasses = [MockURLProtocol.self]
        return tempConfiguration
    }()
    
    private var defaultSession: URLSession {
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
}
