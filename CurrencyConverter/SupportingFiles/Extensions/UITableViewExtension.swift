//
//  UITableViewExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.09.2022.
//

import UIKit

extension UITableView {
    func registerUINibWith(nib name: UITableViewCell.Type) {
        let nibName = String(describing: name)
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }

    func registerCellClassWith(name: UITableViewCell.Type) {
        let className = String(describing: name)
        register(name, forCellReuseIdentifier: className)
    }
    
    func cellWith<T>(identifier: T.Type, for indexPath: IndexPath) -> T? {
        let cellID = String(describing: identifier)
        guard let cell = dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
