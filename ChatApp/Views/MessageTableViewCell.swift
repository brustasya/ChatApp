//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//
import UIKit

final class MessageTableViewCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = MessageCellModel
    static let reuseIdentifier = "MessageCell"
    
    private lazy var isIncoming = false
    private lazy var userId = ""
    private lazy var messageImageView = UIImageView()
    
    private var incomingFirstConstraint: NSLayoutConstraint?
    private var incomingSecondConstraint: NSLayoutConstraint?
    private var outgoingFirstConstraint: NSLayoutConstraint?
    private var outgoingSecondConstraint: NSLayoutConstraint?
    private lazy var theme = Theme.light
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        
        if isIncoming {
            label.textColor = .systemGray
        } else {
            label.textColor = .systemGray3
        }
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    func configureTheme(theme: Theme, userId: String) {
        self.theme = theme
        self.userId = userId
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.message.text
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        dateLabel.text = timeFormatter.string(from: model.message.date)
        isIncoming = model.message.userID != self.userId
        nameLabel.text = nil

        if isIncoming {
            messageLabel.textColor = theme == Theme.dark ? .white : .black
            messageImageView.tintColor = theme == Theme.dark ? UIColor(rgb: "#262628") : UIColor(rgb: "#E9E9EB")
            dateLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
            nameLabel.text = model.message.userName
        } else {
            messageLabel.textColor = .white
            messageImageView.tintColor = UIColor(rgb: "#448AF7")
            dateLabel.textColor = .systemGray3
        }
        
        guard let image = UIImage(named: isIncoming ? theme == Theme.dark ? "darkReceived" : "received" : "sent") else { return }
        messageImageView.image = image.resizableImage(
            withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
            resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
        
        contentView.backgroundColor = theme == Theme.dark ? .black : .white
        
        setupMessagesConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(messageLabel)
        if isIncoming {
            messageImageView.tintColor = UIColor(rgb: "#E9E9EB")
        } else {
            messageImageView.tintColor = UIColor(rgb: "#448AF7")
        }
        
        guard let image = UIImage(named: isIncoming ? "received" : "sent") else { return }
        
        messageImageView.addSubview(messageLabel)
        messageImageView.image = image.resizableImage(
            withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
            resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        
        incomingFirstConstraint = messageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        incomingSecondConstraint = messageImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -85)
        outgoingFirstConstraint = messageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        outgoingSecondConstraint = messageImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 85)
        
        setupMessageImageView()
        setupMessageLabel()
        setupDateLabel()
        setupNameLabel()
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
    }
    
    private func setupDateLabel() {
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: -6),
            dateLabel.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupMessagesConstraints() {
        if isIncoming {
            incomingFirstConstraint?.isActive = true
            incomingSecondConstraint?.isActive = true
            outgoingFirstConstraint?.isActive = false
            outgoingSecondConstraint?.isActive = false
        } else {
            incomingFirstConstraint?.isActive = false
            incomingSecondConstraint?.isActive = false
            outgoingFirstConstraint?.isActive = true
            outgoingSecondConstraint?.isActive = true
        }
    }
    
    private func setupMessageImageView() {
        NSLayoutConstraint.activate([
            messageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageImageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -6),
            messageImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            messageImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 60),
            messageImageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6)
        ])
        
        setupMessagesConstraints()
    }
    
    private func setupMessageLabel() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}
