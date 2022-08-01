//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

final class ConverterMainModel {
    private lazy var currencyDataSource = CurrencyDataSource.shared
    private lazy var userDefaultsManager = UserDefaultsManager()
    
    weak var delegate: RatesTableViewDelegate?
    
    private lazy var rates: [Int: ExchangeRate] = [:]
    
    func createExchangeRates(monobankData: [MonoBankExchangeRate]) {
        var rateBuy = 0.0
        var rateSell = 0.0
        monobankData.forEach {  monoBankExchangeRate in
            if monoBankExchangeRate.currencyCodeB == 980 {
            let currencyCode = monoBankExchangeRate.currencyCodeA
            let ukrainianHryvna = monoBankExchangeRate.currencyCodeB
            let date = getDateFrom(unixTime: Double(monoBankExchangeRate.date))
            
            if monoBankExchangeRate.rateBuy == 0.0 || monoBankExchangeRate.rateSell == 0.0 {
                let rate = createRateFrom(rateCross: monoBankExchangeRate.rateCross)
                rateBuy = rate.rateBuy
                rateSell = rate.rateSell
            } else {
            rateBuy = monoBankExchangeRate.rateBuy
            rateSell = monoBankExchangeRate.rateSell
            }
            let exchangeRate = ExchangeRate(
                currencyCode: currencyCode,
                currency: currencyDataSource.currencies.filter { $0.code == currencyCode }[0].currency,
                ukrainianHryvna: ukrainianHryvna,
                date: date,
                rateBuy: rateBuy,
                rateSell: rateSell)
            rates.updateValue(exchangeRate, forKey: currencyCode)
            }
        }
        userDefaultsManager.save(data: rates)
        currencyDataSource.rates = rates
        print(rates)
    }
    
    private func getDateFrom(unixTime: Double) -> String {
        let data = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = dateFormatter.string(from: data)
        return stringDate
    }
    
    private func createRateFrom(rateCross: Double) -> (rateBuy: Double, rateSell: Double) {
        let rateBuy = rateCross - rateCross * 0.05
        let rateSell = rateCross + rateCross * 0.05
        return (rateBuy, rateSell)
    }
    
    func fillDataSource(with rates: [Int: ExchangeRate]) {
        currencyDataSource.rates = rates
        if let delegate = delegate {
            delegate.reloadTableView()
        }
    }
    
    func  getHistoricalData() {
        guard let selectedCurrencies = userDefaultsManager.getData(for: "currencies") as? [CurrencyOLD] else { return }
        print(selectedCurrencies)
        currencyDataSource.selectedCurrencies = selectedCurrencies
    }
    
    func checkUpdate(time: String) -> Bool {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMM yyyy HH:mm:ss"
        guard let updateDate = dateFormater.date(from: time) else { return false }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: updateDate)
        
        if let minutes = components.minute, let seconds = components.second {
            let timeInterval = -Int(updateDate.timeIntervalSinceNow)
            if timeInterval > 3600 - (minutes * 60 + seconds) {
                return true
            }
        }
        return false
    }
}
