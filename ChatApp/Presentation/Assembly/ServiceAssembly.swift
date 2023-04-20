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
    
    func makeChatDataService() -> ChatDataSourceProtocol {
        ChatDataSource()
    }
    
    func makeChatService() -> ChatService {
        ChatService(host: host, port: port)
    }
    
    func makeProfileService() -> UserProfileDataServiceProtocol {
        UserProfileDataService()
    }
}
