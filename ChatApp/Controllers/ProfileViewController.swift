//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Станислава on 01.03.2023.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    let titleLabel = UILabel()
    let editButton = UIButton()
    let closeButton = UIButton()
    let profileImageView = UIImageView()
    let addPhotoButton = UIButton()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let initialsLabel = UILabel()
    
    let pickerController = UIImagePickerController()
    let gradient = CAGradientLayer()
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        print(addPhotoButton.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(addPhotoButton.frame)
        
        setupView()
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
        gradient.cornerRadius = 75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // После установки кнопки на экране, frame меняется
        print(addPhotoButton.frame)
    }
    
    func configure(whith profileModel: UserProfileViewModel) {
        nameLabel.text = profileModel.userName
        descriptionLabel.text = profileModel.userDescription ?? ""
        if profileModel.userAvatar != nil {
            profileImageView.image = profileModel.userAvatar
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupTitle()
        setupCloseButton()
        setupEditButton()
        setupImageView()
        setupAddPhotoButton()
        setupNameLabel()
        setupDescriptionLabel()
    }
    
    private func changeTheme(_ theme: [String: UIColor]) {
        view.backgroundColor = theme["backgroundColor"]
        titleLabel.textColor = theme["textColor"]
        nameLabel.textColor = theme["textColor"]
        descriptionLabel.textColor = theme["secondaryTextColor"]
    }
    
    func configureTheme(with theme: Theme) {
        if theme == Theme.dark {
            changeTheme(darkTheme)
        } else {
            changeTheme(lightTheme)
        }
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.text = "My Profile"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        closeButton.addTarget(
            self,
            action: #selector(dismissController),
            for: .touchUpInside
        )
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    
    private func setupEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 20),
            editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private func setupImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 49),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        profileImageView.layer.cornerRadius = 75
        profileImageView.clipsToBounds = true
        
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(initialsLabel)
        
        initialsLabel.text = "SJ"
        initialsLabel.textColor = .white
        initialsLabel.font = .rounded(ofSize: 64, weight: .medium)
        initialsLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            initialsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    private func setupAddPhotoButton() {
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
        
        addPhotoButton.addTarget(
            self,
            action: #selector(addPhoto),
            for: .touchUpInside
        )
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            if type == .camera {
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                
                switch cameraAuthorizationStatus {
                case .authorized:
                    // Камера доступна
                    self.present(self.pickerController, animated: true)
                    
                case .notDetermined:
                    // Для запроса доступа к камере
                    AVCaptureDevice.requestAccess(for: .video) { granted in}
                    
                case .restricted, .denied:
                    // Доступ к камере запрещен
                    let alertController = UIAlertController(
                        title: "Доступ к камере запрещен",
                        message: "Разрешите доступ к камере в настройках приложения",
                        preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                    
                    let openSettingsAction = UIAlertAction(title: "Настройки", style: .default) { (action) in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(openSettingsAction)
                    
                    present(alertController, animated: true, completion: nil)
                @unknown default:
                    break
                }
            }
            else {
                self.present(self.pickerController, animated: true)
            }
        }
    }
    
    @objc private func addPhoto() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Сделать фото") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Выбрать из галереи") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(alertController, animated: true)
    }
    
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 22.0, weight: .bold)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
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
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        profileImageView.image = image
        
        initialsLabel.isHidden = true
        gradient.isHidden = true
        
        dismiss(animated: true, completion: nil)
    }
}

