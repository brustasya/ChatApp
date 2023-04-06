//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Станислава on 06.03.2023.
//

import UIKit
import TFSChatTransport

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

class ConversationCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = ChannelModel
    
    // static let reuseIdentifier = "ConversationCell"
    
    private lazy var nameLabel = UILabel()
    private lazy var messageLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var isOnline = false
    private lazy var hasUnreadMessages = false
    private lazy var avatarImageView = UIImageView()
    private lazy var separatorLine = UIView()
    private lazy var theme = Theme.light
    let whiteCircleImageView = UIImageView()
    let greenCircleImageView = UIImageView()
    
    let disclosureImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        separatorLine.backgroundColor = .systemGray5
        contentView.addSubview(separatorLine)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 72).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(disclosureImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 45),
            avatarImageView.widthAnchor.constraint(equalToConstant: 45),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            dateLabel.trailingAnchor.constraint(equalTo: disclosureImageView.leadingAnchor, constant: -14),
            
            disclosureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            disclosureImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 8),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        avatarImageView.layer.cornerRadius = 22.5
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.clipsToBounds = true
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = theme == Theme.dark ? .white : .gray
    }
    
    func configure(with model: ChannelModel) {
        nameLabel.text = model.channel.name == "" ? "No name" : model.channel.name
        messageLabel.text = model.channel.lastMessage ?? "No messages yet"
        
        if let logoURL = model.channel.logoURL,
           let imageUrl = URL(string: logoURL) {
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

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        let now = Date()
        let lastMessageDate = model.channel.lastActivity ?? Date()
        let calendar = Calendar.current
        
        if calendar.compare(lastMessageDate, to: now, toGranularity: .day) == .orderedAscending {
            dateLabel.text = dateFormatter.string(from: lastMessageDate)
        } else {
            dateLabel.text = timeFormatter.string(from: lastMessageDate)
        }
        
        if model.channel.lastActivity == nil {
            dateLabel.text = ""
        }
        
        if messageLabel.text == "No messages yet" {
            messageLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            disclosureImageView.isHidden = true
        } else {
            disclosureImageView.isHidden = false
            messageLabel.font = .systemFont(ofSize: 15)
        }
    }
    
    private func setupGreenCircle() {
        whiteCircleImageView.backgroundColor = .white
        whiteCircleImageView.layer.cornerRadius = 7.5
        whiteCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(whiteCircleImageView)
        
        greenCircleImageView.backgroundColor = .systemGreen
        greenCircleImageView.layer.cornerRadius = 6
        greenCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(greenCircleImageView)
        
        NSLayoutConstraint.activate([
            whiteCircleImageView.heightAnchor.constraint(equalToConstant: 15),
            whiteCircleImageView.widthAnchor.constraint(equalToConstant: 15),
            whiteCircleImageView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            whiteCircleImageView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 31),
            
            greenCircleImageView.heightAnchor.constraint(equalToConstant: 12),
            greenCircleImageView.widthAnchor.constraint(equalToConstant: 12),
            greenCircleImageView.centerYAnchor.constraint(equalTo: whiteCircleImageView.centerYAnchor),
            greenCircleImageView.centerXAnchor.constraint(equalTo: whiteCircleImageView.centerXAnchor)
        ])
    }
    
    func separatorConfigure(with isVisible: Bool) {
        if isVisible {
            separatorLine.isHidden = false
        } else {
            separatorLine.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = theme == Theme.dark ? #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) : .white
        nameLabel.textColor = theme == Theme.dark ? .white : .black
        dateLabel.textColor = theme == Theme.dark ? .systemGray5 : .gray
        disclosureImageView.tintColor = theme == Theme.dark ? .systemGray5 : .lightGray
        avatarImageView.image = UIImage(named: "avatar")
        messageLabel.textColor = theme == Theme.dark ? .white : .gray
    }
    
    func configureTheme(with theme: Theme) {
        self.theme = theme
        contentView.backgroundColor = theme == Theme.dark ? #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) : .white
        nameLabel.textColor = theme == Theme.dark ? .white : .black
        dateLabel.textColor = theme == Theme.dark ? .systemGray5 : .gray
        messageLabel.textColor = theme == Theme.dark ? .white : .gray
        disclosureImageView.tintColor = theme == Theme.dark ? .systemGray5 : .lightGray
    }
    
}
