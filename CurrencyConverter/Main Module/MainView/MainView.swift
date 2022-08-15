//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    lazy var ratesWindowView = RatesWindowView()
    lazy var converterWindowView = ConverterWindowView()
    lazy var isFlipping = false  // change the name 🥸
    lazy var lastUpdateDate = String() {
        willSet {
            updateDateLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        containerView.addSubview(ratesWindowView)
        ratesWindowView.setConstraints()
        print(containerView.frame)
    }
    
    func configure() {
        Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func startSwipeAnimation() {
        let centralView = !isFlipping ? ratesWindowView : converterWindowView
        centralView.swipeAnimation()
    }
    
    func flipView(completion: @escaping(() -> Void) ) {
        let visibleWindow = !isFlipping ? ratesWindowView : converterWindowView
        let hiddenWindow = !isFlipping ? converterWindowView : ratesWindowView
        isFlipping.toggle()
        UIView.animate(withDuration: 1, animations: {
            visibleWindow.transform = CGAffineTransform(scaleX: 0.001, y: 1)}, completion: { _ in
                self.containerView.addSubview(hiddenWindow)
                hiddenWindow.setConstraints()
                visibleWindow.isHidden = true
                visibleWindow.removeFromSuperview()
                completion()
            UIView.animate(withDuration: 1) {
                hiddenWindow.isHidden = false
                hiddenWindow.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
    
    func reloadTableViewData() {
        var currentTableView: UITableView
        switch isFlipping {
        case true:
            currentTableView = converterWindowView.converterTableView
        default:
            currentTableView = ratesWindowView.ratesTableView
        }
        currentTableView.reloadData()
    }
    
    func setAddButtonStatus(_ isMaxNumberOfRows: Bool) {
        switch isFlipping {
        case true:
            converterWindowView.addCurrencyButton.isEnabled = !isMaxNumberOfRows
        default:
            ratesWindowView.addButton.isEnabled = !isMaxNumberOfRows
        }
    }
}
