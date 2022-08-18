//
//  Window.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import UIKit

protocol PopUpWindowDelegate: AnyObject {
    func swipe()
    func addButtonPressed()
    func changeCurrency(sender: UIButton)
    func rotateButtonPressed()
}

class PopUpWindowView: UIView {
    weak var popUpWindowDelegate: PopUpWindowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSwipeGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        addSwipeGesture()
    }
    
    private func configure() {
        createShadow()
    }
    
    func createShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
    }
    
    func addSwipeGesture() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .down
        swipe.addTarget(self, action: #selector(swipeDelegateAction))
        swipe.location(in: self)
        self.addGestureRecognizer(swipe)
    }
    
    func swipeAnimation() {
        transform = CGAffineTransform(translationX: 0.0, y: 30)
        UIView.animate(
            withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.0,
            options: .curveEaseIn) {
            self.transform = .identity
        }
    }
    
    func setConstraints() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    @objc func swipeDelegateAction() {
        popUpWindowDelegate?.swipe()
    }
}
