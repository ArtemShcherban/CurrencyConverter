//
//  AsyncQueue.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

class AsyncQueue: Dispatcher {
    static let main = AsyncQueue(queue: .main)
    static let global = AsyncQueue(queue: .global())
    static let background = AsyncQueue(queue: .global(qos: .background))
}

extension AsyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.async(execute: work)
    }
}
