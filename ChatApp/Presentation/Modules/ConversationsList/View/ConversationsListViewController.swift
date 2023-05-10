//
//  ConversationsListViewController1.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

enum Section {
    case online
}

class ConversationsListViewController: UIViewController {
    private var output: ConversationsListViewOutput
    
    let gradient = CAGradientLayer()
    let profileImageView = UIImageView()
    
    let button = UIButton(type: .custom)
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
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
    
    init(output: ConversationsListViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        setupTableView()
        
        output.viewIsReady()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
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
    }
    
    @objc private func reload() {
        output.reloadData()
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
        output.addChannelButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.foregroundColor: theme == Theme.dark ? UIColor.white : UIColor.black]
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

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            self?.output.channelDeleted(at: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.channelDidSelect(at: indexPath)
        tabBarController?.tabBar.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

extension ConversationsListViewController: ConversationsListViewInput {
    func applySnapshot(with channels: [ChannelModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChannelModel>()
        snapshot.appendSections([.online])
        
        snapshot.appendItems(channels.reversed(), toSection: .online)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func stopRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }
    
    func changeTheme(theme: Theme) {
        self.theme = theme
        let themeColors = theme == Theme.dark ? darkTheme : lightTheme
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeColors["textColor"] ?? .black]
        tableView.backgroundColor = themeColors["backgroundColor"]
        view.backgroundColor = themeColors["backgroundColor"]
        
        UILabel.appearance(whenContainedInInstancesOf: [
            UITableViewHeaderFooterView.self
        ]).textColor = themeColors["secondaryTextColor"]
        
        tableView.reloadData()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Create Channel", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter channel name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let channelName = alertController.textFields?[0].text, !channelName.isEmpty else {
                return
            }
            self?.output.addChannel(name: channelName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
