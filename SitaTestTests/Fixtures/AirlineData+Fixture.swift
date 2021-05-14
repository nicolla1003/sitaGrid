//
//  AirlineData+Fixture.swift
//  SitaTestTests
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
@testable import SitaTest

extension AirlineData {
    static func fixture() -> AirlineData {
        AirlineData(id: "1234",
                    name: "Test Name",
                    iata: "Test Iata",
                    icao: "Test Icao",
                    callsign: "Test callsign",
                    country: "Test country",
                    active: "Y",
                    image: nil)
    }
    
    static func fixtureInvalidId() -> AirlineData {
        AirlineData(id: "invalid",
                    name: "Test Name",
                    iata: "Test Iata",
                    icao: "Test Icao",
                    callsign: "Test callsign",
                    country: "Test country",
                    active: "Y",
                    image: nil)
    }
    
    static func fixtureInvalidActive() -> AirlineData {
        AirlineData(id: "1234",
                    name: "Test Name",
                    iata: "Test Iata",
                    icao: "Test Icao",
                    callsign: "Test callsign",
                    country: "Test country",
                    active: "invalid",
                    image: nil)
    }
    
    static func fixture(id: String, active: String, value: String, imageUrl: String? = nil) -> AirlineData {
        AirlineData(id: id,
                    name: "\(value) Name",
                    iata: "\(value) Iata",
                    icao: "\(value) Icao",
                    callsign: "\(value) callsign",
                    country: "\(value) country",
                    active: value,
                    image: imageUrl)
    }
    
    static func fixtureList() -> [AirlineData] {
        [
            AirlineData.fixture(id: "1", active: "N", value: "One"),
            AirlineData.fixture(id: "2", active: "Y", value: "Two"),
            AirlineData.fixture(id: "3", active: "y", value: "Three"),
            AirlineData.fixture(id: "4", active: "n", value: "Four"),
            AirlineData.fixture(id: "5",
                                active: "Y",
                                value: "Five",
                                imageUrl: "https://miro.medium.com/max/400/1*fznM6I8gP7FPAqSYQrCgUg.png")
        ]
    }
}
