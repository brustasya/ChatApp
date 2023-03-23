//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Станислава on 06.03.2023.
//

import UIKit

enum DaySection: Hashable {
    case yesturday
    case today
}

class ConversationsViewController: UIViewController {
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    private lazy var toolbar = UIView()
    private lazy var nameLabel = UILabel()
    private var toolbarBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private lazy var messageInputTextView = UITextView()
    private lazy var theme = Theme.light
    
    private let lightTheme = [
        "backgroundColor": UIColor.white,
        "tableViewBackgroundColor": UIColor.white,
        "textColor": UIColor.black,
        "navbarBackgroundColor": #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1),
        "borderColor": UIColor.gray
    ]

    private let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "tableViewBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "navbarBackgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "borderColor": UIColor.black
    ]
    
    let messageCellModelsToday = [
        MessageCellModel(text: "Hellow!", date: Date(), isIncoming: true),
        MessageCellModel(text: "How are you?", date: Date(), isIncoming: false),
        MessageCellModel(text: "I'm fine! I'm fine! I'm fine! I'm fine! I'm fine!", date: Date(), isIncoming: true)
    ]
    
    let messageCellModelsYesturday = [
        MessageCellModel(text: "Hellow!", date: Date(timeIntervalSinceNow: -84400), isIncoming: true),
        MessageCellModel(text: "Hellow!!", date: Date(timeIntervalSinceNow: -84400), isIncoming: false),
        MessageCellModel(text: "Hellow!!!", date: Date(timeIntervalSinceNow: -84400), isIncoming: true)
    ]
    
    private lazy var customNavigationBar: UINavigationBar = {
        let customNavigationBar = UINavigationBar(
            frame: CGRect(
                x: -1,
                y: 0,
                width: view.frame.width + 1,
                height: 137
            )
        )

        customNavigationBar.layer.borderWidth = 0.5
        
        return customNavigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolBar()
        setupNavBar()
        setupTableView()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    private func setupToolBar() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        
        messageInputTextView.layer.cornerRadius = 20
        messageInputTextView.layer.masksToBounds = true
        messageInputTextView.layer.borderWidth = 1.0
        messageInputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputTextView.font = UIFont.systemFont(ofSize: 16)
        messageInputTextView.isScrollEnabled = false
        messageInputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let sendButton = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfiguration), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        toolbarBottomConstraint.isActive = true
        
        toolbar.addSubview(messageInputTextView)
        toolbar.addSubview(sendButton)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 52),
            
            messageInputTextView.heightAnchor.constraint(equalToConstant: 36),
            messageInputTextView.topAnchor.constraint(equalTo: toolbar.topAnchor, constant: 8),
            messageInputTextView.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 8),
            messageInputTextView.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -8),
            
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.trailingAnchor.constraint(equalTo: messageInputTextView.trailingAnchor, constant: -4),
            sendButton.centerYAnchor.constraint(equalTo: messageInputTextView.centerYAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolbarBottomConstraint.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.toolbarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func sendButtonTapped() {
        
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(customNavigationBar)
        
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .gray
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        nameLabel.text = "Jane"
        nameLabel.font = .systemFont(ofSize: 11)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -44.12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backButton.heightAnchor.constraint(equalToConstant: 22),
            backButton.widthAnchor.constraint(equalToConstant: 12),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -30),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func goBack() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)

    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = dataSource
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
    
    private func makeDataSource() -> DataSourceForConversation {
        let dataSource = DataSourceForConversation(tableView: tableView) { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell else {
                fatalError("Cannot create MessageCell")
            }
            cell.configureTheme(with: self.theme)
            cell.configure(with: model)
            return cell
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<DaySection, MessageCellModel>()
        snapshot.appendSections([.yesturday, .today])
        
        snapshot.appendItems(messageCellModelsYesturday, toSection: .yesturday)
        snapshot.appendItems(messageCellModelsToday, toSection: .today)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func changeTheme(_ theme: [String: UIColor]) {
        tableView.backgroundColor = theme["tableViewBackgroundColor"]
        toolbar.backgroundColor = theme["backgroundColor"]
        messageInputTextView.backgroundColor = theme["backgroundColor"]
        customNavigationBar.backgroundColor = theme["navbarBackgroundColor"]
        customNavigationBar.layer.borderColor = theme["borderColor"]?.cgColor
        nameLabel.textColor = theme["textColor"]
    }
    
    func configure(with theme: Theme) {
        self.theme = theme
        if theme == Theme.dark {
            changeTheme(darkTheme)
        } else {
            changeTheme(lightTheme)
        }
    }
    
}

final class DataSourceForConversation: UITableViewDiffableDataSource<DaySection, MessageCellModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        switch section {
        case 0:            
            return dateFormatter.string(from: Date(timeIntervalSinceNow: -84400))
        case 1:
            return dateFormatter.string(from: Date())
        default:
            return nil
        }
    }
}

// MARK: - UITableViewDelegate

extension ConversationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        33
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.textAlignment = .center
        header.textLabel?.font = .systemFont(ofSize: 11)
    }
}
