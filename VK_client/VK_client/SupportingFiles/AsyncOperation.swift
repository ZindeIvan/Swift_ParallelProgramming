//
//  AsyncOperation.swift
//  VK_client
//
//  Created by Зинде Иван on 9/27/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Класс асинхронной операции
class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        
        var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        }
        else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        
        state = .finished
    }
    
}
