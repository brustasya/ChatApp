//
//  URLRequestFactory.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

final class URLRequestFactory {
    private let apiKey: String
    private let baseURLString: String
    private let perPage: Int
    
    init(apiKey: String, baseURLString: String, perPage: Int) {
        self.apiKey = apiKey
        self.baseURLString = baseURLString
        self.perPage = perPage
    }
}

extension URLRequestFactory: URLRequestFactoryProtocol {
    func searchImagesURL() -> URL {
        let urlString =
        "\(baseURLString)?key=\(apiKey)&q=yellow+flowers&image_type=photo&pretty=true&image_type=photo&pretty=true&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL string: \(urlString)")
        }
        return url
    }
}
