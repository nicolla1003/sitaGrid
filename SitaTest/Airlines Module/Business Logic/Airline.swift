//
//  Airline.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Foundation

enum FavoriteState {
    case yes
    case no
    case unknown
}

struct Airline {
    let id: Int
    let name: String
    let iata: String?
    let icao: String?
    let callsign: String?
    let country: String?
    let active: Bool
    let imageUrl: URL?
    let favorite: FavoriteState
    
    init(from data: AirlineData) throws {
        guard let idValue = Int(data.id) else {
            throw AirlineError.notValid
        }
        
        id = idValue
        name = data.name
        iata = data.iata
        icao = data.icao
        callsign = data.callsign
        country = data.country
        active = data.active.lowercased() == "y" ? true : false
        imageUrl = URL(string: data.image ?? "")
        favorite = .unknown
    }
    
    init(id: Int,
         name: String,
         iata: String?,
         icao: String?,
         callsign: String?,
         country: String?,
         active: Bool,
         imageUrl: URL?,
         favorite: Bool) {
        
        self.id = id
        self.name = name
        self.iata = iata
        self.icao = icao
        self.callsign = callsign
        self.country = country
        self.active = active
        self.imageUrl = imageUrl
        self.favorite = favorite ? .yes : .no
    }
}

enum AirlineError: Error {
    case notValid
}
