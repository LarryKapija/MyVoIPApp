//
//  UIViewControllerProtocol.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation

protocol UIViewControllerProtocol {
    func setupUI() -> Void
}

extension UIViewControllerProtocol {
    var container: DependencyContainer {
        return DependencyContainer.shared
    }
}
