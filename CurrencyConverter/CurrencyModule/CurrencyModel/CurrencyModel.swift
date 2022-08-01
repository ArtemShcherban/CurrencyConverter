//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

final class CurrencyModel {
    private let currencyDataSource = CurrencyDataSource.shared
    private lazy var currencies: [CurrencyOLD] = []
    private lazy var  currencyGroups: [(letter: String, currencies: [CurrencyOLD])] = []
    private lazy  var popularGroup: [CurrencyOLD] = []
    
    private lazy var userDefaultsManager = UserDefaultsManager()

    func createCurrencyGroups() {
        guard let jsonArray = getJsonArray() else { return }
        createCurrenciesArray(jsonArray)
        createPopularGroup()
        groupСurrencies()
        add(popularGroup)
        currencyDataSource.groupedСurrencies = currencyGroups
    }
    
    private func getJsonArray() -> [Any]? {
        guard let url = Bundle.main.url(forResource: "Currency", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] else {
            return nil
        }
        return json
    }
    
    private func createCurrenciesArray(_ jsonArray: [Any]) {
        for item in jsonArray {
            if let object = item as? [String: AnyObject],
            let country = object["Country"] as? String,
            let currencyName = object["CurrencyName"] as? String,
            let currency = object["Currency"] as? String,
            let code = object["Code"] as? Int {
                let currency = CurrencyOLD(
                    country: country,
                    currencyName: currencyName,
                    currency: currency,
                    code: code)
                currencies.append(currency)
            }
        }
        currencyDataSource.currencies = currencies
    }
    
    private func groupСurrencies() {
        let groups = Dictionary(grouping: currencies) { currency -> Character in
            guard let firstCharacter = currency.currency.first else { return Character(" ") }
            return firstCharacter
        }
            .map { (key: Character, value: [CurrencyOLD]) -> (letter: String, currencies: [CurrencyOLD]) in
                (letter: String(key), currencies: value)
            }
            .sorted { lhs, rhs in
                lhs.letter < rhs.letter
            }
        currencyGroups = groups
    }
    
    private func createPopularGroup() {
        let popular = PopularConstant.currencies
        
        for currency in popular {
            if let index = currencies.firstIndex(where: { $0.currency == currency.currency }) {
            popularGroup.append(currencies[index])
            currencies.remove(at: index)
            }
        }
    }
    
    private func add(_ popularGroup: [CurrencyOLD]) {
        let group = (letter: "Popular", currencies: popularGroup)
        currencyGroups.insert(group, at: 0)
    }
     
    func filterCurrency(text: String) {
        if !text.isEmpty {
            let whitespaceCharacterSet = CharacterSet.whitespaces
            let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()

            let filtered = currencyDataSource.groupedСurrencies.flatMap {
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
                currencyDataSource.filteredCurrency = []
            }
        } else {
            currencyDataSource.filteredCurrency = []
        }
    }
    
    func updateSelectedCurrencies(indexPath: IndexPath, isBeingFiltered: Bool) {
        let selectedCurrency: CurrencyOLD

        if isBeingFiltered {
            selectedCurrency = currencyDataSource.filteredCurrency[indexPath.row]
        } else {
            let group = currencyDataSource.groupedСurrencies[indexPath.section]
            selectedCurrency = group.currencies[indexPath.row]
        }
        currencyDataSource.selectedCurrencies.append(selectedCurrency)
        userDefaultsManager.save(data: currencyDataSource.selectedCurrencies)
    }
    
    func deleteFromCurrencyList(indexPath: IndexPath, isBeingFiltered: Bool ) {
        if isBeingFiltered {
            guard let groupIndex = (currencyDataSource.groupedСurrencies.firstIndex {
                $1.contains(currencyDataSource.filteredCurrency[indexPath.row])
            }) else { return }
            
            guard let currencyIndex = (currencyDataSource.groupedСurrencies[groupIndex].currencies.firstIndex {
                $0.code == currencyDataSource.filteredCurrency[indexPath.row].code
            }) else { return }
            
            currencyDataSource.groupedСurrencies[groupIndex].currencies.remove(at: currencyIndex)
            if currencyDataSource.groupedСurrencies[groupIndex].currencies.isEmpty {
                currencyDataSource.groupedСurrencies.remove(at: groupIndex)
            }
        } else {
            currencyDataSource.groupedСurrencies[indexPath.section].currencies.remove(at: indexPath.row)
            if currencyDataSource.groupedСurrencies[indexPath.section].currencies.isEmpty {
                currencyDataSource.groupedСurrencies.remove(at: indexPath.section)
            }
        }
    }
}
