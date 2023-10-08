//
//  Observable.swift
//  Tracker
//
//  Created by Руслан  on 30.09.2023.
//

import Foundation

@propertyWrapper
final class Observable<T> {
    typealias TypeValue = T

    private var onChange: ((TypeValue) -> Void)?
    
    var wrappedValue: TypeValue {
        didSet {
            onChange?(wrappedValue)
        }
    }
    var projectedValue: Observable<T> {
        return self
    }
    
    init(wrappedValue: TypeValue) {
        onChange = nil
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping (TypeValue) -> Void) {
        self.onChange = action
    }
}
