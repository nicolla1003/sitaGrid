//
//  HttpError.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation

enum HttpError: Error {
    case invalidURL
    case unauthorized
    case invalidRequest
    case unexpectedResponse
    case downloadFailed
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success  = 200 ..< 300
}

extension HttpError {
    static func error(withCode code: Int) -> HttpError? {
        guard !HTTPCodes.success.contains(code) else {
            return nil
        }
        return .unexpectedResponse
    }
}
