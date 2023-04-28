//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//
import UIKit

// Все комментарии - это попытки отобразить картинки)))

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
        
        dateLabel.text = timeFormatter.string(from: model.date)
        isIncoming = model.userID != self.userId
        nameLabel.text = model.userName
        nameLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        
        contentView.backgroundColor = theme == Theme.dark ? .black : .white
        messageLabel.text = model.text
        
        setupTextMessage()
    }
    
    /*
    func configure(with model: MessageModel, data: Data) {
        imageMessageImageView.image = UIImage(data: data)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        imageDateLabel.text = timeFormatter.string(from: model.date)
        isIncoming = model.userID != self.userId
        imageNameLabel.text = model.userName
        imageNameLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        imageDateLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        setupMessagesConstraints()
        
        contentView.addSubview(imageMessageImageView)
        
        imageIncomingConstraint = imageMessageImageView
        .leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        imageOutgoingConstraint = imageMessageImageView
        .trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        imageTopConstraint = imageMessageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        imageBottomConstraint = imageMessageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            imageMessageImageView.heightAnchor.constraint(equalToConstant: 129),
            imageMessageImageView.widthAnchor.constraint(equalToConstant: 129)
           // imageMessageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
           // imageMessageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        setupImagesConstraints()
    }
    */
    
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
                
        setupMessageImageView()
        setupDateLabel()
        setupNameLabel()
        messageImageView.isHidden = true
    }
    
    private func setupTextMessage() {
        messageLabel.isHidden = false
        messageImageView.isHidden = false
        imageMessageImageView.isHidden = true

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
        
        setupMessagesConstraints()
    }
    
    /*
    private func setupImageMessage() {
        imageMessageImageView.isHidden = false
        messageImageView.isHidden = true
        messageLabel.isHidden = true
        dateLabel.textColor = theme == Theme.dark ? .systemGray2 : .systemGray
        contentView.addSubview(imageMessageImageView)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            imageMessageImageView.heightAnchor.constraint(equalToConstant: 129),
            imageMessageImageView.widthAnchor.constraint(equalToConstant: 129),
            imageMessageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageMessageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: imageMessageImageView.bottomAnchor, constant: 2)
        ])
        
        if isIncoming {
            contentView.addSubview(nameLabel)

            NSLayoutConstraint.activate([
                imageMessageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                nameLabel.bottomAnchor.constraint(equalTo: imageMessageImageView.topAnchor, constant: -1),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
            ])
        } else {
            NSLayoutConstraint.activate([
                imageMessageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
            ])
        }
    }
    */
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
     //   contentView.addSubview(imageNameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
            
           // imageNameLabel.bottomAnchor.constraint(equalTo: imageMessageImageView.topAnchor, constant: -1),
            // imageNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
      //  contentView.addSubview(imageDateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: -6),
            dateLabel.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: -15)
            
          //  imageDateLabel.trailingAnchor.constraint(equalTo: imageMessageImageView.trailingAnchor),
            // imageDateLabel.topAnchor.constraint(equalTo: imageMessageImageView.bottomAnchor, constant: 2)
        ])
    }
    
    private func setupMessagesConstraints() {
        incomingConstraint?.isActive = isIncoming
        outgoingConstraint?.isActive = !isIncoming
    }
    
    /*
    private func setupImagesConstraints() {
        imageIncomingConstraint?.isActive = isIncoming
        imageOutgoingConstraint?.isActive = !isIncoming
        imageTopConstraint?.isActive = true
        imageBottomConstraint?.isActive = true
    }
    */
    
    private func setupMessageImageView() {
        contentView.addSubview(messageImageView)
       // contentView.addSubview(imageMessageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width * 3 / 4),
            messageImageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -6),
            messageImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            messageImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 50),
            messageImageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6)
            
            /* imageMessageImageView.heightAnchor.constraint(equalToConstant: 129),
            imageMessageImageView.widthAnchor.constraint(equalToConstant: 129),
            imageMessageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageMessageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) */
        ])
        
        setupMessagesConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        incomingConstraint?.isActive = false
        outgoingConstraint?.isActive = false
       /* imageIncomingConstraint?.isActive = false
        imageOutgoingConstraint?.isActive = false
        imageTopConstraint?.isActive = false
        imageBottomConstraint?.isActive = false */
    }
}
