//
//  MainViewAnimationExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 23.08.2022.
//

import UIKit

extension MainView {
    enum AnimationDirection: Int {
        case forward = 1
        case back = -1
    }
    
    func flipView(completion: @escaping(() -> Void) ) {  // change name 🥸
        let visibleWindow = !isFlipping ? ratesWindowView : converterWindowView
        let hiddenWindow = !isFlipping ? converterWindowView : ratesWindowView
        isFlipping.toggle()
        UIView.animate(withDuration: 0.75, animations: {
            visibleWindow.transform = CGAffineTransform(scaleX: 0.001, y: 1)}, completion: { _ in
                self.containerView.addSubview(hiddenWindow)
                hiddenWindow.setConstraints()
                visibleWindow.isHidden = true
                visibleWindow.removeFromSuperview()
                completion()
                UIView.animate(withDuration: 0.75) {
                    hiddenWindow.isHidden = false
                    hiddenWindow.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            })
    }
    
    func titleTransition(label: UILabel, title: String, direction: AnimationDirection) {
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
            withDuration: 0.75,
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
