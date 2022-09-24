//
//  AddButton.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.09.2022.
//

import UIKit

final class AddButton: UIButton {
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        sharedConstraints.append(contentsOf: [
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthAnchor.constraint(equalToConstant: 120),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        if UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.width == 667 {
            compactConstraints.append(self.centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -30))
        } else {
            compactConstraints.append(self.centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -81))
        }
        regularConstraints.append(contentsOf: [
            self.centerYAnchor.constraint(equalTo: superview.bottomAnchor, constant: -30)
        ])
    }
    
    private func layoutTrait(traitCollection: UITraitCollection) {
        if !sharedConstraints[0].isActive {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if (traitCollection.horizontalSizeClass == .compact || traitCollection.horizontalSizeClass == .regular) &&
            traitCollection.verticalSizeClass == .regular {
            if !regularConstraints.isEmpty && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if !compactConstraints.isEmpty && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
}
