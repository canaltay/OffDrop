//
//  Router.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 2.08.2025.
//

import UIKit

final class AppRouter {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let startVC = StartViewController.instantiate()
        let nav = UINavigationController(rootViewController: startVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

