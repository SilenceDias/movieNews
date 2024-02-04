//
//  ProfileViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 16.01.2024.
//

import UIKit

class ProfileViewController: BaseViewController {
    // MARK: - Properties
    private var loginText: String?
    private var passwordText: String?
    private var networkManager = NetworkManager.shared
    let alertT = UIAlertController(title: "Error", message: "Probabbly your credentials are wrong!", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
    }
    
    // MARK: UI Components
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Profile"
        return view
    }()
    
    private lazy var loginField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Login"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray
        return button
    }()
    
    private let eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        return button
    }()
    
    private let enterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Enter your details"
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        return button
    }()
    
    private let profilePicture: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.image = UIImage(named: "noProfile")
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertT.addAction(OKAction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    // MARK: Methods
    private func setupViews() {
        var isLogged = UserDefaults.standard.bool(forKey: "isLoggedIn")
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tap)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(didTapEye), for: .touchUpInside)
    
        [titleLabel, enterLabel, loginField, passwordField, loginButton].forEach {
            view.addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        enterLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(185)
            make.left.equalToSuperview().inset(16)
        }
        loginField.snp.makeConstraints { make in
            make.top.equalTo(enterLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordField.rightView = eyeButton
        passwordField.rightViewMode = .always
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom).offset(16)
            make.left.right.equalTo(loginField)
        }
            
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        view.addSubview(logoutButton)
        view.addSubview(profilePicture)
        profilePicture.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(400)
            make.width.equalTo(300)
        }
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        profilePicture.isHidden = true
        logoutButton.isHidden = true
        logoutButton.isEnabled = false
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func didTapLogin() {
        showLoader()
        loginText = loginField.text
        passwordText = passwordField.text
        print("Login is: \(loginText) and password: \(passwordText)")
        guard let loginText, let passwordText else {return}
        networkManager.getRequestToken { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData: ValidateAuthenticationModel = .init(
                        username: loginText,
                        password: passwordText,
                        requestToken: dataModel.requestToken)
                    self?.networkManager.validateWithLogin(requestBody: requestData.toDictionary()) { [weak self] result in
                        self?.validateWithLogin(with: requestData)
                    }
                }
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                self?.hideLoader()
                break
            }
        }
    }
    
    private func validateWithLogin(with data: ValidateAuthenticationModel) {
        networkManager.validateWithLogin(requestBody: data.toDictionary()) { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData = ["request_token": dataModel.requestToken]
                    self?.createSession(with: requestData)
                }
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                self?.hideLoader()
                break
            }
        }
    }
    
    private func createSession(with requestBody: [String: Any]) {
        networkManager.createSession(requestBody: requestBody) { [weak self] result in
            switch result {
            case .success(let sessionId):
                print("My sessionId is \(sessionId)")
                self?.changeViews()
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                break
            }
            self?.hideLoader()
        }
    }
    
    @objc private func didTapEye() {
        passwordField.isSecureTextEntry.toggle()
        let image = passwordField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        eyeButton.setImage(image, for: .normal)
    }
    
    private func changeViews(){
        var isLogged = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if !isLogged{
            profilePicture.isHidden = true
            logoutButton.isHidden = true
            logoutButton.isEnabled = false
            enterLabel.isHidden = false
            loginField.isHidden = false
            passwordField.isHidden = false
            loginButton.isHidden = false
        }
        else {
            enterLabel.isHidden = true
            loginField.isHidden = true
            passwordField.isHidden = true
            loginButton.isHidden = true
            profilePicture.isHidden = false
            logoutButton.isHidden = false
            logoutButton.isEnabled = true
        }
    }
    
    @objc private func didTapLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        changeViews()
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profilePicture.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
