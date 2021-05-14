//
//  Downloader.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import Combine
import UIKit

protocol Downloadable {
    func downloadImage(url: URL) -> AnyPublisher<UIImage, Error>
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void)
}

struct Downloader: HttpClient, Downloadable {
    init() {}
    
    func downloadImage(url: URL) -> AnyPublisher<UIImage, Error> {
        download(url: url)
            .tryMap {
                guard let image = UIImage(data: $0) else {
                    throw HttpError.downloadFailed
                }
                return image
            }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        download(url: url) { data, _ in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}
