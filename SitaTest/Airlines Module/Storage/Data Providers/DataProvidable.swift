//
//  DataProvidable.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Combine

protocol DataProvidable {
    func airlinesDataListener() -> AnyPublisher<[Airline], Error>
    func saveAllAirlines(_ airlines: [Airline]) -> AnyPublisher<Void, Error>
    func updateAirline(_ airline: Airline) -> AnyPublisher<Void, Error>
    func markFavorite(_ favorite: Bool, id: Int) -> AnyPublisher<Bool, Error>
}
