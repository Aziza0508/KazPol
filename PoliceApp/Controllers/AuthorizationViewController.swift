//
//  AuthorizationViewController.swift
//  PoliceApp
//
//  Created by Aziza Gilash on 30.03.2025.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите логин"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.addTarget(AuthorizationViewController.self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, loginButton, statusLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func handleLogin(_ sender: UIButton) {
        let correctUsername = "admin"
        let correctPassword = "1234"

        let enteredUsername = usernameTextField.text ?? ""
        let enteredPassword = passwordTextField.text ?? ""

        if enteredUsername == correctUsername && enteredPassword == correctPassword {
            statusLabel.textColor = .green
            statusLabel.text = "Успешный вход!"
        } else {
            statusLabel.textColor = .red
            statusLabel.text = "Неверный логин или пароль"
        }
    }
}
