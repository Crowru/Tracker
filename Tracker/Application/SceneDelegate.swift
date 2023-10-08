//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Руслан  on 24.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        var viewController = UIViewController()
        UserDefaultsManager.totalTimesLaunching ?? false ? (viewController = TabBarController()) : (viewController = OnboardingViewController(transitionStyle: .scroll))
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

