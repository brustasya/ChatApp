//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

class ConversationsViewController: UIViewController {
    private var output: ConversationViewOutput
    private lazy var theme = Theme.light
    private lazy var userId = ""
    private lazy var dataSource = makeDataSource()

    private let tableView = UITableView()
    private lazy var toolbar = UIView()
    private lazy var nameLabel = UILabel()
    private lazy var messageInputTextView = UITextField()
    private lazy var sendButton = UIButton()
    let avatarImageView = UIImageView()
    
    private let lightTheme = [
        "backgroundColor": UIColor.white,
        "tableViewBackgroundColor": UIColor.white,
        "textColor": UIColor.black,
        "navbarBackgroundColor": #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1),
        "borderColor": UIColor.gray,
        "secondaryTextColor": UIColor.gray
    ]

    private let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "tableViewBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "navbarBackgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "borderColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray5
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
    
    init(output: ConversationViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                
        setupNavBar()
        setupTableView()
        setupToolBar()
        
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    private func setupToolBar() {
        view.addSubview(toolbar)
        
        toolbar.layer.cornerRadius = 20
        toolbar.layer.masksToBounds = true
        toolbar.layer.borderWidth = 1.0
        toolbar.layer.borderColor = UIColor.lightGray.cgColor
        
        messageInputTextView.font = UIFont.systemFont(ofSize: 16)
        messageInputTextView.placeholder = "Type message"
        messageInputTextView.delegate = self
       
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfiguration), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toolbar.addSubview(messageInputTextView)
        toolbar.addSubview(sendButton)

        toolbar.frame = CGRect(x: 8, y: view.frame.height - 72, width: view.frame.width - 16, height: 36)
        messageInputTextView.frame = CGRect(x: 16, y: 1, width: toolbar.frame.width - 52, height: 34)
        sendButton.frame = CGRect(x: toolbar.frame.width - 38, y: 3, width: 30, height: 30)

        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                  as? NSValue)?.cgRectValue.size else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.toolbar.frame.origin.y = self.view.frame.size.height - keyboardSize.height - self.toolbar.frame.size.height - 8
            self.tableView.frame.origin.y = self.view.frame.size.height - keyboardSize.height -
            self.tableView.frame.size.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.toolbar.frame.origin.y = self.view.frame.height - 72
            self.tableView.frame.origin.y = self.customNavigationBar.frame.maxY
        }
    }
    
    @objc func sendButtonTapped() {
        output.sendMessage(with: messageInputTextView.text ?? "")
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(customNavigationBar)
        
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        avatarImageView.backgroundColor = .gray
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textAlignment = .center
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
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    @objc private func goBack() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: false)

    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = dataSource
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.frame = CGRect(x: 0, y: customNavigationBar.frame.maxY, width: view.frame.width,
                                 height: view.frame.height - customNavigationBar.frame.maxY - 72)
        
        let headerView = tableView.tableHeaderView
        let footerView = tableView.tableFooterView
        tableView.tableHeaderView = footerView
        tableView.tableFooterView = headerView
        
    }
    
    private func makeDataSource() -> DataSourceForConversation {
        let dataSource = DataSourceForConversation(tableView: tableView) { [weak self] tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as? MessageTableViewCell else {
                fatalError("Cannot create MessageCell")
            }
            cell.configureTheme(theme: self?.theme ?? Theme.light, userId: self?.userId ?? "")
            cell.configure(with: model)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        }
        return dataSource
    }
}

final class DataSourceForConversation: UITableViewDiffableDataSource<Date, MessageModel> {
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self.snapshot().sectionIdentifiers[section])
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
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else {
            return
        }
        footer.textLabel?.textAlignment = .center
        footer.textLabel?.font = .systemFont(ofSize: 11)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.transform = CGAffineTransform(rotationAngle: .pi)

        return headerView
    }
}

extension ConversationsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == messageInputTextView {
            if tableView.numberOfSections != 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}

extension ConversationsViewController: ConversationViewInput {
    func update(with messages: [MessageModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Date, MessageModel>()
        
        let groupedMessages = Dictionary(grouping: messages, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedGroupedMessages = groupedMessages.sorted { $0.key > $1.key }
        let sectionIdentifiers = sortedGroupedMessages.map { $0.key }
        snapshot.appendSections(sectionIdentifiers)
        
        for sectionIdentifier in sectionIdentifiers {
            let messageCellModels = sortedGroupedMessages.first(where: { $0.key == sectionIdentifier })?.value ?? []
            snapshot.appendItems(messageCellModels, toSection: sectionIdentifier)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func changeTheme(_ theme: Theme) {
        self.theme = theme
        let themeColors = theme == Theme.dark ? darkTheme : lightTheme
        
        tableView.backgroundColor = themeColors["tableViewBackgroundColor"]
        view.backgroundColor = themeColors["tableViewBackgroundColor"]
        toolbar.backgroundColor = themeColors["backgroundColor"]
        messageInputTextView.backgroundColor = themeColors["backgroundColor"]
        messageInputTextView.textColor = themeColors["textColor"]
        customNavigationBar.backgroundColor = themeColors["navbarBackgroundColor"]
        customNavigationBar.layer.borderColor = themeColors["borderColor"]?.cgColor
        nameLabel.textColor = themeColors["textColor"]
    }
    
    func clearMessageTextField() {
        messageInputTextView.text = ""
    }
    
    func setupUserId(userId: String) {
        self.userId = userId
    }
    
    func setupNavigationBarContent(logoURL: String, name: String) {
        nameLabel.text = name
        
        if let imageUrl = URL(string: logoURL) {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
