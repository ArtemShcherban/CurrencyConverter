//
//  Group.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 30.08.2022.
//

import Foundation

struct Group {
    var visible: Bool
    var name: String
    var key: Int16
    
    init(visible: Bool, name: String, key: Int16) {
        self.visible = visible
        self.name = name
        self.key = key
    }
}
