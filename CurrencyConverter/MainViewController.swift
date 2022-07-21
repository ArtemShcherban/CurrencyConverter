//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var popUpWindow: PopUpWindowView!
    
    lazy var networkService = NetworkService()
    lazy var urlModel = URLModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMonoBankExchangeRate()
        getPrivatExchangeRate()
    }
    
    private func getMonoBankExchangeRate() {
        guard let url = urlModel.createMonoBankURL() else { return }
        networkService.getMonoBankExchangeRate(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                print(currencyRates)
            }
        }
    }
    
    private func getPrivatExchangeRate() {
        guard let url = urlModel.createPrivatBankURL() else { return }
        networkService.getPrivatExchangeRate(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let currencyRates):
                print(currencyRates)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(self.view.frame)
        print("TextField frame ---- \(popUpWindow.usdTextField.frame)")
        print("TextField bounds ---- \(popUpWindow.usdTextField.bounds)")
        print()
        print()
        print("SellButton frame ---- \(popUpWindow.sellButton.frame)")
        print("SellButton bounds ---- \(popUpWindow.sellButton.bounds)")
        print()
        print()
    }
}
