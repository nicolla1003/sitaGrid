//
//  HttpEndpoint.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation

protocol HttpEndpoint {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
}

extension HttpEndpoint {
    func urlRequest(baseURL: String, body: [String: AnyObject]? = nil) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw HttpError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue        
        request.allHTTPHeaderFields = headers
        request.httpBody = try data(from: body)
        return request
    }
}

private extension HttpEndpoint {
    func data(from params: [String: AnyObject]? = nil) throws -> Data? {
        guard let params = params else {
            return nil
        }
        return try JSONSerialization.data(withJSONObject: params,
                                          options: JSONSerialization.WritingOptions())
    }
}
