//
//  FakeAirlinesWebRepository.swift
//  SitaTestTests
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Combine
@testable import SitaTest

class FakeAirlinesWebRepository: AirlinesRepository {
    var shouldFail: Error?
    
    func fetchAirlines() -> AnyPublisher<[AirlineData], Error> {
        Future<[AirlineData], Error> { promise in
            if let error = self.shouldFail {
                promise(.failure(error))
                return
            }
            
            promise(.success(AirlineData.fixtureList()))
        }.eraseToAnyPublisher()
    }
}
