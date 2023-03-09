//
//  SceneDelegate.swift
//  Todoey
//
//  Created by Anelya Kabyltayeva on 08.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let widnowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: widnowScene.coordinateSpace.bounds)
        window?.windowScene = widnowScene
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: SectionViewController())
        
    }

}

