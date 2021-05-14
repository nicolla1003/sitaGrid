//
//  FakeDataProvider.swift
//  SitaTestTests
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
import Combine
@testable import SitaTest

class FakeDataProvider: DataProvidable {
    let dataChangeTrigger = PassthroughSubject<[Airline], Error>()
    var error: DataProviderError?
    
    init() {}
    
    func airlinesDataListener() -> AnyPublisher<[Airline], Error> {
        dataChangeTrigger
            .eraseToAnyPublisher()
    }
    
    func saveAllAirlines(_ airlines: [Airline]) -> AnyPublisher<Void, Error> {
        voidWithError(error)
    }
    
    func updateAirline(_ airline: Airline) -> AnyPublisher<Void, Error> {
        voidWithError(error)
    }
    
    func markFavorite(_ favorite: Bool, id: Int) -> AnyPublisher<Bool, Error> {
        voidWithError(error)
            .map { favorite }
            .eraseToAnyPublisher()
    }
    
    private func voidWithError(_ error: Error?) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            if let error = error {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}
