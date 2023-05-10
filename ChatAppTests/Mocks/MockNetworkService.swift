//
//  MockCoreDataService.swift
//  ChatAppTests
//
//  Created by Станислава on 10.05.2023.
//

import Foundation
import CoreData
@testable import ChatApp
@testable import TFSChatTransport

class MockNetworkService: NetworkServiceProtocol {

    var invokedSendRequest = false
    var invokedSendRequestCount = 0
    var invokedSendRequestParameters: (url: URL, Void)?
    var invokedSendRequestParametersList = [(url: URL, Void)]()

    func sendRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        invokedSendRequest = true
        invokedSendRequestCount += 1
        invokedSendRequestParameters = (url, ())
        invokedSendRequestParametersList.append((url, ()))
    }

    var invokedLoadImageData = false
    var invokedLoadImageDataCount = 0
    var invokedLoadImageDataParameters: (urlString: String, Void)?
    var invokedLoadImageDataParametersList = [(urlString: String, Void)]()
    var stubbedLoadImageDataCompletionResult: (Result<Data, Error>, Void)?

    func loadImageData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        invokedLoadImageData = true
        invokedLoadImageDataCount += 1
        invokedLoadImageDataParameters = (urlString, ())
        invokedLoadImageDataParametersList.append((urlString, ()))
        if let result = stubbedLoadImageDataCompletionResult {
            completion(result.0)
        }
    }
}
