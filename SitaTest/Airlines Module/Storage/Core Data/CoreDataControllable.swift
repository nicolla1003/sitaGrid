//
//  CoreDataControllable.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
import CoreData

protocol CoreDataControllable {
    var context: NSManagedObjectContext { get }
    
    func saveAirline(_ airline: Airline) throws
    
    func update(_ airlines: [Airline]) throws
    func updateAirline(with id: Int, favorite: Bool) throws
}
