//
//  HttpClient.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation
import Combine

protocol HttpClient {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension HttpClient {
    var session: URLSession {
        URLSession.shared
    }
    
    var baseURL: String {
        "https://2a6d3177-4681-4fc9-97b9-e4e9580db87a.mock.pstmn.io"
    }
    
    func call<T: Decodable>(endpoint: HttpEndpoint,
                            body: [String: AnyObject]? = nil) -> AnyPublisher<T, Error> {
        Just(())
            .tryMap {
                try endpoint.urlRequest(baseURL: self.baseURL, body: body)
            }
            .flatMap { request in
                self.session
                    .dataTaskPublisher(for: request)
                    .retry(3)
                    .processResponse()
            }
            .holdResponse(toBeAtLeast: 0.5)
    }
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .retry(3)
            .tryMap { $0.data }
            .eraseToAnyPublisher()
    }
    
    func download(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        session.dataTask(with: url) { data, _, error in
            completion(data, error)
        }
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func processResponse<T: Decodable>() -> AnyPublisher<T, Error> {
        return tryMap {
            guard let statusCode = ($0.response as? HTTPURLResponse)?.statusCode else {
                throw HttpError.unexpectedResponse
            }
            
            if let error = HttpError.error(withCode: statusCode) {
                throw error
            }
            
            if $0.data.isEmpty, let data = "{}".data(using: .utf8) {
                return data
            }
            return $0.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func holdResponse(toBeAtLeast interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        let timer = Just(())
            .delay(for: .seconds(interval), scheduler: RunLoop.main)
            .setFailureType(to: Failure.self)
        
        return zip(timer)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
}
