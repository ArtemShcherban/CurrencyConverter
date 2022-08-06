//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var popUpWindow: ConverterWindowView!
    @IBOutlet weak var ratesWindowView: RatesWindowView!
    @IBOutlet weak var ellipsesView: EllipsesView!
    
    weak var ratesDelegate: UITableViewDelegate?

    lazy var lastUpdateDate = String() {
        willSet {
            ellipsesView.updateDateLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("ConverterMainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
}
