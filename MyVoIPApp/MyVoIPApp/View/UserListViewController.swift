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
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
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
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor.white
        
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        if let username = viewModel.fetchUserName() {
            nameLabel.text = "Hi \(username)"
        }
        
        view.addSubview(tableView)
        
        // Configure the layout constraints for the table view
        setupTableView()

    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.users.count {
            let user = viewModel.users[indexPath.row]!
            viewModel.callUser(user)
        }
    }
}
