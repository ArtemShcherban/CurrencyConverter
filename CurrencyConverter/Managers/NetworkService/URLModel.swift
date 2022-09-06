//
//  URLModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

final class URLModel {
    func createMonoURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLConstants.MonoBank.scheme
        components.host = URLConstants.MonoBank.baseURL
        components.path = URLConstants.MonoBank.path
        let url = components.url
        return url
    }
    
    func createPrivatURL(with date: String) -> URL? {
        var components = URLComponents()
        components.scheme = URLConstants.PrivatBank.scheme
        components.host = URLConstants.PrivatBank.baseURL
        components.path = URLConstants.PrivatBank.path
        let queryItemQuery = URLQueryItem(name: URLConstants.PrivatBank.query, value: nil)
        let queryItemDate = URLQueryItem(name: URLConstants.PrivatBank.date, value: date)
        components.queryItems = [queryItemQuery, queryItemDate]
        let url = components.url
        return url
    }
    
//    func createPrivatBankURL() -> URL? {
//        var components = URLComponents()
//        components.scheme = URLConstants.PrivatBank.scheme
//        components.host = URLConstants.PrivatBank.baseURL
//        components.path = URLConstants.PrivatBank.path
//        let queryItemQuery = URLQueryItem(
//            name: URLConstants.PrivatBank.query,
//            value: nil)
//        let queryItemExchange = URLQueryItem(
//            name: URLConstants.PrivatBank.exchange,
//            value: nil)
//        let queryItemCoursid = URLQueryItem(
//            name: URLConstants.PrivatBank.coursid,
//            value: URLConstants.PrivatBank.five)
//        components.queryItems = [queryItemQuery, queryItemExchange, queryItemCoursid]
//        let url = components.url
//        return url
//    }
}
