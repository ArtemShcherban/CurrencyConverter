//
//  MockURLSession.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 24.10.2022.
//

import Foundation
@testable import CurrencyConverter

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
    
    func  createTestData<Response>(for endpoint: Endpoint<Response>) {
        var dataURL: URL?
        if Response.self == [MonoBankExchangeRate].self {
            dataURL = Bundle.main.url(forResource: "monoBankTest", withExtension: "txt")
            requestURL = endpoint.makeRequest()?.url
        }
        if Response.self == [PrivatBankExchangeRate].self {
            dataURL = Bundle.main.url(forResource: "privatBankTest", withExtension: "txt")
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
    
    var byDefault: URLSession {
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
}
