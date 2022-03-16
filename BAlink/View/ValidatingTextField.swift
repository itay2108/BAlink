//
//  ValidatingTextField.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit

class ValidatingTextField: UITextField {
    
    var type: ValidationType
    
    lazy var errorLabel: UILabel = {
       let label = UILabel()
        label.text = typeValidationGuide()
        label.font = .systemFont(ofSize: 9, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    func setupView() {
        borderStyle = .roundedRect
        backgroundColor = K.colors.backgroundColor
        layer.borderWidth = 2
        layer.borderColor = UIColor.label.cgColor
        roundCorners(.allCorners, radius: 12)
        layer.masksToBounds = false
        
        switch type {
        case .none:
            placeholder = ""
            textContentType = nil
        case .name:
            placeholder = "First Name"
            textContentType = .givenName
            autocapitalizationType = .words
        case .lastname:
            placeholder = "Last Name"
            textContentType = .givenName
            autocapitalizationType = .words
        case .username:
            placeholder = "Username"
            textContentType = .nickname
            autocapitalizationType = .none
        case .password:
            placeholder = "Password"
            textContentType = .givenName
            isSecureTextEntry = true
            textContentType = .newPassword
            autocapitalizationType = .none
        }
        
        addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    func isValid() -> Bool {
        guard let text = self.text else {
            return false
        }
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex())
        return predicate.evaluate(with: text)
    }
    
    private func regex() -> String {
        switch type {
        case .none:
            return ""
        case .name:
            return "^[a-zA-Z,.'-]{1,}+$"
        case .lastname:
            return "^[a-zA-Z,.'-]{1,}+$"
        case .username:
            return "^[a-zA-Z0-9,.'-]{4,16}+$"
        case .password:
            return "^[A-Za-z\\d@$!%*#?&]{6,32}$"
        }
        
    }
    
    private func typeValidationGuide() -> String {
        switch type {
        case .none:
            return ""
        case .name:
            return "Should contain no special characters"
        case .lastname:
            return "Should contain no special characters"
        case .username:
            return "Should contain no special characters (4-16 characters long)"
        case .password:
            return "6-32 characters long"
        }
    }
    
    //textfield & placeholder rects insets

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    init(type: ValidationType = ValidationType.none) {
        self.type = type
        super.init(frame: .zero)
        
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ValidationType {
        case none
        case name
        case lastname
        case username
        case password
    }
}
