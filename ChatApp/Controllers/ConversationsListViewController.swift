//
//  ViewController.swift
//  ChatApp
//
//  Created by Станислава on 22.02.2023.
//
import Foundation
import UIKit
import TFSChatTransport
import Combine

enum Section {
    case online
}

class ConversationsListViewController: UIViewController {
    let gradient = CAGradientLayer()
    let profileImageView = UIImageView()
    
    let button = UIButton(type: .custom)
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    private lazy var userId = ""
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var channels = [ChannelModel]()
    private lazy var chatService = ChatService(host: "167.235.86.234", port: 8080)
    
    private lazy var theme = Theme.light
    
    private let lightTheme = [
        "backgroundColor": UIColor.white,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    private let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "textColor": UIColor.white,
        "secondaryTextColor": UIColor.systemGray5
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTableView()
        applySnapshot(animatingDifferences: false)
        
        let userId = UIDevice.current.identifierForVendor?.uuidString

        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            print("Saved user ID: \(savedUserId)")
            self.userId = savedUserId
        } else {
            UserDefaults.standard.set(userId, forKey: "userId")
            print("New user ID saved: \(userId ?? "")")
            self.userId = userId ?? ""
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadChannels), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = dataSource
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.delegate = self
        tableView.separatorColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadChannels()
    }
    
    @objc private func loadChannels() {
        chatService.loadChannels()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Load channels finished")
                    case .failure(let error):
                        print("Load channels failed with error: \(error.localizedDescription)")
                    }
                    self?.tableView.refreshControl?.endRefreshing()
                },
                receiveValue: { [weak self] channels in
                    self?.channels = channels.reversed().map({ channel in
                        ChannelModel(channel: channel)
                    })
                    self?.applySnapshot()
                }
            )
            .store(in: &cancellables)
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) {[weak self] tableView, indexPath, cellModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell else {
                fatalError("Cannot create ConversationCell")
            }
            cell.configureTheme(with: self?.theme ?? Theme.light)
            cell.configure(with: cellModel)
            cell.separatorConfigure(with: indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChannelModel>()
        snapshot.appendSections([.online])
        
        snapshot.appendItems(channels.reversed(), toSection: .online)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupNavbar() {
        let barButtonItem = UIBarButtonItem(
            title: "Add Channel",
            style: .plain,
            target: self,
            action: #selector(addChannel)
        )
        navigationItem.rightBarButtonItem = barButtonItem
                
        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func addChannel() {
        let alertController = UIAlertController(title: "Create Channel", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter channel name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let channelName = alertController.textFields?[0].text, !channelName.isEmpty else {
                return
            }
            
            self?.createChannel(channelName: channelName)
            
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)

    }
    
    private func createChannel(channelName: String) {
        chatService.createChannel(name: channelName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // Обрабатываем завершение паблишера
                switch completion {
                case .finished:
                    print("Channel created successfully")
                case .failure(let error):
                    print("Channel creation failed with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] channel in
                // Добавляем созданный канал в массив и перезагружаем таблицу
                self?.channels.append(ChannelModel(channel: channel))
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    func configure(with theme: Theme) {
        self.theme = theme
        
        view.backgroundColor = theme == Theme.dark ? .black : .white
        if theme == Theme.dark {
            changeTheme(darkTheme)
        } else {
            changeTheme(lightTheme)
        }
        
        tableView.reloadData()
    }
    
    private func changeTheme(_ theme: [String: UIColor]) {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme["textColor"] ?? .black]
        tableView.backgroundColor = theme["backgroundColor"]
        view.backgroundColor = theme["backgroundColor"]
        
        UILabel.appearance(whenContainedInInstancesOf: [
            UITableViewHeaderFooterView.self
        ]).textColor = theme["secondaryTextColor"]
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                                                theme == Theme.dark ? UIColor.white : UIColor.black]
        tabBarController?.tabBar.isHidden = false
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
}

final class DataSource: UITableViewDiffableDataSource<Section, ChannelModel> { }

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationsViewController = ConversationsViewController()
        conversationsViewController.configure(theme: theme, channel: channels.reversed()[indexPath.row].channel, userId: userId)
        self.navigationController?.pushViewController(conversationsViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

// MARK: - ThemesPickerDelegate

protocol ThemesPickerDelegate: AnyObject {
    func themesPicker(didSelectTheme theme: Theme)
}

// пример использования делегата
extension ConversationsListViewController: ThemesPickerDelegate {
    func themesPicker(didSelectTheme theme: Theme) {
        self.theme = theme
        
        if theme == Theme.dark {
            changeTheme(darkTheme)
        } else {
            changeTheme(lightTheme)
        }
        
        tableView.reloadData()
    }
}
