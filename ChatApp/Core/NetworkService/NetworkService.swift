//
//  NetworkService.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func handleStatusCode(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
        switch httpResponse.statusCode {
        case (100...299):
            return
            
        case (300...399):
            throw TFSError.redirect

        case (400...499):
            throw TFSError.badRequest

        case (500...599):
            throw TFSError.serverError

        default:
            throw TFSError.unexpectedStatus
        }
    }
}

extension NetworkService: NetworkServiceProtocol {
    func sendRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(TFSError.noData))
                return
            }
            do {
                try self?.handleStatusCode(response: response)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func loadImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(TFSError.badRequest))
            return
        }
        
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(TFSError.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }

}
