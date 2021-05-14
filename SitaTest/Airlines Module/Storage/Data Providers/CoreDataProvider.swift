//
//  CoreDataProvider.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Combine
import CoreData

class CoreDataProvider: DataProvidable {
    private let controller: CoreDataControllable
    
    init(controller: CoreDataControllable) {
        self.controller = controller
    }
    
    func airlinesDataListener() -> AnyPublisher<[Airline], Error> {
        CDPublisher(request: NSFetchRequest<CDAirline>(entityName: CDAirline.Identifier),
                    context: controller.context)
            .map { data in
                data.map {
                    $0.mapToAirline()
                }
            }
            .eraseToAnyPublisher()
    }
    func saveAllAirlines(_ airlines: [Airline]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            if ((try? self.controller.update(airlines)) != nil) {
                promise(.success(()))
            } else {
                promise(.failure(DataProviderError.saveFailed))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateAirline(_ airline: Airline) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            if ((try? self.controller.saveAirline(airline)) != nil) {
                promise(.success(()))
            } else {
                promise(.failure(DataProviderError.updateFailed))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func markFavorite(_ favorite: Bool, id: Int) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            if (try? self.controller.updateAirline(with: id, favorite: favorite)) != nil {
                promise(.success(favorite))
            } else {
                promise(.failure(DataProviderError.updateFailed))
            }
        }
        .eraseToAnyPublisher()
    }
}
