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
    weak var moduleOutput: ConversationModuleOutput?
    
    private let chatService: ChatService
    private let chatDataService: ChatDataSourceProtocol
    private let profileService: UserProfileDataServiceProtocol
    private let sseService: SSEService
    private let imageService: ImageServiceProtocol
    
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
        channelModel: ChannelModel,
        sseService: SSEService,
        mouleOutput: ConversationModuleOutput,
        imageService: ImageServiceProtocol
    ) {
        self.chatService = chatService
        self.chatDataService = chatDataService
        self.profileService = profileService
        self.channelModel = channelModel
        self.sseService = sseService
        self.moduleOutput = mouleOutput
        self.imageService = imageService
        
        userId = UserService.shared.getUserId()
    }
    
    private func sseUpdate() {
        sseService.subscribeOnEvents()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Subscription finished")
                    case .failure(let error):
                        print("Subscription failed with error: \(error)")
                    }
                },
                receiveValue: {[weak self] chatEvent in
                    if chatEvent.eventType == .update &&
                        chatEvent.resourceID == self?.channelModel.id {
                        self?.loadMessages()
                    }
                })
            .store(in: &cancellables)
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
                receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    private func getMesssages() {
        self.viewInput?.update(with: chatDataService.getMessages(for: channelModel.id).reversed())
    }
    
    /*
    private func configureCell(with cell: MessageTableViewCell, model: MessageModel) {
        var imageData: Data?
        imageService.loadImageData(from: model.text) { result in
            switch result {
            case .success(let data):
                imageData = data
            case .failure(let error):
                Logger.shared.printLog(log: "Error loading image: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                if imageData != nil {
                    cell.configure(with: model)
                } else {
                    cell.configure(with: model)
                }
            }
        }
    }
    */
    
    private func setupNavBar() {
        imageService.loadImageData(from: channelModel.logoURL ?? "") { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.viewInput?.setupNavigationBarContent(logoURL: data, name: self?.channelModel.name ?? "No name")
                }
            case .failure(let error):
                self?.viewInput?.setupNavigationBarContent(
                    logoURL: UIImage(named: "avatar")?.pngData() ?? Data(), name: self?.channelModel.name ?? "No name"
                )
                Logger.shared.printLog(log: "Error loading image: \(error.localizedDescription)")
            }
        }
    }
}

extension ConversationPresenter: ConversationViewOutput {
    func viewIsReady() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(theme)
        viewInput?.setupUserId(userId: userId)
        setupNavBar()
        getMesssages()
        loadMessages()
        getUserName()
        sseUpdate()
    }
    
    func sendMessage(with text: String) {
        if text != "" {
            createMessage(with: text)
            viewInput?.clearMessageTextField()
        }
    }
    
    func photoButtonTapped() {
        viewInput?.showAlert()
    }
    
    func presentImages(with delegate: ImageSelectionDelegate?) {
        moduleOutput?.conversationModuleWantsToOpenImageSelection(with: delegate)
    }
    
    func addMessage(with cell: MessageTableViewCell, model: MessageModel) {
       // configureCell(with: cell, model: model)
    }
}
