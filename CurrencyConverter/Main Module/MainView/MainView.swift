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
    @IBOutlet weak var popUpWindow: ConverterWindowView!
    @IBOutlet weak var ratesWindowView: RatesWindowView!
    @IBOutlet weak var converterWindowView: ConverterWindowView!
    @IBOutlet weak var ellipsesView: EllipsesView!
    
//    weak var delegate: MainViewDelegate?
    
    lazy var isFlipping = false
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
//        addSwipeGesture()
    }
    
    func configure() {
        Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func startSwipeAnimation() {
        let centralView = !isFlipping ? ratesWindowView : converterWindowView
        centralView?.swipeAnimation()
    }
    
//    func flipView() {
//        isFlipping.toggle()
//        UIView.animate(withDuration: 1, animations: {
//            self.ratesWindowView.transform = CGAffineTransform(scaleX: 0.001, y: 1)}, completion: { _ in
//                self.ratesWindowView.isHidden = true
//            UIView.animate(withDuration: 1) {
//                self.converterWindowView.isHidden = false
//                self.converterWindowView.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }
//        })
//    }
    
    func flipView() {
        let visibleWindow = !isFlipping ? ratesWindowView : converterWindowView
        let hiddenWindow = !isFlipping ? converterWindowView : ratesWindowView
        isFlipping.toggle()
        UIView.animate(withDuration: 1, animations: {
            visibleWindow?.transform = CGAffineTransform(scaleX: 0.001, y: 1)}, completion: { _ in
                visibleWindow?.isHidden = true
            UIView.animate(withDuration: 1) {
                hiddenWindow?.isHidden = false
                hiddenWindow?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
}
