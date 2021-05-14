//
//  AirlinesViewModel.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Foundation
import Combine

struct AirlinesViewModel {
    typealias Builder = (_ searchTrigger: AnyPublisher<String, Never>) -> AirlinesViewModel
    
    let data: AnyPublisher<[Airline], Error>
    let dataSaveComplete: AnyPublisher<Void, Error>
    
    init(searchTerm: AnyPublisher<String, Never>,
         repository: AirlinesRepository,
         dataProvider: DataProvidable) {
        
        dataSaveComplete = repository.fetchAirlines()
            .map {
                AirlinesViewModel.prepare(data: $0)
            }
            .flatMap {
                dataProvider.saveAllAirlines($0)
            }
            .eraseToAnyPublisher()
        
        let localData = dataProvider.airlinesDataListener()
            .handleEvents(receiveOutput: { _ in
                print("Local data received")
            })
        
        let filteredAirlines = searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .combineLatest(localData)
            .filterBySearchTerm()
            .eraseToAnyPublisher()
        
        data = Publishers
            .Merge(localData, filteredAirlines)
            .eraseToAnyPublisher()
    }
    
    static func prepare(data: [AirlineData]) -> [Airline] {
        var prepared: [Airline] = []
        data.forEach {
            if let airline = try? Airline(from: $0) {
                prepared.append(airline)
            }
        }
        return prepared
    }
}

extension Publisher where Output == (String, [Airline]) {
    func filterBySearchTerm() -> AnyPublisher<[Airline], Failure> {
        map { (term, data) in
            if term.isEmpty {
                return data
            }
            
            return data.filter {
                $0.name.lowercased().contains(term.lowercased())
            }
        }.eraseToAnyPublisher()
    }
}
