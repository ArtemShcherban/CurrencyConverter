//
//  DateConstants.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 30.10.2022.
//

import Foundation
@testable import CurrencyConverter

enum DateConstants {
    static let today = Date().startOfDay
    static let yesterday = (Date() - 86400).startOfDay
    static let twoDaysAgo = (Date() - 172800).startOfDay
    static let oneYearAgo = Date().oneYearAgo
    static let oneYearAgoString = oneYearAgo.dMMMyyyyHHmm
}
