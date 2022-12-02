//
//  DateConstants.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 30.10.2022.
//

import Foundation
@testable import CurrencyConverter

enum DateConstants {
    static let oneDay: Double = 86400 // - 86400 seconds / 24 hours
    static let today = Date().startOfDay
    static let yesterday = (Date() - oneDay).startOfDay
    static let twoDaysAgo = (Date() - oneDay * 2).startOfDay
    static let oneYearAgo = Date().oneYearAgo
    static let oneYearAgoString = oneYearAgo.dMMMyyyyHHmm
    
    // swiftlint:disable identifier_name
    static let date21_10_22 = Date(timeIntervalSince1970: 1666303200)
    static let date19_10_22 = Date(timeIntervalSince1970: 1666130400)
    static let date18_10_22 = Date(timeIntervalSince1970: 1666044000)
    static let date17_10_22 = Date(timeIntervalSince1970: 1665957600)
    static let date15_10_22 = Date(timeIntervalSince1970: 1665784800)
    // swiftlint:enable identifier_name
}
