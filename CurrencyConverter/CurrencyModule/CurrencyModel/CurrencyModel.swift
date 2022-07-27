//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

final class CurrencyModel {
    private let currencyDataSource = CurrencyDataSource.shared
    private lazy var currencies: [Currency] = []
    private lazy var  currencyGroups: [(letter: String, currencies: [Currency])] = []
    private lazy  var popularGroup: [Currency] = []

    func createCurrencyGroups() {
        guard let jsonArray = getJsonArray() else { return }
        createCurrencyDictionary(jsonArray)
        createPopularGroup()
        groupСurrencies()
        add(popularGroup)
        currencyDataSource.currencyGroups = currencyGroups
    }
    
    private func getJsonArray() -> [Any]? {
        guard let url = Bundle.main.url(forResource: "Currency", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] else {
            return nil
        }
        return json
    }
    
    private func createCurrencyDictionary(_ jsonArray: [Any]) {
        for item in jsonArray {
            if let object = item as? [String: AnyObject],
            let country = object["Country"] as? String,
            let currencyName = object["CurrencyName"] as? String,
            let currency = object["Currency"] as? String,
            let code = object["Code"] as? Int {
                let currency = Currency(
                    country: country,
                    currencyName: currencyName,
                    currency: currency,
                    code: code)
                currencies.append(currency)
            }
        }
    }
    
    private func groupСurrencies() {
        let groups = Dictionary(grouping: currencies) { currency -> Character in
            guard let firstCharacter = currency.currency.first else { return Character(" ") }
            return firstCharacter
        }
            .map { (key: Character, value: [Currency]) -> (letter: String, currencies: [Currency]) in
                (letter: String(key), currencies: value)
            }
            .sorted { lhs, rhs in
                lhs.letter < rhs.letter
            }
        currencyGroups = groups
    }
    
    private func createPopularGroup() {
        let popular = ["USD", "EUR", "UAH"]
        
        for currency in popular {
            if let index = currencies.firstIndex(where: { $0.currency == currency }) {
            popularGroup.append(currencies[index])
            currencies.remove(at: index)
            }
        }
    }
    
    private func add(_ popularGroup: [Currency]) {
        let group = (letter: "Popular", currencies: popularGroup)
        currencyGroups.insert(group, at: 0)
    }
     
    func filterCurrency(text: String) {
        if !text.isEmpty {
            let text = text.lowercased()
            //        currencyDataSource.filteredCurrency = []
            let filtered = currencyDataSource.currencyGroups.flatMap {
                $1
            }
                .filter {
                    $0.currency.lowercased().contains(text) ||
                    $0.currencyName.lowercased().contains(text)
                }
            if !filtered.isEmpty {
                currencyDataSource.filteredCurrency.removeAll()
                currencyDataSource.filteredCurrency = filtered
            } else {
                currencyDataSource.filteredCurrency = [Currency(country: "", currencyName: "", currency: "", code: 0)]
            }
        } else {
            currencyDataSource.filteredCurrency = []
            print("String is empty")
        }
    }
}
