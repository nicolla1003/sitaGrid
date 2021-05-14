//
//  CoreDataContoller.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
import CoreData

class CoreDataContoller {
    static let shared = CoreDataContoller()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SitaTest")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("loadPersistentStores error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}
}

extension CoreDataContoller: CoreDataControllable {
    func saveAirline(_ airline: Airline) throws {
        try insert(airline: airline)
        saveContext()
    }
    
    func update(_ airlines: [Airline]) throws {
        DispatchQueue.global().async {
            self.mergeLocal(with: airlines)
        }
        
        print("Core Data: Save/Update count \(airlines.count)")
        
        DispatchQueue.global().async {
            self.deleteDeprecated(newData: airlines)
        }
    }
    
    func updateAirline(with id: Int, favorite: Bool) throws {
        guard let airline = fetchAirline(withId: id) else {
            throw DataProviderError.notExist
        }
        
        print("Mark airline with id \(id) as favorite \(favorite)")
        airline.favorite = favorite
        saveContext()
    }
}

private extension CoreDataContoller {
    func fetchAirline(withId id: Int) -> CDAirline? {
        let request = NSFetchRequest<CDAirline>(entityName: CDAirline.Identifier)
        request.predicate = NSPredicate(format: "id == %@", "\(id)" as CVarArg)
        return try? context.fetch(request).first
    }
    
    func fetchAllAirlines() -> [CDAirline] {
        let request = NSFetchRequest<CDAirline>(entityName: CDAirline.Identifier)
        return (try? context.fetch(request)) ?? []
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("saveContext error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

private extension CoreDataContoller {
    func insert(airline: Airline) throws {
        guard let cdAirline = fetchAirline(withId: airline.id) else {
            return createNew(from: airline)
        }
        print("Code data: Update \(airline.id)")
        cdAirline.fillData(from: airline)
    }
    
    func createNew(from airline: Airline) {
        print("Code data: New \(airline.id)")
        let cdAirline = CDAirline(context: context)
        cdAirline.fillData(from: airline)
        
        context.insert(cdAirline)
    }
    
    func getLocalAirlines() -> [CDAirline] {
        let cdAirlineArray = fetchAllAirlines()
        return cdAirlineArray
    }
    
    func deleteAirlines(_ airlines: [CDAirline]) {
        airlines.forEach {
            context.delete($0)
        }
        saveContext()
    }
    
    func mergeLocal(with airlines: [Airline]) {
        let local = fetchAllAirlines()
        
        var exists = false
        
        for new in airlines {
            exists = false
            
            for current in local {
                if new.id == current.id {
                    current.updateData(from: new)
                    exists = true
                }
            }
            
            if !exists {
                DispatchQueue.main.async {
                    self.createNew(from: new)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.saveContext()
        }
    }
    
    func deleteDeprecated(newData: [Airline]) {
        let localData = getLocalAirlines()
        
        var forDeleting: [CDAirline] = []
        
        localData.forEach { localOne in
            if !newData.contains(where: { newOne in newOne.id == localOne.id }) {
                forDeleting.append(localOne)
            }
        }
        
        print("Core Data: Delete count \(forDeleting.count)")
        
        DispatchQueue.main.async {
            self.deleteAirlines(forDeleting)
        }
    }
}
