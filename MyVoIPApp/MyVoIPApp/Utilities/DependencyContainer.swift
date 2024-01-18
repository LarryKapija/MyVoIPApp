//
//  DependencyContainer.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import Swinject
import AgoraRtcKit

class DependencyContainer {
    static let shared = DependencyContainer()

    private let container: Container = {
        let container = Container()
        
        // MARK: Services
        container.register(FirebaseService.self) { _ in
            return FirebaseService()
        }
        
        container.register(AgoraService.self) { _ in
            return AgoraService()
        }

        container.register(UserService.self) { _ in
            return UserService(context: CoreDataStack.shared.context)
        }
        
        container.register(CoreDataStack.self) { _ in
            return CoreDataStack.shared
        }.inObjectScope(.container)
        
        // ViewModels
        container.register(LoginViewModel.self) { r in
            return LoginViewModel(
                firebaseService: r.resolve(FirebaseService.self)!,
                userService: r.resolve(UserService.self)!,
                coreDataStack: r.resolve(CoreDataStack.self)!
            )
        }
        
        container.register(UserListViewModel.self) { r in
            return UserListViewModel(
                firebaseService: r.resolve(FirebaseService.self)!,
                userService: r.resolve(UserService.self)!,
                coreDataStack: r.resolve(CoreDataStack.self)!
            )
        }
        
        container.register(SplashScreenViewModel.self) { r in
            return SplashScreenViewModel(userService: r.resolve(UserService.self)!)
        }
        
        container.register(CallViewModel.self) { r in
            return CallViewModel(agoraService: r.resolve(AgoraService.self)!, firebaseService: r.resolve(FirebaseService.self)!)
        }
        
        return container
    }()
    
    // Properties to access Services and ViewModels
    var firebaseService: FirebaseService {
        return container.resolve(FirebaseService.self)!
    }
    
    var agoraService: AgoraService {
        return container.resolve(AgoraService.self)!
    }
    
    var userService: UserService {
        return container.resolve(UserService.self)!
    }
    
    var coreDataStack: CoreDataStack {
        return container.resolve(CoreDataStack.self)!
    }
    
    var loginViewModel: LoginViewModel {
        return container.resolve(LoginViewModel.self)!
    }
    
    var userListViewModel: UserListViewModel {
        return container.resolve(UserListViewModel.self)!
    }
    
    var splashScreenViewModel: SplashScreenViewModel {
        return container.resolve(SplashScreenViewModel.self)!
    }
    
    var callViewModel: CallViewModel {
        return container.resolve(CallViewModel.self)!
    }
}
