//
//  AirlineDetailsViewModelSpec.swift
//  SitaTestTests
//
//  Created by Nikola Nikolic on 13.5.21..
//

import XCTest
import Combine
@testable import SitaTest

class AirlineDetailsViewModelSpec: XCTestCase {
    var sut: AirlineDetailsViewModel!
    
    var airline: Airline!
    var downloader: Downloadable!
    var dataProvider: FakeDataProvider!
    var downloadTrigger: PassthroughSubject<Void, Never>!
    var favoriteTrigger: PassthroughSubject<Bool, Never>!
    
    override func setUp() {
        super.setUp()
        
        airline = try! Airline(from: AirlineData.fixture())
        downloader = Downloader()
        dataProvider = FakeDataProvider()
        downloadTrigger = PassthroughSubject()
        favoriteTrigger = PassthroughSubject()
        
        sut = AirlineDetailsViewModel(airline: airline,
                                      downloader: downloader,
                                      dataProvider: dataProvider,
                                      downloadTrigger: downloadTrigger.eraseToAnyPublisher(),
                                      favoriteTrigger: favoriteTrigger.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        airline = nil
        downloader = nil
        dataProvider = nil
        downloadTrigger = nil
        favoriteTrigger = nil
    }
}
