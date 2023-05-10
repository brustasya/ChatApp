//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import TFSChatTransport

final class ServiceAssembly {
    
    private let host = "167.235.86.234"
    private let port = 8080
    private let apiKey = "35802088-0d943bda2487c26e70bf21274"
    private let baseURLString = "https://pixabay.com/api/"
    private let perPage = 150
    
    func makeChatDataService() -> ChatDataSourceProtocol {
        ChatDataSource(coreDataService: CoreDataService())
    }
    
    func makeChatService() -> ChatService {
        ChatService(host: host, port: port)
    }
    
    func makeProfileService() -> UserProfileDataServiceProtocol {
        UserProfileDataService()
    }
    
    func makeSSEService() -> SSEService {
        SSEService(host: host, port: port)
    }
    
    func makeImageService() -> ImageServiceProtocol {
        ImageService(apiKey: apiKey, baseURLString: baseURLString, perPage: perPage, networkService: NetworkService())
    }
}
