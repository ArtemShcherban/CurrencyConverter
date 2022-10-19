//
//  UIViewFixInExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 20.07.2022.
//

import UIKit

extension UIView {
    func embedded(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = view.frame
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
