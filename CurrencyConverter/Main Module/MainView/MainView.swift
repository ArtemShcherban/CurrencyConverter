//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func swipe()
}

class MainView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var popUpWindow: ConverterWindowView!
    @IBOutlet weak var ratesWindowView: RatesWindowView!
    @IBOutlet weak var ellipsesView: EllipsesView!
    
    weak var delegate: MainViewDelegate?
    
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
        addSwipeGesture()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("ConverterMainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func addSwipeGesture() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .down
        swipe.addTarget(self, action: #selector(swipeDelegateAction))
        swipe.location(in: ratesWindowView)
        ratesWindowView.addGestureRecognizer(swipe)
    }
    
    @objc func swipeDelegateAction() {
        delegate?.swipe()
    }
}
