//
//  Publisher+Utils.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
import Combine

extension Publisher {
    public func sink(completion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void) = {_ in },
                     value: @escaping ((Self.Output) -> Void) = {_ in }) -> AnyCancellable {
        return sink(receiveCompletion: completion, receiveValue: value)
    }
    
    public func mapToVoid() -> AnyPublisher<Void, Failure> {
        return map { _ in }.eraseToAnyPublisher()
    }
}

extension Publisher {
    public func filterNil<T>() -> AnyPublisher<T, Failure> where Self.Output == T? {
        return filter { $0 != nil }.map { $0! }.eraseToAnyPublisher()
    }
}
