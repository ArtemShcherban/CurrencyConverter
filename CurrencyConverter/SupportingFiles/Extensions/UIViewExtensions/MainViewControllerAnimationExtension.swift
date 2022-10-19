//
//  MainViewControllerAnimationExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 23.08.2022.
//

import UIKit

extension MainViewController {
    enum AnimationDirection: Int {
        case forward = 1
        case backward = -1
    }
    
    func startSwipeAnimation(comlition: @escaping () -> Void) {
        let centralView = isRatesView ? exchangeRatesView : converterView
        centralView.swipeAnimation(labelOne: lastUpdatedLabel, labelTwo: updateDateLabel) {
            comlition()
        }
    }
    
    func titleAnimation(for switchViewButton: UIButton) {
        switchViewButton.fadeTransition(1.0)
        switchViewButton.titleLabel?.text = ""
        let title = isRatesView ? TitleConstants.exchangeRates : TitleConstants.currencyConverter
        switchViewButton.setTitle(title, for: .normal)
    }
    
    func startAnimationForView(and titleLabel: UILabel, completion: @escaping(() -> Void)) {
        animateSwitchView {
            completion()
        }
        titleTransition(
            titleLabel,
            title: isRatesView ? TitleConstants.exchangeRates : TitleConstants.currencyConverter,
            direction: isRatesView ? AnimationDirection.backward : AnimationDirection.forward)
    }
    
    func animateUpdate(message: String) {
        lastUpdatedLabel.fadeTransition(0.5)
        updateDateLabel.fadeTransition(0.5)
        lastUpdatedLabel.text = message
        updateDateLabel.text = String()
        let delayInSeconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
            self?.setupLastUpdateLabels()
        }
    }
    
    func setupLastUpdateLabels() {
        self.lastUpdatedLabel.fadeTransition(0.5)
        self.updateDateLabel.fadeTransition(0.5)
        self.lastUpdatedLabel.text = "Last Updated"
        self.updateDateLabel.text = lastUpdateDate
    }
    
    func animateSwitchView(completion: @escaping () -> Void) {
        let visibleWindow = isRatesView ? exchangeRatesView : converterView
        let hiddenWindow = isRatesView ? converterView : exchangeRatesView
        isRatesView.toggle()
        UIView.animate(withDuration: 0.2, animations: {
            visibleWindow.transform = CGAffineTransform(scaleX: 0.001, y: 1)}, completion: { _ in
                self.containerView.addSubview(hiddenWindow)
                hiddenWindow.setConstraints()
                visibleWindow.isHidden = true
                visibleWindow.removeFromSuperview()
                completion()
                UIView.animate(withDuration: 0.2) {
                    hiddenWindow.isHidden = false
                    hiddenWindow.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            })
    }
    
    func titleTransition(_ label: UILabel, title: String, direction: AnimationDirection) {
        let tempLabel = UILabel(frame: label.frame)
        tempLabel.text = title
        tempLabel.textAlignment = label.textAlignment
        tempLabel.font = label.font
        tempLabel.textColor = label.textColor
        tempLabel.backgroundColor = label.backgroundColor
        
        let tempLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
        
        tempLabel.transform = CGAffineTransform(translationX: 0.0, y: tempLabelOffset).scaledBy(x: 1.0, y: 0.1)
        label.superview?.addSubview(tempLabel)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                tempLabel.transform = .identity
                label.transform = CGAffineTransform(translationX: 0.0, y: -tempLabelOffset).scaledBy(x: 1.0, y: 0.1)
            },
            completion: { _ in
                label.text = tempLabel.text
                label.transform = .identity
                
                tempLabel.removeFromSuperview()
            })
    }
}
