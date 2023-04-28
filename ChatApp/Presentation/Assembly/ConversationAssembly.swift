//
//  ConversationAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class ConversationAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeConversationModule(with channelModel: ChannelModel, moduleOutput: ConversationModuleOutput) -> UIViewController {
        let presenter = ConversationPresenter(
            chatService: serviceAssembly.makeChatService(),
            chatDataService: serviceAssembly.makeChatDataService(),
            profileService: serviceAssembly.makeProfileService(),
            channelModel: channelModel,
            sseService: serviceAssembly.makeSSEService(),
            mouleOutput: moduleOutput,
            imageService: serviceAssembly.makeImageService()
        )
        let vc = ConversationsViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}
