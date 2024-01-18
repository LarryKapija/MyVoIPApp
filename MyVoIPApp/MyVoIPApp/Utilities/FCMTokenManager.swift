//
//  UserManager.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 18/1/24.
//

import Foundation

class FCMTokenManager {
    static let shared = FCMTokenManager()
    private init() {} // Hace el inicializador privado para asegurar el patrón singleton

    var fcmToken: String?
}
