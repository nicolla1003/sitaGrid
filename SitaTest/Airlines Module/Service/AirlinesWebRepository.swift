//
//  AirlinesWebRepository.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import Combine
import Foundation

struct AirlinesWebRepository: HttpClient, AirlinesRepository {
    init() {}
    
    func fetchAirlines() -> AnyPublisher<[AirlineData], Error> {
        call(endpoint: Endpoint.airlines)
    }
}

extension AirlinesWebRepository {
    enum Endpoint {
        case airlines
    }
}

extension AirlinesWebRepository.Endpoint: HttpEndpoint {
    var path: String {
        switch self {
        case .airlines: return "/airlines"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .airlines: return .get
        }
    }
    
    var headers: [String: String]? {
        [:]
    }
}
