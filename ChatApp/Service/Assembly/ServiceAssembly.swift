//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import TFSChatTransport

final class ServiceAssembly {
    
    private let host = Bundle.main.object(forInfoDictionaryKey: "Host") as? String ?? ""
    private let port = Int(Bundle.main.object(forInfoDictionaryKey: "Port") as? String ?? "") ?? 0
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String ?? ""
    private let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    private let perPage = 150
    
    func makeChatDataService() -> ChatDataSourceProtocol {
        ChatDataSource(coreDataService: CoreDataService())
    }
    
    func makeChatService() -> ChatService {
        print("1: \(host)")
        return ChatService(host: host, port: port)
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
