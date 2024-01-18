//
//  UserListViewController.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class UserListViewController: UIViewController, UIViewControllerProtocol {

    private var currentUser: UserEntity?
    private var viewModel: UserListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    
    private let joinChannelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 32.5
        button.layer.borderWidth = 5.5
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
        button.widthAnchor.constraint(equalToConstant: 65).isActive = true
        return button
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Join the channel"
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.$users
            .sink { [weak self] users in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.refreshUserList()
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(buttonLabel)
        view.addSubview(joinChannelButton)

        view.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            buttonLabel.bottomAnchor.constraint(equalTo: joinChannelButton.topAnchor, constant: -10),
            buttonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            joinChannelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinChannelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15)

        ])

        if let user = viewModel.fetchUser() {
            self.currentUser = user
            let name = currentUser?.username
            nameLabel.text = "Hi \(name ?? "")"
        }

        titleLabel.text = "Welcome to the \(String.channelName) channel"
        tableView.tableHeaderView = generateTableHeader()
        joinChannelButton.addTarget(self, action: #selector(joinChannelButtonTapped), for: .touchUpInside)

        // Configure the layout constraints for the table view
        setupTableView()
    }
    
    @objc private func joinChannelButtonTapped() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)

        let callViewController = CallViewController(viewModel: self.container.callViewModel, user: currentUser!)
        navigationController.setViewControllers([callViewController], animated: true)
    }

    private func generateTableHeader() -> UIView {
        let custom = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
        custom.addSubview({
            let table = UILabel()
            table.text = "Available users:"
            table.font = UIFont.systemFont(ofSize: 18)
            return table
        }())
        return custom
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        if indexPath.row < viewModel.users.count {
            let user = viewModel.users[indexPath.row]
            cell.textLabel?.text = user?.username
            return cell
        }
        
        cell.textLabel?.text = nil
        return cell
    }
}
