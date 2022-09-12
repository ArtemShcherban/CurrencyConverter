//
//  Dispatcher.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

class Dispatcher {
    var queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
}

protocol Dispatching {
    func dispatch(work: @escaping () -> Void)
    func dispatchAfter(deadline: DispatchTime, work: @escaping () -> Void)
    func dispatchAfter(deadline: DispatchTime, work: DispatchWorkItem)
}
