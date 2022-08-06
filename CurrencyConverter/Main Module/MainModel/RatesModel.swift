//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class RatesModel {
    private lazy var oldCurrencyDataSourceOLD = OLDCurrencyDataSourceOLD.shared

    private lazy var coreDataStack = CoreDataStack.shared
    
    weak var delegate: RatesTableViewDelegate?
    
    private lazy var rates: [Int: ExchangeRateOLD] = [:]
    
    func createExchangeRates(monobankData: [MonoBankExchangeRate], _ updateDate: Date) {
        guard let bulletin = try? getBulettin() else { return }
        bulletin.date = updateDate
        
        monobankData.forEach { monoBankExchangeRate in
            if monoBankExchangeRate.currencyCodeB == 980 {
                let code = monoBankExchangeRate.currencyCodeA
                let rate = handle(monoBankExchangeRate)
                let exchangeRate = ExchangeRate(context: coreDataStack.managedContext)
                exchangeRate.bulletin = bulletin
                exchangeRate.code = Int16(code)
                exchangeRate.buy = rate.buy
                exchangeRate.sell = rate.sell
            }
        }
        coreDataStack.saveContext()
    }
    
    private func getBulettin() throws -> Bulletin {
        let fetchRequest: NSFetchRequest<Bulletin> = Bulletin.fetchRequest()

            guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else {
                throw CoreDataError.unresolved
            }
            if result.isEmpty {
                return Bulletin(context: coreDataStack.managedContext)
            }
            guard let bulletin = result.first else { throw CoreDataError.unresolved }
            return bulletin
    }
    
    private func handle(_ rate: MonoBankExchangeRate) -> (buy: Double, sell: Double) {
        if rate.buy == 0.0 || rate.sell == 0.0 {
            let calculatedRate = calculateFrom(rate.cross)
            return (calculatedRate.buy, calculatedRate.sell)
        } else {
            return (rate.buy, rate.sell)
        }
    }
    
    //    func createExchangeRates(monobankData: [MonoBankExchangeRate]) {
    //        var rateBuy = 0.0
    //        var rateSell = 0.0
    //        monobankData.forEach {  monoBankExchangeRate in
    //            if monoBankExchangeRate.currencyCodeB == 980 {
    //            let currencyCode = monoBankExchangeRate.currencyCodeA
    //            let ukrainianHryvna = monoBankExchangeRate.currencyCodeB
    //            let date = getDateFrom(unixTime: Double(monoBankExchangeRate.date))
    //
    //            if monoBankExchangeRate.rateBuy == 0.0 || monoBankExchangeRate.rateSell == 0.0 {
    //                let rate = createRateFrom(rateCross: monoBankExchangeRate.rateCross)
    //                rateBuy = rate.rateBuy
    //                rateSell = rate.rateSell
    //            } else {
    //            rateBuy = monoBankExchangeRate.rateBuy
    //            rateSell = monoBankExchangeRate.rateSell
    //            }
    //            let exchangeRate = ExchangeRateOLD(
    //                currencyCode: currencyCode,
    //                currency: oldCurrencyDataSourceOLD.currencies.filter { $0.code == currencyCode }[0].currency,
    //                ukrainianHryvna: ukrainianHryvna,
    //                date: date,
    //                rateBuy: rateBuy,
    //                rateSell: rateSell)
    //            rates.updateValue(exchangeRate, forKey: currencyCode)
    //            }
    //        }
    //        userDefaultsManager.save(data: rates)
    //        oldCurrencyDataSourceOLD.rates = rates
    //        print(rates)
    //    }
    
//    private func getDateFrom(unixTime: Double) -> String {
//        let data = Date(timeIntervalSince1970: TimeInterval(unixTime))
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let stringDate = dateFormatter.string(from: data)
//        return stringDate
//    }
    
    private func calculateFrom(_ rateCross: Double) -> (buy: Double, sell: Double) {
        let rateBuy = rateCross - rateCross * 0.05
        let rateSell = rateCross + rateCross * 0.05
        return (rateBuy, rateSell)
    }
    
    func fillRatesBulletin() {
        let fetchrequest: NSFetchRequest<Bulletin> = Bulletin.fetchRequest()
        guard
            let result = try? coreDataStack.managedContext.fetch(fetchrequest),
            let bulletin = result.first,
            let rates = bulletin.rates?.array as? [ExchangeRate] else {
            return
        }
        oldCurrencyDataSourceOLD.ratesBulletin = rates
        
        if let delegate = delegate {
            delegate.reloadTableView()
        }
    }
    
    func fillDataSource(with rates: [Int: ExchangeRateOLD]) {
        oldCurrencyDataSourceOLD.rates = rates
        if let delegate = delegate {
            delegate.reloadTableView()
        }
    }
    
//    func  getHistoricalData() {
//        guard let selectedCurrencies = userDefaultsManager.getData(for: "currencies") as? [CurrencyOLD] else { return }
//        print(selectedCurrencies)
//        oldCurrencyDataSourceOLD.selectedCurrencies = selectedCurrencies
//    }
    
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
