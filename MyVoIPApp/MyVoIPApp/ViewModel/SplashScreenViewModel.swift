//
//  SplashScreenViewModel.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import Combine
import AgoraRtcKit


class SplashScreenViewModel: ObservableObject{
    private let userService: UserService
    
    @Published var shouldShowLogin: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    init(userService: UserService) {
        self.userService = userService

        checkForExistingUser()
    }
    
    func checkForExistingUser() {
        shouldShowLogin = userService.fetchUser() == nil
    }
}
