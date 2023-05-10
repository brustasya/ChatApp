//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Станислава on 02.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    internal var output: ProfileViewOutput
    
    private lazy var editButton = UIButton()
    private lazy var profileImageView = UIImageView()
    private lazy var addPhotoButton = UIButton()
    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var backgroundView = UIView()

    private lazy var theme = Theme.light
    private lazy var isShaking = false
    
    private var herbCreator: HerbCreatorProtocol?

    private let lightTheme = [
        "backgroundColor": UIColor.systemGray6,
        "secondaryBackgroundColor": UIColor.white,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    private let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "secondaryBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "secondaryTextColor": UIColor.systemGray5
    ]
    
    init(output: ProfileViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        output.viewIsReady()
        self.herbCreator = HerbCreator(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    private func setupView() {
        setupTitle()
        setupBackgroundView()
        setupImageView()
        setupAddPhotoButton()
        setupNameLabel()
        setupEditButton()
        setupDescriptionLabel()
    }
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = theme == .dark ? .black : .white
        backgroundView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundView.heightAnchor.constraint(equalToConstant: 402)
        ])
    }
    
    private func setupTitle() {
        navigationItem.title = "My Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        editButton.backgroundColor = .systemBlue
        editButton.layer.cornerRadius = 14
        
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])
        
        editButton.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(editButtonPressed(_:)))
        editButton.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func editButtonPressed(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .ended else { return }
        if isShaking {
            isShaking = false
            if let presentationLayer = editButton.layer.presentation() {
                editButton.layer.transform = presentationLayer.transform
                editButton.layer.removeAnimation(forKey: "shake")
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.editButton.transform = .identity
            }, completion: { [weak self] _ in
                self?.editButton.layer.removeAllAnimations()
            })
        } else {
            isShaking = true
            animateShake()
        }
    }
    
    private func animateShake() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = -Double.pi / 10.0
        rotation.toValue = Double.pi / 10.0
        rotation.duration = 0.15
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        rotation.autoreverses = true
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.fromValue = CGPoint(x: view.frame.width / 2 - 5, y: editButton.frame.maxY - editButton.frame.height / 2 - 5)
        translation.toValue = CGPoint(x: view.frame.width / 2 + 5, y: editButton.frame.maxY - editButton.frame.height / 2 + 5)
        translation.duration = 0.15
        translation.autoreverses = true
        translation.isCumulative = true
        translation.repeatCount = Float.infinity
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.autoreverses = true
        group.animations = [rotation, translation]
        group.repeatCount = Float.infinity
        editButton.layer.add(group, forKey: "shake")
    }
    
    private func setupImageView() {
        profileImageView.accessibilityIdentifier = "profileImageView"
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        profileImageView.layer.cornerRadius = 75
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "avatar")
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.accessibilityIdentifier = "addPhotoButton"
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            addPhotoButton.widthAnchor.constraint(equalToConstant: 81),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22),
            addPhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    private func setupNameLabel() {
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 22.0, weight: .bold)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            nameLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: editButton.topAnchor, constant: -24)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        herbCreator?.start(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        herbCreator?.move(to: location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        herbCreator?.stop()
    }
    
    @objc private func addPhotoButtonTapped() {
        output.addPhotoButtonTapped(with: self)
    }
    
    @objc private func editButtonTapped() {
        output.editButtonTapped(with: self)
    }
}

extension ProfileViewController: ProfileViewInput {
    func updateProfile(with model: UserProfileViewModel) {
        nameLabel.text = model.userName ?? "No name"
        descriptionLabel.text = model.userDescription ?? "No bio specified"
        if let imageData = model.userAvatar {
            profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
    }
    
    func setupTheme(with theme: Theme) {
        let themeColors = theme == Theme.dark ? darkTheme : lightTheme
        view.backgroundColor = themeColors["backgroundColor"]
        backgroundView.backgroundColor = themeColors["secondaryBackgroundColor"]
        nameLabel.textColor = themeColors["textColor"]
        descriptionLabel.textColor = themeColors["secondaryTextColor"]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeColors["textColor"] ?? .black]
    }
}

extension ProfileViewController: ProfileSaveDelegate {
    func profileSaved(with profileModel: UserProfileViewModel) {
        output.update(with: profileModel)
    }
}
