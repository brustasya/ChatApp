//
//  PixabyModel.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

struct PixabayResponse<T: Decodable>: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [T]
}

struct PixabayImage: Codable {
    let id: Int
    let largeImageURL: String
}
