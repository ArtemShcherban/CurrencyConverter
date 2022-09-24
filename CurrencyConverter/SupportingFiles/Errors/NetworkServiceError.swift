//
//  NetworkErrors.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

enum NetworkServiceError: String, Error {
    case cannotCreateURL = "Error: Cannot create URL"
    case cannotCreateRequest = "Error: Cannot create URLRequest"
    case errorCallingGET = "Network access error, please check your wi-fi connection or network coverage and try again"
    case didNotRecieveData = "Error: did not receive data"
    case httpRequestFailed = "Request failed, please try again."
    case badNetworkQuality =
        "Unfortunately, the time for the request has expired. There is a problem with the quality of the network."
    case couldNotConnect = "Unfortunately, we could not connect to the server."
    case sslConectError = "An SSL error has occurred and a secure connection to the server cannot be made."
    case cannotParseJSON = "Error: cannot parse JSON"
    case cannotRecognizeType = "Error: Cannot recognize the response type"
}
