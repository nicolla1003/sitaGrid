//
//  AirlineData.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Foundation

struct AirlineData: Codable {
    let id: String
    let name: String
    let iata: String?       // International Air Transport Association
    let icao: String?       // International Civil Aviation Organization
    let callsign: String?
    let country: String?
    let active: String
    let image: String?
}
