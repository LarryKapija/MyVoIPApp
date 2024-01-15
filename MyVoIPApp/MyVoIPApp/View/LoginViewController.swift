//
//  LoginView.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UIViewControllerProtocol {
    private let viewModel: LoginViewModel
    
    // Create a label for "Log in"
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "Log in"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 24) // Set font size and style
        loginLabel.textAlignment = .center // Center align the text
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        return button
    }()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Add the label to the view
        view.addSubview(loginLabel)
        
        // Add constraints for the label
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Add subviews to the view
        view.addSubview(usernameTextField)
        view.addSubview(loginButton)
        
        // Configure the layout constraints for the subviews
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10).isActive = true // Position below the label
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Additional UI configurations (e.g.,e fonts, colors, etc.) can be added here
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            // Show an alert indicating that the username is required
            return
        }

        // You can call the appropriate ViewModel function here
        viewModel.loginUser(username: username) { [weak self] status in
            switch status {
            case .LoginSucceed, .UserCreated:
                self?.navigateToUserList()
            case .Failed:
                // Show a message
                return
            default:
                return
            }
        }
    }
    
    private func navigateToUserList(){
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        
        let userListViewController = UserListViewController(viewModel: self.container.userListViewModel)
        navigationController.setViewControllers([userListViewController], animated: true)
    }
}
