//
//  ImageService.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

class ImageService {
    private let networkService: NetworkService = NetworkService()
    private let urlFactory: URLRequestFactoryProtocol
    
    init(apiKey: String, baseURLString: String, perPage: Int) {
        urlFactory = URLRequestFactory(apiKey: apiKey, baseURLString: baseURLString, perPage: perPage)
    }
}

extension ImageService: ImageServiceProtocol {
    func loadImages(completion: @escaping (Result<[String], Error>) -> Void) {
        do {
            let url = try urlFactory.searchImagesURL(
                for: "yellow+flowers&image_type=photo&pretty=true&image_type=photo&pretty=true"
            )
            networkService.sendRequest(url: url) { (result: Result<PixabayResponse<PixabayImage>, Error>) in
                switch result {
                case .success(let response):
                    let imageUrls = response.hits.map { $0.largeImageURL }
                    completion(.success(imageUrls))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        networkService.loadImageData(from: urlString, completion: completion)
    }

}
