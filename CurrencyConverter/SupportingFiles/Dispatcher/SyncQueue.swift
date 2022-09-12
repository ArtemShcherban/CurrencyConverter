//
//  SyncQueue.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

class SyncQueue: Dispatcher {
    static let main = SyncQueue(queue: .main)
    static let global = SyncQueue(queue: .global())
    static let background = SyncQueue(queue: .global(qos: .background))
}

extension SyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.sync(execute: work)
    }
    
    func dispatchAfter(deadline: DispatchTime, work: @escaping () -> Void) {
        queue.asyncAfter(deadline: deadline, execute: work)
    }
    
    func dispatchAfter(deadline: DispatchTime, work: DispatchWorkItem) {
        queue.asyncAfter(deadline: deadline, execute: work)
    }
}
