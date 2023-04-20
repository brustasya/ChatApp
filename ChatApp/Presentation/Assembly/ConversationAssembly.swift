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
    
    func makeConversationModule(with channelModel: ChannelModel) -> UIViewController {
        let presenter = ConversationPresenter(
            chatService: serviceAssembly.makeChatService(),
            chatDataService: serviceAssembly.makeChatDataService(),
            profileService: serviceAssembly.makeProfileService(),
            channelModel: channelModel
        )
        let vc = ConversationsViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}
