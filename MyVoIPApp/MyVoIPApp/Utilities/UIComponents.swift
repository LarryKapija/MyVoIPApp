//
//  UIComponents.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 18/1/24.
//

import UIKit

extension UIButton {
    static func roundedButton() -> UIButton  {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.white
        button.setRoundedButtonRadious(32.5)
        button.layer.borderWidth = 5.5
        button.layer.borderWidth = 5.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setRoundedButtonRadious(_ r: CGFloat) {
        self.layer.cornerRadius = r
        self.heightAnchor.constraint(equalToConstant: r * 2).isActive = true
        self.widthAnchor.constraint(equalToConstant: r * 2).isActive = true
    }
    
    func setEmoji(_ emoji: String, size: CGFloat = 20) {
         self.titleLabel?.font = UIFont.systemFont(ofSize: size)
         self.setTitle(emoji, for: .normal)
         self.setTitleColor(.black, for: .normal)
         self.setTitleColor(.gray, for: .highlighted)
     }
}
