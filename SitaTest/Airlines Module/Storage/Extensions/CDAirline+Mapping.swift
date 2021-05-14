//
//  CDAirline+Mapping.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation

extension CDAirline {
    static let Identifier = "CDAirline"
    
    func mapToAirline() -> Airline {
        Airline(id: Int(id),
                name: name ?? "",
                iata: iata,
                icao: icao,
                callsign: callsign,
                country: country,
                active: active,
                imageUrl: URL(string: imageUrl ?? ""),
                favorite: favorite)
    }
    
    func fillData(from airline: Airline) {
        self.id = Int32(airline.id)
        self.name = airline.name
        self.iata = airline.iata
        self.icao = airline.icao
        self.callsign = airline.callsign
        self.country = airline.country
        self.active = airline.active
        self.imageUrl = airline.imageUrl?.absoluteString
        
        if airline.favorite != .unknown {
            self.favorite = airline.favorite == .yes
        }
    }
    
    func updateData(from airline: Airline) {
        if name != airline.name {
            name = airline.name
        }
        
        if iata != airline.iata {
            iata = airline.iata
        }
        
        if icao != airline.icao {
            icao = airline.icao
        }
        
        if callsign != airline.callsign {
            callsign = airline.callsign
        }
        
        if country != airline.country {
            country = airline.country
        }
        
        if active != airline.active {
            active = airline.active
        }
        
        if imageUrl != airline.imageUrl?.absoluteString {
            imageUrl = airline.imageUrl?.absoluteString
        }
        
        if airline.favorite != .unknown {
            self.favorite = airline.favorite == .yes
        }
    }
}
