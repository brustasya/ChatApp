//
//  ConversationPresenter.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import TFSChatTransport
import Combine

final class ConversationPresenter {
    weak var viewInput: ConversationViewInput?
    private let chatService: ChatService
    private let chatDataService: ChatDataSourceProtocol
    private let profileService: UserProfileDataServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    private lazy var messages: [MessageModel] = []
    
    private lazy var userName = "No name"
    private lazy var userId = ""
    private let channelModel: ChannelModel

    init(
        chatService: ChatService,
        chatDataService: ChatDataSourceProtocol,
        profileService: UserProfileDataServiceProtocol,
        channelModel: ChannelModel
    ) {
        self.chatService = chatService
        self.chatDataService = chatDataService
        self.profileService = profileService
        self.channelModel = channelModel
        
        userId = UserService.shared.getUserId()
    }
    
    private func getUserName() {
        cancellable = profileService.loadUserProfile().sink(receiveValue: { [weak self] userProfile in
            if let userProfile = userProfile {
                self?.userName = userProfile.userName ?? "No name"
            }
        })
    }
    
    private func loadMessages() {
        chatService.loadMessages(channelId: channelModel.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Load messages failed with error: \(error.localizedDescription)")
                case .finished:
                    print("Load messages finished")
                }
            }, receiveValue: { [weak self] messages in
                self?.messages = messages.map {
                    MessageModel(uuid: UUID(), text: $0.text, userID: $0.userID, userName: $0.userName, date: $0.date)
                }
                
                self?.viewInput?.update(with: self?.messages.reversed() ?? [])
                
                self?.chatDataService.saveMessagesModels(
                    with: self?.messages ?? [],
                    in: self?.channelModel ?? ChannelModel(
                        id: UUID().uuidString, name: "No name", logoURL: nil, lastMessage: nil, lastActivity: nil
                    ))
            })
            .store(in: &cancellables)
    }
    
    func createMessage(with text: String) {
        chatService.sendMessage(text: text, channelId: channelModel.id, userId: userId, userName: userName)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Сообщение отправлено")
                    case .failure(let error):
                        print("Ошибка отправки сообщения: \(error)")
                    }
                },
                receiveValue: { [weak self] message in
                    let messageModel = MessageModel(
                        uuid: UUID(),
                        text: message.text,
                        userID: message.userID,
                        userName: message.userName,
                        date: message.date
                    )
                    self?.messages.append(messageModel)
                    self?.viewInput?.update(with: self?.messages.reversed() ?? [])
                    
                    self?.chatDataService.saveMessageModel(with: messageModel, in: self?.channelModel ?? ChannelModel(
                        id: UUID().uuidString,
                        name: "No name",
                        logoURL: nil,
                        lastMessage: nil,
                        lastActivity: nil))
                }
            )
            .store(in: &cancellables)
    }
    
    private func getMesssages() {
        self.viewInput?.update(with: chatDataService.getMessages(for: channelModel.id).reversed())
    }
}

extension ConversationPresenter: ConversationViewOutput {
    func viewIsReady() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(theme)
        viewInput?.setupNavigationBarContent(logoURL: channelModel.logoURL ?? "", name: channelModel.name)
        viewInput?.setupUserId(userId: userId)
        
        getMesssages()
        loadMessages()
        getUserName()
    }
    
    func sendMessage(with text: String) {
        if text != "" {
            createMessage(with: text)
            viewInput?.clearMessageTextField()
        }
    }
}
