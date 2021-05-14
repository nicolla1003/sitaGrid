//
//  DataProviderError.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation

enum DataProviderError: Error {
    case notExist
    case saveFailed
    case updateFailed
}
