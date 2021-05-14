//
//  AirlineDetailsViewModel.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Combine
import UIKit

struct AirlineDetailsViewModel {
    typealias Builder = (_ downloadTrigger: AnyPublisher<Void, Never>,
                         _ favoriteTrigger: AnyPublisher<Bool, Never>) -> AirlineDetailsViewModel
    
    private let downloader: Downloadable
    let airline: Airline
    let image: AnyPublisher<UIImage, Error>
    let favorite: AnyPublisher<Bool, Error>
    
    init(airline: Airline,
         downloader: Downloadable,
         dataProvider: DataProvidable,
         downloadTrigger: AnyPublisher<Void, Never>,
         favoriteTrigger: AnyPublisher<Bool, Never>) {
        
        self.downloader = downloader
        self.airline = airline
        
        favorite = favoriteTrigger
            .flatMap {
                dataProvider.markFavorite($0, id: airline.id)
            }
            .prepend(airline.favorite == .yes)
            .eraseToAnyPublisher()
        
        image = downloadTrigger
            .map { airline.imageUrl }
            .filter { $0 != nil }
            .flatMap {
                downloader.downloadImage(url: $0!)
            }
            .eraseToAnyPublisher()
    }
}
