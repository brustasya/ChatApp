//
//  NetworkServiceProtocol.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func sendRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
    func loadImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
