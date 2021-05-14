//
//  AirlinesViewModelSpec.swift
//  SitaTestTests
//
//  Created by Nikola Nikolic on 13.5.21..
//

import XCTest
import Combine
@testable import SitaTest

class AirlinesViewModelSpec: XCTestCase {
    var sut: AirlinesViewModel!
    
    var searchTerm: PassthroughSubject<String, Never>!
    var repository: FakeAirlinesWebRepository!
    var dataProvider: FakeDataProvider!
    
    override func setUp() {
        super.setUp()
        
        searchTerm = PassthroughSubject()
        repository = FakeAirlinesWebRepository()
        dataProvider = FakeDataProvider()
        
        sut = AirlinesViewModel(searchTerm: searchTerm.eraseToAnyPublisher(),
                                repository: repository,
                                dataProvider: dataProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        searchTerm = nil
        repository = nil
        dataProvider = nil
    }
    
    func testWhenFetchThenSuccess() {
        let expectStatus = XCTestExpectation(description: "wait for success fetch")
        
        let expectedData = AirlineData.fixtureList().map { try! Airline(from: $0) }
        
        let subject = sut.data
            .sink(completion: { result in
                switch result {
                case .failure:
                    XCTFail("Failure should not happen when success is expected.")
                    break
                case .finished:
                    break
                }
            }, value: { airlines in
                XCTAssertEqual(airlines.count, expectedData.count)
                XCTAssertTrue(!airlines.isEmpty)
                expectStatus.fulfill()
            })
                
        dataProvider.dataChangeTrigger.send(expectedData)
        
        XCTAssertNotNil(subject)
        wait(for: [expectStatus], timeout: 5)
    }
    
    func testWhenSearchThenHasResult() {
        let expectStatus = XCTestExpectation(description: "wait for successfull search")
        
        let expectedData = AirlineData.fixtureList()
            .map { try! Airline(from: $0) }
        
        
        let subject = sut.data
            .dropFirst()
            .sink(completion: { result in
                switch result {
                case .failure:
                    XCTFail("Failure should not happen when success is expected.")
                    break
                case .finished:
                    break
                }
            }, value: { airlines in
                XCTAssertEqual(airlines.count, 3)
                XCTAssertTrue(!airlines.isEmpty)
                expectStatus.fulfill()
            })
        
        dataProvider.dataChangeTrigger.send(expectedData)
        searchTerm.send("o")
        
        XCTAssertNotNil(subject)
        wait(for: [expectStatus], timeout: 5)
    }
    
    func testWhenSearchThenEmpty() {
        let expectStatus = XCTestExpectation(description: "wait for search with no result")
        
        let expectedData = AirlineData.fixtureList()
            .map { try! Airline(from: $0) }
        
        
        let subject = sut.data
            .dropFirst()
            .sink(completion: { result in
                switch result {
                case .failure:
                    XCTFail("Failure should not happen when success is expected.")
                    break
                case .finished:
                    break
                }
            }, value: { airlines in
                XCTAssertTrue(airlines.isEmpty)
                expectStatus.fulfill()
            })
        
        dataProvider.dataChangeTrigger.send(expectedData)
        searchTerm.send("nikola")
        
        XCTAssertNotNil(subject)
        wait(for: [expectStatus], timeout: 5)
    }
    
    func testWhenSaveThenSuccess() {
        let expectStatus = XCTestExpectation(description: "wait for success save")
        
        let expectedData = AirlineData.fixtureList().map { try! Airline(from: $0) }
        
        let subject = sut.dataSaveComplete
            .sink(completion: { result in
                switch result {
                case .failure:
                    XCTFail("Failure should not happen when success is expected.")
                    break
                case .finished:
                    break
                }
            }, value: {
                expectStatus.fulfill()
            })
                
        dataProvider.dataChangeTrigger.send(expectedData)
        
        XCTAssertNotNil(subject)
        wait(for: [expectStatus], timeout: 5)
    }
    
    func testWhenSaveThenFailure() {
        let expectStatus = XCTestExpectation(description: "wait for failed save")
        
        let expectedData = AirlineData.fixtureList().map { try! Airline(from: $0) }
        
        dataProvider.error = DataProviderError.saveFailed
        
        let subject = sut.dataSaveComplete
            .sink(completion: { result in
                switch result {
                case .failure:
                    expectStatus.fulfill()
                    break
                case .finished:
                    break
                }
            }, value: {
                XCTFail("Success should not happen when failure is expected.")
            })
        
        dataProvider.dataChangeTrigger.send(expectedData)
        
        XCTAssertNotNil(subject)
        wait(for: [expectStatus], timeout: 5)
    }
}
