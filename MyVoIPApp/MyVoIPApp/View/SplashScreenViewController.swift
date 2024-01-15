//
//  SplashScreenViewController.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import UIKit
import Combine

class SplashScreenViewController: UIViewController, UIViewControllerProtocol {
    private var splashScreenViewModel: SplashScreenViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    init(container: DependencyContainer = DependencyContainer.shared) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.splashScreenViewModel = self.container.splashScreenViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        
        // Obvserve shouldShowLogin changes
        splashScreenViewModel.$shouldShowLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShowLogin in
                if shouldShowLogin {
                    // Show the LoginViewController
                    let loginViewController = LoginViewController(viewModel: self!.container.loginViewModel)
                    navigationController.setViewControllers([loginViewController], animated: true)
                } else {
                    // Show the UserListViewController
                    let userListViewController = UserListViewController(viewModel: self!.container.userListViewModel)
                    navigationController.setViewControllers([userListViewController], animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {}
}
