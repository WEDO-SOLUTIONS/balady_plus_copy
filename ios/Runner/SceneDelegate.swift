//
//  SceneDelegate.swift.swift
//  Runner
//
//  Created by Aleksandr Strizhnev on 14.08.2024.
//

import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)

        let flutterEngine = FlutterEngine(name: "SceneDelegateEngine")
        flutterEngine.run()

        GeneratedPluginRegistrant.register(with: flutterEngine)
        let controller = FlutterViewController.init(engine: flutterEngine, nibName: nil, bundle: nil)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}
