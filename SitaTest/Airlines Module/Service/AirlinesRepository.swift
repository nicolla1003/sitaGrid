//
//  AirlinesRepository.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Combine

protocol AirlinesRepository {
    func fetchAirlines() -> AnyPublisher<[AirlineData], Error>
}
