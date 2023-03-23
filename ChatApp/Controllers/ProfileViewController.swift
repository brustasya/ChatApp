//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Станислава on 01.03.2023.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    private lazy var titleLabel = UILabel()
    private lazy var editButton = UIButton()
    private lazy var closeButton = UIButton()
    private lazy var profileImageView = UIImageView()
    private lazy var addPhotoButton = UIButton()
    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var initialsLabel = UILabel()
    private lazy var cancelButton = UIButton()
    private lazy var choiceConservationButton = UIButton()
    private lazy var saveButton = UIButton()
    private lazy var nameTextField = UITextField()
    private lazy var nameStackView = UIStackView()
    private lazy var bioStackView = UIStackView()
    private lazy var viewNameBackground = UIView()
    private lazy var viewBioBackground = UIView()
    private lazy var bioTextField = UITextField()
    private lazy var bottomSeparator = UIView()
    private lazy var topSeparator = UIView()
    private lazy var centerSeparatop = UIView()
    
    var sucsessShowAlert = true
    
    private let pickerController = UIImagePickerController()
    private let gradient = CAGradientLayer()
    
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private lazy var isEdittingEnable = false
    private lazy var theme = Theme.light
    
    private lazy var isPhotoEdited = false
    private lazy var isSaving = false
    
    private var profileSaver: ProfileSaver?
    
    private let lightTheme = [
        "backgroundColor": UIColor.white,
        "editBackgroundColor": UIColor.systemGray6,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    private let darkTheme = [
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
        setupEditUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.colors = [
            UIColor(rgb: "#F19FB4")?.cgColor ?? UIColor.lightGray.cgColor,
            UIColor(rgb: "EE7B95")?.cgColor ?? UIColor.gray.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.75)
        //profileImageView.layer.addSublayer(gradient)
        gradient.frame = profileImageView.bounds
        gradient.cornerRadius = 75
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
            profileImageView.image = profileModel.userAvatar
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
    }
    
    private func setupEditUI() {
        setupChoiceConservationButton()
        setupCancelButton()
        setupSaveButton()
        setupEditViews()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: choiceConservationButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: choiceConservationButton.centerXAnchor)
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
            centerSeparatop.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor),
        ])
        
        bottomSeparator.isHidden = true
        topSeparator.isHidden = true
        centerSeparatop.isHidden = true
    }
    
    private func setupChoiceConservationButton() {
        choiceConservationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(choiceConservationButton)
        
        choiceConservationButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        
        NSLayoutConstraint.activate([
            choiceConservationButton.heightAnchor.constraint(equalToConstant: 20),
            choiceConservationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            choiceConservationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        choiceConservationButton.isHidden = true
        
        let saveGCDAction = UIAction(title: "Save GCD", identifier: nil) { [weak self] _ in
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let profileSaver = GCDProfileSaver(profileDirectory: documentsDirectory)
            self?.profileSaver = profileSaver
            self?.saveProfileData(profileSaver)
        }
        
        let saveOperationsAction = UIAction(title: "Save Operations", identifier: nil) { [weak self] _ in
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let profileSaver = OperationProfileSaver(profileDirectory: documentsDirectory)
            self?.profileSaver = profileSaver
            self?.saveProfileData(profileSaver)
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: [saveGCDAction, saveOperationsAction])
        
        choiceConservationButton.showsMenuAsPrimaryAction = true
        choiceConservationButton.menu = menu
    }
    
    private func saveProfileData(_ profileSaver: ProfileSaver) {
        nameTextField.isEnabled = false
        bioTextField.isEnabled = false
        
        choiceConservationButton.isHidden = true
        activityIndicatorView.startAnimating()
        
        isSaving = true
        sucsessShowAlert = true
        
        let isPhotoEdit = isPhotoEdited
        let isNameEdit = nameLabel.text != nameTextField.text &&
        !(nameLabel.text == "No name" && nameTextField.text == "")
        let isBioEdit = descriptionLabel.text != bioTextField.text &&
        !(descriptionLabel.text == "No bio specified" && bioTextField.text == "")
        
        var saveCount = 0
        
        if isNameEdit {
            let savedString = nameTextField.text == "" ? "No name" : nameTextField.text
            profileSaver.saveUsername(savedString ?? "No name") { [weak self] success in
                if success {
                    saveCount += 1
                    self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                    print("Username saved successfully")
                } else {
                    self?.sucsessShowAlert = false
                    saveCount += 1
                    self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                    print("Failed to save username")
                }
            }
        } else {
            saveCount += 1
        }
        
        if isBioEdit {
            let savedString = bioTextField.text == "" ? "No bio specified" : bioTextField.text
            profileSaver.saveDescription(savedString ?? "No bio specified") { [weak self] success in
                if success {
                    saveCount += 1
                    self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                    print("Description saved successfully")
                } else {
                    self?.sucsessShowAlert = false
                    saveCount += 1
                    self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                    print("Failed to save description")
                }
            }
        } else {
            saveCount += 1
        }
        
        if isPhotoEdit {
            if let image = self.profileImageView.image {
                profileSaver.saveImage(image) { [weak self] success in
                    if success {
                        saveCount += 1
                        self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                        print("Image saved successfully")
                    } else {
                        self?.sucsessShowAlert = false
                        saveCount += 1
                        self?.checkSaveCount(saveCount, profileSaver: profileSaver)
                        print("Failed to save image")
                    }
                }
            } else {
                print("Profile image is nil")
            }
        } else {
            saveCount += 1
        }
        
        if !isBioEdit && !isNameEdit && !isPhotoEdit {
            showAlert(profileSaver: profileSaver)
        }
    }
    
    private func checkSaveCount(_ saveCount: Int, profileSaver: ProfileSaver) {
        if saveCount == 3 {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.showAlert(profileSaver: profileSaver)
            }
        }
    }
    
    private func showAlert(profileSaver: ProfileSaver) {
        isSaving = false
        
        nameTextField.isEnabled = true
        bioTextField.isEnabled = true
        
        choiceConservationButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if sucsessShowAlert {
            let alertController = UIAlertController(title: "Success", message: "You are breathtaking", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                self?.disableEditMode()
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Could not save profile", message: "Try again", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                self?.disableEditMode()
            }
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] (_) in
                self?.saveProfileData(profileSaver)
            }
            
            alertController.addAction(okAction)
            alertController.addAction(tryAgainAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
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
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        cancelButton.addTarget(
            self,
            action: #selector(disableEditMode),
            for: .touchUpInside
        )
        
        cancelButton.isHidden = true
    }
    
    @objc private func saveProfileDataButtonTaped() {
        
    }
    
    @objc private func disableEditMode() {
        if isSaving {
            profileSaver?.cancel()
        }
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let profileSaver = GCDProfileSaver(profileDirectory: documentsDirectory)
        
        var userName: String?
        var userDectription: String?
        var userAvatar: UIImage?
        
        profileSaver.loadUserName { [weak self] name in
            userName = name
            
            profileSaver.loadDescription { [weak self] description in
                userDectription = description
                
                profileSaver.loadImage { [weak self] image in
                    userAvatar = image
                    
                    self?.configure(with: UserProfileViewModel(
                        userName: userName,
                        userDescription: userDectription,
                        userAvatar: userAvatar
                    ))
                }
            }
        }
        
        isEdittingEnable = false
        isPhotoEdited = false
        changeEditEnable()
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
        
        editButton.addTarget(
            self,
            action: #selector(enableEditMode),
            for: .touchUpInside
        )
    }
    
    @objc private func enableEditMode() {
        if (!isEdittingEnable) {
            nameTextField.text = nameLabel.text == "No name" ? "" : nameLabel.text
            bioTextField.text = descriptionLabel.text == "No bio specified" ? "" : descriptionLabel.text
            isEdittingEnable = true
            changeEditEnable()
            nameTextField.becomeFirstResponder()
        }
    }
    
    private func changeEditEnable() {
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
        choiceConservationButton.isHidden = !isEdittingEnable
        viewNameBackground.isHidden = !isEdittingEnable
        nameTextField.isHidden = !isEdittingEnable
        viewBioBackground.isHidden = !isEdittingEnable
        bioTextField.isHidden = !isEdittingEnable
        bottomSeparator.isHidden = !isEdittingEnable
        topSeparator.isHidden = !isEdittingEnable
        centerSeparatop.isHidden = !isEdittingEnable
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
        //view.addSubview(initialsLabel)
        
        initialsLabel.text = "SJ"
        initialsLabel.textColor = .white
        initialsLabel.font = .rounded(ofSize: 64, weight: .medium)
        initialsLabel.textAlignment = .center
        
        /*NSLayoutConstraint.activate([
         initialsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
         initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
         ])*/
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
        enableEditMode()
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
        isPhotoEdited = true
        
        initialsLabel.isHidden = true
        gradient.isHidden = true
        
        dismiss(animated: true, completion: nil)
    }
}
