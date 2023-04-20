//
//  ConversationsListAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class ConversationsListAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeConversationsListModule(moduleOutput: ConversationsListModuleOutput) -> UIViewController {
        let presenter = ConversationsListPresenter(
            chatService: serviceAssembly.makeChatService(),
            chatDataService: serviceAssembly.makeChatDataService(),
            moduleOutput: moduleOutput
        )
        let vc = ConversationsListViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}
