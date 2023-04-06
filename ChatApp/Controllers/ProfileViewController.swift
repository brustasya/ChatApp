//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Станислава on 01.03.2023.
//

import UIKit
import AVFoundation
import Combine

class ProfileViewController: UIViewController {
    internal lazy var titleLabel = UILabel()
    internal lazy var editButton = UIButton()
    internal lazy var closeButton = UIButton()
    internal lazy var profileImageView = UIImageView()
    internal lazy var editProfileImageView = UIImageView()
    internal lazy var addPhotoButton = UIButton()
    internal lazy var nameLabel = UILabel()
    internal lazy var descriptionLabel = UILabel()
    internal lazy var cancelButton = UIButton()
    internal lazy var saveButton = UIButton()
    internal lazy var nameTextField = UITextField()
    internal lazy var nameStackView = UIStackView()
    internal lazy var bioStackView = UIStackView()
    internal lazy var viewNameBackground = UIView()
    internal lazy var viewBioBackground = UIView()
    internal lazy var bioTextField = UITextField()
    internal lazy var bottomSeparator = UIView()
    internal lazy var topSeparator = UIView()
    internal lazy var centerSeparatop = UIView()
        
    internal let pickerController = UIImagePickerController()
    internal lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    internal lazy var isEdittingEnable = false
    internal lazy var theme = Theme.light
    internal lazy var isPhotoEdited = false
    internal lazy var isSaving = false
    
    internal lazy var userProfileDataManager = UserProfileDataManager()
    internal lazy var cancellables = Set<AnyCancellable>()
    
    internal let lightTheme = [
        "backgroundColor": UIColor.white,
        "editBackgroundColor": UIColor.systemGray6,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    internal let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "editBackgroundColor": UIColor.black,
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
        
        userProfileDataManager.loadUserProfile()
            .map { $0?.userName ?? "No name" }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancellables)
        
