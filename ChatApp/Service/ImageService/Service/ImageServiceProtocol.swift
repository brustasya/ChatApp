//
//  ImageServiceProtocol.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ImageServiceProtocol: AnyObject {
    func loadImages(completion: @escaping (Result<[String], Error>) -> Void)
    func loadImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
