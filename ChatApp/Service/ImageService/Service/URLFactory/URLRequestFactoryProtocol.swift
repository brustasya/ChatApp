//
//  URLRequestFactoryProtocol.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol URLRequestFactoryProtocol {
    func searchImagesURL(for queue: String) throws -> URL
}
