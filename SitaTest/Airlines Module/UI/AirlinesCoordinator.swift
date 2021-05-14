//
//  AirlinesCoordinator.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import UIKit

final class AirlinesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {        
        self.navigationController = navigationController
    }
    
    func start() {
        showAllAirlines()
    }
}

extension AirlinesCoordinator: Airlinable {
    func showAllAirlines() {
        let vc = AirlinesViewController.instantiate()
        vc.title = "Airlines"
        
        vc.coordinator = self
        
        vc.viewModelBuilder = { searchTrigger in
            AirlinesViewModel(searchTerm: searchTrigger,
                              repository: AirlinesWebRepository(),
                              dataProvider: CoreDataProvider(controller: CoreDataContoller.shared))
        }
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func open(airline: Airline) {
        let vc = AirlineDetailsViewController.instantiate()
        vc.title = airline.name
        
        vc.coordinator = self
        
        vc.viewModelBuilder = { loadTrigger, favoriteTrigger in
            AirlineDetailsViewModel(airline: airline,
                                    downloader: Downloader(),
                                    dataProvider: CoreDataProvider(controller: CoreDataContoller.shared),
                                    downloadTrigger: loadTrigger,
                                    favoriteTrigger: favoriteTrigger)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
}
