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
    private let sseService: SSEService
    private let chatDataService: ChatDataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var channels = [ChannelModel]()
    
    init(
        chatService: ChatService,
        chatDataService: ChatDataSourceProtocol,
        moduleOutput: ConversationsListModuleOutput?,
        sseService: SSEService
    ) {
        self.chatService = chatService
        self.chatDataService = chatDataService
        self.moduleOutput = moduleOutput
        self.sseService = sseService
    }
    
    private func getChannels() {
        channels = chatDataService.getAllChannels()
        viewInput?.applySnapshot(with: channels)
    }
    
    private func getChannel(with id: String) {
        chatService.loadChannel(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Logger.shared.printLog(log: "Error loading channel: \(error)")
                case .finished:
                    Logger.shared.printLog(log: "Loading channel finished")
                }
            }, receiveValue: { [weak self] channel in
                Logger.shared.printLog(log: "Loaded channel: \(channel)")
                self?.addNewChannel(with: channel)
            })
            .store(in: &cancellables)
    }
    
    private func addNewChannel(with channel: Channel) {
        let channelModel = ChannelModel(
            id: channel.id,
            name: channel.name,
            logoURL: channel.logoURL,
            lastMessage: channel.lastMessage,
            lastActivity: channel.lastActivity
        )
        channels.append(channelModel)
        chatDataService.saveChannelModel(with: channelModel)
        
        viewInput?.applySnapshot(with: channels)
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
                    switch chatEvent.eventType {
                    case .add:
                        self?.getChannel(with: chatEvent.resourceID)
                    case .update:
                        self?.updateChannel(at: chatEvent.resourceID)
                    case .delete:
                        self?.delete(at: chatEvent.resourceID)
                    }
                })
            .store(in: &cancellables)
    }
    
    private func delete(at id: String) {
        chatDataService.deleteChannel(with: id)
        channels.removeAll { $0.id == id }
        
        viewInput?.applySnapshot(with: channels)
    }
    
    private func deleteChannel(at id: String) {
        chatService.deleteChannel(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.shared.printLog(log: "Канал успешно удален")
                case .failure(let error):
                    Logger.shared.printLog(log: "Ошибка при удалении канала: \(error.localizedDescription)")
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    private func updateChannel(at id: String) {
        chatDataService.deleteChannel(with: id)
        channels.removeAll { $0.id == id }
        getChannel(with: id)
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
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func loadChannels() {
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
                    self?.channels.sort(by: { $0.lastActivity ?? Date.distantPast < $1.lastActivity ?? Date.distantPast })
                    self?.chatDataService.saveChannelModels(with: self?.channels ?? [])
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
        loadChannels()
        sseUpdate()
    }
    
    func viewWillAppear() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(theme: theme)
    }
    
    func reloadData() {
        loadChannels()
    }
    
    func addChannel(name: String) {
        createChannel(channelName: name)
    }
    
    func addChannelButtonTapped() {
        viewInput?.showAlert()
    }
    
    func channelDeleted(at indexPath: IndexPath) {
        deleteChannel(at: channels[channels.count - 1 - indexPath.row].id)
    }
    
    func channelDidSelect(at indexPath: IndexPath) {
        moduleOutput?.moduleWantsToOpenConversation(with: channels.reversed()[indexPath.row])
    }
}
