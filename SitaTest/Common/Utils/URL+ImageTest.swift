//
//  URL+ImageTest.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Foundation

// NOTE: For testing purposes
extension URL {
    static func randomImageUrl(with id: Int) -> URL? {
        URL(string: "https://picsum.photos/800?random=\(id)")
    }
}
