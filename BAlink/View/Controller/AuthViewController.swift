//
//  AuthViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    enum AuthState {
        case signIn
        case signUp
    }
    
    let def = UserDefaults.standard

    private var authState: AuthState = UserDefaults.standard.bool(forKey: K.userDefaultKeys.didEverAuthorize) ? .signIn : .signUp {
        didSet {
            updateUIAccordingToAuthState()
        }
    }
    
    private lazy var viewModel = AuthViewModel()
    
    //MARK: - UI Views
    
    private lazy var mainLogo: UIImageView = {
       let view = UIImageView()
        view.image = K.images.logotype?.withRenderingMode(.alwaysTemplate)
        view.tintColor = K.colors.accentColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = authState == .signUp ? "Nice to meet you!" : "Welcome Back!"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authFormSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 36 * heightModifier
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var firstnameTextField: ValidatingTextField = {
        let textField = ValidatingTextField(type: .name)
        textField.isHidden = authState == .signIn ? true : false
        textField.tag = 0
        return textField
    }()
    
    private lazy var lastnameTextField: ValidatingTextField = {
        let textField = ValidatingTextField(type: .lastname)
        textField.isHidden = authState == .signIn ? true : false
        textField.tag = 1
        return textField
    }()
    
    private lazy var usernameTextField: ValidatingTextField = {
        let textField = ValidatingTextField(type: .username)
        textField.tag = 2
        return textField
    }()
    
    private lazy var passwordTextField: ValidatingTextField = {
        let textField = ValidatingTextField(type: .password)
        textField.tag = 3
        return textField
    }()
    
    private lazy var textFields: [UITextField] = [firstnameTextField, lastnameTextField, usernameTextField, passwordTextField]
    
    private lazy var passwordShowHideButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .label
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.addTarget(self, action: #selector(showHidePasswordButtonPressed(_:)), for: .touchUpInside)
       return button
    }()
    
    private lazy var authButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = authState == .signUp ? "Sign Up" : "Sign In"
        config.titlePadding = 12 * widthModifier
        config.baseBackgroundColor = K.colors.accentColor
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.addTarget(self, action: #selector(handleAuthButtonTapped(_:)), for: .touchUpInside)
        
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        return button
    }()
    
    private lazy var changeAuthStateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11)
        button.setTitle(authState == .signUp ? "Already have an account? Login Instead" : "First time? Create an accountlink", for: .normal)
        
        button.addTarget(self, action: #selector(handleChangeAuthStateButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .label
        return indicator
    }()
    
    //MARK: - Life Cycle Methods


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        viewModel.delegate = self
        firstnameTextField.delegate = self; lastnameTextField.delegate = self; usernameTextField.delegate = self; passwordTextField.delegate = self

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.delegate = nil
        firstnameTextField.delegate = nil; lastnameTextField.delegate = nil; usernameTextField.delegate = nil; passwordTextField.delegate = nil

    }
    
    //MARK: - UI Methods
    
    private func setUpUI() {
        self.view.backgroundColor = K.colors.backgroundColor
        self.setupToHideKeyboardOnTapOnView()
        
        addSubviews()
        setConstraints()
    }

    private func addSubviews() {
        
        view.addSubview(mainLogo)
        view.addSubview(mainTitle)
        
        view.addSubview(authFormSV)
        authFormSV.addArrangedSubview(firstnameTextField)
        authFormSV.addArrangedSubview(lastnameTextField)
        authFormSV.addArrangedSubview(usernameTextField)
        authFormSV.addArrangedSubview(passwordTextField)
        
        passwordTextField.addSubview(passwordShowHideButton)
        
        view.addSubview(activityIndicator)
        view.addSubview(authButton)

        view.addSubview(changeAuthStateButton)
        
    }
    
    private func setConstraints() {
        
        mainLogo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32 * heightModifier)
            make.height.equalTo(24 * widthModifier)
            make.width.equalTo(mainTitle)
            make.centerX.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(mainLogo.snp.bottom).offset(18 * heightModifier)
            make.left.equalToSuperview().offset(64 * widthModifier)
            make.centerX.equalToSuperview()
            make.height.equalTo(mainTitle.font.pointSize.percentage(110))
        }
        
        authFormSV.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(56)
            make.left.equalToSuperview().offset(48 * widthModifier)
            make.right.equalToSuperview().offset(-48 * widthModifier)
            make.height.equalToSuperview().multipliedBy(authState == .signUp ? 0.44 : 0.22)
        }
        
        passwordShowHideButton.snp.makeConstraints { make in
            make.height.equalTo(18 * heightModifier)
            make.width.equalTo(passwordShowHideButton.snp.height)
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField).offset(-12 * widthModifier)
        }
        
        authButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48 * heightModifier)
            make.width.equalTo(authFormSV)
            make.height.equalTo(56 * heightModifier)
            make.centerX.equalToSuperview()
        }
        
        changeAuthStateButton.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.top).offset(-18 * heightModifier)
            make.height.equalTo(18 * heightModifier)
            make.width.equalTo(authButton)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
    
    func updateUIAccordingToAuthState() {
        
        for view in view.subviews { view.alpha = 0 }
        
        mainTitle.text = authState == .signIn ? "Welcome Back" : "Nice to meet you!"
        
        firstnameTextField.isHidden = authState == .signIn ? true : false
        lastnameTextField.isHidden = authState == .signIn ? true : false
        
        authFormSV.snp.remakeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(56)
            make.left.equalToSuperview().offset(48 * widthModifier)
            make.right.equalToSuperview().offset(-48 * widthModifier)
            make.height.equalToSuperview().multipliedBy(authState == .signUp ? 0.44 : 0.22)
        }
        
        changeAuthStateButton.setTitle(authState == .signIn ? "First time? Create an account" : "Already have an account? Login Instead", for: .normal)
        authButton.setTitle(authState == .signIn ? "Login" : "Sign Up", for: .normal)
        
        UIView.animate(withDuration: 0.33) { [unowned self] in
            for view in self.view.subviews {
                view.alpha = 1
            }
        }
        
    }
    
    
    
    //MARK: - button selectors
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAuthButtonTapped(_ button: UIButton) {
        //return if needed textfield content isnt valid for authorization
        guard usernameTextField.isValid(), passwordTextField.isValid() else {
            Vibration.error.vibrate()
            return
        }
        
        if authState == .signUp {
            guard firstnameTextField.isValid(), lastnameTextField.isValid() else {
                Vibration.error.vibrate()
                return
            }
        }
        
        Vibration.soft.vibrate()
        activityIndicator.startAnimating()
        
        switch authState {
        case .signUp:
            
            if let user = viewModel.generateUser(withFirstname: firstnameTextField.text, lastname: lastnameTextField.text, username: usernameTextField.text, password: passwordTextField.text) {
                viewModel.signUp(with: user)
            }

        case .signIn:
            if let credentials = viewModel.generateCredentials(withUsername: usernameTextField.text, password: passwordTextField.text) {
                viewModel.logIn(with: credentials)
            }
        }
    }
    
    @objc private func handleChangeAuthStateButtonTapped(_ button: UIButton) {
        authState = authState == .signUp ? .signIn : .signUp
    }
    
    @objc private func showHidePasswordButtonPressed(_ button: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textfield = textField as? ValidatingTextField else {
            return
        }
        
        //if text is does not pass through type regex, show red border and error label
        if !textfield.isValid() && textfield.text != nil && textfield.text != "" {
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.errorLabel.isHidden = false
        } else {
            textfield.layer.borderColor = UIColor.label.cgColor
            textfield.errorLabel.isHidden = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //pass to next textfield on return (if available)
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
              return false
        }

        return true
    }
}

extension AuthViewController: AuthViewModelDelegate {
    
    func authViewModel(didAuthorizeWithSuccess success: Bool, token: AccessToken?, error: Error?) {
        activityIndicator.stopAnimating()
        
        if success {
            //handle succeful login / sign up
            let destination = MainTabBarController()
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
            //handle login / sign up failure

            let errorAlert = UIAlertController(title: "Authorization Failed", message: error?.localizedDescription ?? "Try again shortly", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
            errorAlert.addAction(dismiss)
            
            present(errorAlert, animated: true)
        }
    }
    
}


