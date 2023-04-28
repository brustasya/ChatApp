//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//
import UIKit

final class MessageTableViewCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = MessageModel
    static let reuseIdentifier = "MessageCell"
    
    private lazy var isIncoming = false
    private lazy var userId = ""
    private lazy var messageImageView = UIImageView()
    
    private var incomingConstraint: NSLayoutConstraint?
    private var outgoingConstraint: NSLayoutConstraint?
    private var imageIncomingConstraint: NSLayoutConstraint?
    private var imageOutgoingConstraint: NSLayoutConstraint?
    private var imageTopConstraint: NSLayoutConstraint?
    private var imageBottomConstraint: NSLayoutConstraint?
    private var widthConstaint: NSLayoutConstraint?
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
    
    private lazy var imageDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    private lazy var imageNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    private lazy var imageMessageImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func configureTheme(theme: Theme, userId: String) {
        self.theme = theme
        self.userId = userId
    }
    
    func configure(with model: MessageModel) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        messageLabel.isHidden = true
        dateLabel.text = timeFormatter.string(from: model.date)
        isIncoming = model.userID != self.userId
        nameLabel.text = model.userName
        nameLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        
        contentView.backgroundColor = theme == Theme.dark ? .black : .white
        messageLabel.text = model.text
        
        setupTextMessage()
        
        if let imageUrl = URL(string: model.text) {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.messageLabel.isHidden = false
                    }
                    print("Error loading image: \(error.localizedDescription)")
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageMessageImageView.image = image
                        self?.setupImage()
                    }
                }
            }
            task.resume()
        } else {
            messageLabel.isHidden = false
        }

    }
    
    private func setupImage() {
        messageImageView.addSubview(imageMessageImageView)
        imageMessageImageView.isHidden = false
        NSLayoutConstraint.activate([
            imageMessageImageView.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            imageMessageImageView.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor),
            imageMessageImageView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor),
            imageMessageImageView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor),
            imageMessageImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        imageTopConstraint?.isActive = true
        imageBottomConstraint?.isActive = true
        imageIncomingConstraint?.isActive = true
        imageOutgoingConstraint?.isActive = true
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
        guard let image = UIImage(named: isIncoming ? theme == Theme.dark ? "darkReceived" : "received" : "sent") else { return }
        messageImageView.image = image.resizableImage(
            withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
            resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
        contentView.addSubview(messageLabel)

        messageImageView.addSubview(messageLabel)
        messageImageView.image = image
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        incomingConstraint = messageImageView
        .leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        outgoingConstraint = messageImageView
        .trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        imageTopConstraint = imageMessageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        imageBottomConstraint = imageMessageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        imageIncomingConstraint = imageMessageImageView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor)
        imageOutgoingConstraint = imageMessageImageView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor)
        widthConstaint = messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 3 / 4)

        setupMessageImageView()
        setupDateLabel()
        setupNameLabel()
    }
    
    private func setupTextMessage() {
        widthConstaint?.isActive = true
        if isIncoming {
            messageLabel.textColor = theme == Theme.dark ? .white : .black
            messageImageView.tintColor = theme == Theme.dark ? UIColor(rgb: "#262628") : UIColor(rgb: "#E9E9EB")
            dateLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        } else {
            messageLabel.textColor = .white
            messageImageView.tintColor = UIColor(rgb: "#448AF7")
            dateLabel.textColor = .systemGray3
            nameLabel.text = nil
        }
        
        guard let image = UIImage(named: isIncoming ? theme == Theme.dark ? "darkReceived" : "received" : "sent") else { return }
        messageImageView.image = image.resizableImage(
            withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
            resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
        
        NSLayoutConstraint.activate([
            messageImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            messageImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 50)
        ])
        setupMessagesConstraints()
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: -6),
            dateLabel.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupMessagesConstraints() {
        incomingConstraint?.isActive = isIncoming
        outgoingConstraint?.isActive = !isIncoming
    }
    
    private func setupMessageImageView() {
        contentView.addSubview(messageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 3 / 4),
            messageImageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -6),
            messageImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            messageImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 50),
            messageImageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6)
        ])
        
        setupMessagesConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageMessageImageView.isHidden = true
        incomingConstraint?.isActive = false
        outgoingConstraint?.isActive = false
        imageIncomingConstraint?.isActive = false
        imageOutgoingConstraint?.isActive = false
        imageTopConstraint?.isActive = false
        imageBottomConstraint?.isActive = false
    }
}
