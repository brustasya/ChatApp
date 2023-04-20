//
//  ConversationsListPresenter.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import TFSChatTransport
import Combine

final class ConversationsListPresenter {
    weak var viewInput: ConversationsListViewInput?
    weak var moduleOutput: ConversationsListModuleOutput?
    
    private let chatService: ChatService
    private let chatDataService: ChatDataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var channels = [ChannelModel]()
    
    init(
        chatService: ChatService,
        chatDataService: ChatDataSourceProtocol,
        moduleOutput: ConversationsListModuleOutput?
    ) {
        self.chatService = chatService
        self.chatDataService = chatDataService
        self.moduleOutput = moduleOutput
    }
    
    private func getChannels() {
        channels = chatDataService.getAllChannels().reversed()
        viewInput?.applySnapshot(with: channels)
    }
    
    private func deleteChannel(at indexPath: IndexPath) {
        let channelId = channels[channels.count - 1 - indexPath.row].id
        let count = channels.count
        chatService.deleteChannel(id: channelId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.shared.printLog(log: "Канал успешно удален")
                case .failure(let error):
                    Logger.shared.printLog(log: "Ошибка при удалении канала: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                self?.chatDataService.deleteChannel(with: channelId)
                self?.channels.remove(at: count - 1 - indexPath.row)
                
                self?.viewInput?.applySnapshot(with: self?.channels ?? [])
            })
            .store(in: &cancellables)
    }
    
    private func createChannel(channelName: String) {
        chatService.createChannel(name: channelName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    Logger.shared.printLog(log: "Channel created successfully")
                case .failure(let error):
                    Logger.shared.printLog(log: "Channel creation failed with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] channel in
                let channelModel = ChannelModel(
                    id: channel.id,
                    name: channel.name,
                    logoURL: channel.logoURL,
                    lastMessage: channel.lastMessage,
                    lastActivity: channel.lastActivity
                )
                self?.channels.append(channelModel)
                self?.chatDataService.saveChannelModel(with: channelModel)
                
                self?.viewInput?.applySnapshot(with: self?.channels ?? [])
            }
            .store(in: &cancellables)
    }
    
    private func loadChannels(isSave: Bool) {
        chatService.loadChannels()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        Logger.shared.printLog(log: "Load channels finished")
                    case .failure(let error):
                        Logger.shared.printLog(log: "Load channels failed with error: \(error.localizedDescription)")
                    }
                    
                    self?.viewInput?.stopRefreshing()
                },
                receiveValue: { [weak self] channels in
                    self?.channels = channels.reversed().map({ channel in
                        ChannelModel(
                            id: channel.id,
                            name: channel.name,
                            logoURL: channel.logoURL,
                            lastMessage: channel.lastMessage,
                            lastActivity: channel.lastActivity
                        )
                    })
                    
                    if isSave {
                        self?.chatDataService.saveChannelModels(with: self?.channels ?? [])
                    }
                    
                    self?.viewInput?.applySnapshot(with: self?.channels ?? [])
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadTheme() {
        ThemeService.shared.loadTheme { [weak self] theme in
            self?.viewInput?.changeTheme(theme: theme ?? Theme.light)
        }
    }
}

extension ConversationsListPresenter: ConversationsListViewOutput {
    func viewIsReady() {
        loadTheme()
        getChannels()
        loadChannels(isSave: true)
    }
    
    func viewWillAppear() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(theme: theme)
        loadChannels(isSave: false)
    }
    
    func reloadData() {
        loadChannels(isSave: true)
    }
    
    func addChannel(name: String) {
        createChannel(channelName: name)
    }
    
    func addChannelButtonTapped() {
        viewInput?.showAlert()
    }
    
    func channelDeleted(at indexPath: IndexPath) {
        deleteChannel(at: indexPath)
    }
    
    func channelDidSelect(at indexPath: IndexPath) {
        moduleOutput?.moduleWantsToOpenConversation(with: channels.reversed()[indexPath.row])
    }
}