        userProfileDataManager.loadUserProfile()
            .map { $0?.userName == "No name" ? "" : $0?.userName ?? "" }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameTextField)
            .store(in: &cancellables)
        
        userProfileDataManager.loadUserProfile()
            .map { $0?.userDescription ?? "No bio specified" }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &cancellables)
        
        userProfileDataManager.loadUserProfile()
            .map { $0?.userDescription == "No bio specified" ? "" : $0?.userDescription ?? "" }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: bioTextField)
            .store(in: &cancellables)
        
        userProfileDataManager.loadUserProfile()
            .compactMap { $0?.userAvatar ?? UIImage(named: "avatar")?.pngData() }
            .map { UIImage(data: $0) ?? UIImage(named: "avatar") }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: profileImageView)
            .store(in: &cancellables)
        
        userProfileDataManager.loadUserProfile()
            .compactMap { $0?.userAvatar ?? UIImage(named: "avatar")?.pngData() }
            .map { UIImage(data: $0) ?? UIImage(named: "avatar") }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: editProfileImageView)
            .store(in: &cancellables)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // После установки кнопки на экране, frame меняется
        print(addPhotoButton.frame)
    }
    
    func configure(with profileModel: UserProfileViewModel) {
        nameLabel.text = profileModel.userName ?? "No name"
        descriptionLabel.text = profileModel.userDescription ?? "No bio specified"
        if profileModel.userAvatar == nil {
            profileImageView.image = UIImage(named: "avatar")
        } else {
            profileImageView.image = UIImage(data: profileModel.userAvatar ?? Data())
        }
    }
    
    private func setupView() {
        setupTitle()
        setupCloseButton()
        setupEditButton()
        setupImageView()
        setupAddPhotoButton()
        setupNameLabel()
        setupDescriptionLabel()
        setupCancelButton()
        setupSaveButton()
        setupEditViews()
        setupEditProfileImageView()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor)
        ])
    }
    
    private func setupEditViews() {
        viewNameBackground.backgroundColor = .white
        viewNameBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewNameBackground)
        
        viewBioBackground.backgroundColor = .white
        viewBioBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewBioBackground)
        
        let nameEditLabel = UILabel()
        nameEditLabel.text = "Name"
        nameEditLabel.translatesAutoresizingMaskIntoConstraints = false
        viewNameBackground.addSubview(nameEditLabel)
        
        nameTextField.placeholder = "Enter your name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        nameTextField.isHidden = true
        
        let bioLabel = UILabel()
        bioLabel.text = "Bio"
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        viewBioBackground.addSubview(bioLabel)
        
        bioTextField.placeholder = "Enter your bio"
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioTextField)
        bioTextField.isHidden = true
        
        NSLayoutConstraint.activate([
            viewNameBackground.heightAnchor.constraint(equalToConstant: 44),
            viewNameBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewNameBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewNameBackground.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            
            viewBioBackground.heightAnchor.constraint(equalToConstant: 44),
            viewBioBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBioBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBioBackground.topAnchor.constraint(equalTo: viewNameBackground.bottomAnchor),
            
            nameEditLabel.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor, constant: 16),
            nameEditLabel.widthAnchor.constraint(equalToConstant: 96),
            nameEditLabel.heightAnchor.constraint(equalToConstant: 22),
            nameEditLabel.centerYAnchor.constraint(equalTo: viewNameBackground.centerYAnchor),
            
            bioLabel.leadingAnchor.constraint(equalTo: viewBioBackground.leadingAnchor, constant: 16),
            bioLabel.widthAnchor.constraint(equalToConstant: 96),
            bioLabel.heightAnchor.constraint(equalToConstant: 22),
            bioLabel.centerYAnchor.constraint(equalTo: viewBioBackground.centerYAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameEditLabel.trailingAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 22),
            nameTextField.centerYAnchor.constraint(equalTo: viewNameBackground.centerYAnchor),
            nameTextField.trailingAnchor.constraint(lessThanOrEqualTo: viewNameBackground.trailingAnchor, constant: -36),
            
            bioTextField.leadingAnchor.constraint(equalTo: bioLabel.trailingAnchor, constant: 8),
            bioTextField.heightAnchor.constraint(equalToConstant: 22),
            bioTextField.centerYAnchor.constraint(equalTo: viewBioBackground.centerYAnchor),
            bioTextField.trailingAnchor.constraint(lessThanOrEqualTo: viewBioBackground.trailingAnchor, constant: -36)
        ])
        
        viewNameBackground.isHidden = true
        viewBioBackground.isHidden = true
        
        setupSeparators()
    }
    
    private func setupSeparators() {
        bottomSeparator.backgroundColor = .systemGray5
        topSeparator.backgroundColor = .systemGray5
        centerSeparatop.backgroundColor = .systemGray5
        
        view.addSubview(bottomSeparator)
        view.addSubview(topSeparator)
        view.addSubview(centerSeparatop)
        
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        centerSeparatop.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSeparator.bottomAnchor.constraint(equalTo: viewNameBackground.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            topSeparator.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor),
            
            bottomSeparator.topAnchor.constraint(equalTo: viewBioBackground.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            bottomSeparator.leadingAnchor.constraint(equalTo: viewBioBackground.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: viewBioBackground.trailingAnchor),
            
            centerSeparatop.bottomAnchor.constraint(equalTo: viewNameBackground.bottomAnchor),
            centerSeparatop.heightAnchor.constraint(equalToConstant: 1.5),
            centerSeparatop.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor, constant: 16),
            centerSeparatop.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor)
        ])
        
        bottomSeparator.isHidden = true
        topSeparator.isHidden = true
        centerSeparatop.isHidden = true
    }
    
    func configureUserProfileDataManager(with userProfileDataManager: UserProfileDataManager,
                                         _ cancellables: Set<AnyCancellable>) {
        self.userProfileDataManager = userProfileDataManager
        self.cancellables = cancellables
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        saveButton.addTarget(
            self,
            action: #selector(saveProfileDataButtonTaped),
            for: .touchUpInside
        )
        
        saveButton.isHidden = true
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        cancelButton.addTarget(
            self,
            action: #selector(disableEditMode),
            for: .touchUpInside
        )
        
        cancelButton.isHidden = true
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
        self.theme = theme
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.text = "My Profile"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
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
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
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
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        editButton.addTarget(
            self,
            action: #selector(enableEditMode),
            for: .touchUpInside
        )
    }
    
    internal func changeEditEnable() {
        if isEdittingEnable {
            titleLabel.text = "Edit Profile"
            view.backgroundColor = theme == Theme.dark ? darkTheme["editBackgroundColor"] : lightTheme["editBackgroundColor"]
        } else {
            titleLabel.text = "My Profile"
            view.backgroundColor = theme == Theme.dark ? darkTheme["backgroundColor"] : lightTheme["backgroundColor"]
        }
        closeButton.isHidden = isEdittingEnable
        editButton.isHidden = isEdittingEnable
        nameLabel.isHidden = isEdittingEnable
        descriptionLabel.isHidden = isEdittingEnable
        
        cancelButton.isHidden = !isEdittingEnable
        saveButton.isHidden = !isEdittingEnable
        viewNameBackground.isHidden = !isEdittingEnable
        nameTextField.isHidden = !isEdittingEnable
        viewBioBackground.isHidden = !isEdittingEnable
        bioTextField.isHidden = !isEdittingEnable
        bottomSeparator.isHidden = !isEdittingEnable
        topSeparator.isHidden = !isEdittingEnable
        centerSeparatop.isHidden = !isEdittingEnable
        editProfileImageView.isHidden = !isEdittingEnable
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
    }
    
    private func setupEditProfileImageView() {
        editProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editProfileImageView)
        
        NSLayoutConstraint.activate([
            editProfileImageView.widthAnchor.constraint(equalToConstant: 150),
            editProfileImageView.heightAnchor.constraint(equalToConstant: 150),
            editProfileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 49),
            editProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        editProfileImageView.layer.cornerRadius = 75
        editProfileImageView.clipsToBounds = true
        editProfileImageView.isHidden = true
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
        
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
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
