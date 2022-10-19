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
    var key: Int
    
    init(visible: Bool, name: String, key: Int) {
        self.visible = visible
        self.name = name
        self.key = key
    }
}
