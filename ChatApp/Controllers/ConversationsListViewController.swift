//
//  ViewController.swift
//  ChatApp
//
//  Created by Станислава on 22.02.2023.
//

import UIKit

enum Section {
    case online
    case history
}

class ConversationsListViewController: UIViewController {
    let gradient = CAGradientLayer()
    let profileImageView = UIImageView()
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    private lazy var onlineConversations: [ConversationCellModel] = []
    private lazy var offlineConversations: [ConversationCellModel] = []
    
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
    
    let conversationCellModels = [
        ConversationCellModel(name: "John1", message: nil, date: nil, isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Mike1", message: "How are you?", date: Date(timeIntervalSinceNow: -169400), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Anna1", message: "Nice to meet you\nHow are you? Whats up? Whats up? Whats up? Whats up? ", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Susan1", message: "See you later", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "John444", message: "Hello", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Mike2", message: "How are you?", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Anna2", message: "Nice to meet you", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Susan2", message: "See you later", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "John2", message: "Hello", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Mike20", message: "How are you?", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Anna3", message: "Nice to meet you", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Susan4", message: "See you later", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "John5", message: "Hello", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Mike6", message: "How are you?", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Anna7", message: "Nice to meet you", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Susan8", message: "See you later", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "John9", message: "Hello", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Mike10", message: "How are you?", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Anna11", message: "Nice to meet you", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Susan12", message: "See you later", date: Date(), isOnline: false, hasUnreadMessages: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTableView()
        applySnapshot(animatingDifferences: false)
        
        if let themeRawValue = UserDefaults.standard.string(forKey: "theme"),
           let savedTheme = Theme(rawValue: themeRawValue) {
            self.theme = savedTheme
        }
        
        if theme == Theme.dark {
            changeTheme(darkTheme)
        }
        else {
            changeTheme(lightTheme)
        }
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = dataSource
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.delegate = self
        tableView.separatorColor = .clear
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, cellModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as? ConversationCell else {
                fatalError("Cannot create ConversationCell")
            }
            cell.configureTheme(with: self.theme)
            cell.configure(with: cellModel)
            cell.separatorConfigure(with: indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ConversationCellModel>()
        snapshot.appendSections([.online, .history])
        
        onlineConversations = conversationCellModels.filter { $0.isOnline }
        offlineConversations = conversationCellModels.filter { !$0.isOnline }
        
        snapshot.appendItems(onlineConversations, toSection: .online)
        snapshot.appendItems(offlineConversations, toSection: .history)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupNavbar() {
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let settingsImage = UIImage(systemName: "gear", withConfiguration: imageConfiguration)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: settingsImage,
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        profileImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let barButtonItem = UIBarButtonItem(customView: profileImageView)
        navigationItem.rightBarButtonItem = barButtonItem
        
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func openProfile() {
        let profileController = ProfileViewController()
        profileController.configure(whith: UserProfileViewModel(
            userName: "Stephen Johnson",
            userDescription: "UX/UI designer, web designer\nMoscow, RussiaUX",
            userAvatar: nil
        ))
        profileController.configureTheme(with: theme)
        present(profileController, animated: true)
    }
    
    @objc private func openSettings() {
        let themesViewController = ThemesViewController()
        
        themesViewController.delegate = self
        
        // retain cycle потенциально может возникнуть из-за того, что self захвачен в замыкании themeChangedHandler
        // и может сохраняться внутри themesViewController. Чтобы избежать возникновения retain cycle,
        // нужно захватывать self слабой ссылкой с помощью [weak self].
        themesViewController.themeChangedHandler = { [weak self] theme in
            self?.theme = theme
            
            if theme == Theme.dark {
                self?.changeTheme(self?.darkTheme ?? [:])
            }
            else {
                self?.changeTheme(self?.lightTheme ?? [:])
            }
            
            self?.tableView.reloadData()
        }
        
        themesViewController.configure(with: theme)
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    private func changeTheme(_ theme: [String: UIColor]) {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme["textColor"] ?? UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme["textColor"] ?? UIColor.black
        ]
        tableView.backgroundColor = theme["backgroundColor"]
        
        UILabel.appearance(whenContainedInInstancesOf: [
            UITableViewHeaderFooterView.self
        ]).textColor = theme["secondaryTextColor"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        gradient.colors = [
            UIColor(rgb: "#F19FB4")?.cgColor ?? UIColor.lightGray.cgColor,
            UIColor(rgb: "EE7B95")?.cgColor ?? UIColor.gray.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.75)
        profileImageView.layer.addSublayer(gradient)
        gradient.frame = profileImageView.bounds
        gradient.cornerRadius = 16
        
        let initialsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: profileImageView.frame.width, height: 20))
        initialsLabel.center = CGPoint(x: profileImageView.frame.size.width / 2, y: profileImageView.frame.size.height / 2)
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = .white
        initialsLabel.text = "SJ"
        profileImageView.addSubview(initialsLabel)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.setValue(theme.rawValue, forKey: "theme")
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
}

final class DataSource: UITableViewDiffableDataSource<Section, ConversationCellModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ONLINE"
        case 1:
            return "HISTORY"
        default:
            return nil
        }
    }
    
    

}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationsViewController = ConversationsViewController()
        conversationsViewController.configure(with: theme)
        self.navigationController?.pushViewController(conversationsViewController, animated: true)
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
        }
        else {
            changeTheme(lightTheme)
        }
        
        tableView.reloadData()
    }
}

