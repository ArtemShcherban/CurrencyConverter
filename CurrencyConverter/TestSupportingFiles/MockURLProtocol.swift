//
//  MockURLProtocol.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 24.10.2022.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    // swiftlint:disable large_tuple
    static var mockURLs: [URL?: (data: Data?, response: HTTPURLResponse?, error: Error?)] = [:]
    // swiftlint:enable large_tuple
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let (data, response, error) = MockURLProtocol.mockURLs[url] {
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
