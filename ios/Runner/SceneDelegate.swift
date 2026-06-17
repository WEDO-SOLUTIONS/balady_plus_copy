//
//  SceneDelegate.swift.swift
//  Runner
//
//  Created by Aleksandr Strizhnev on 14.08.2024.
//

import Foundation
import app_links
import dgis_map

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static var flutterEngine: FlutterEngine?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene, let flutterEngine = Self.flutterEngine else { return }

        if let shortcutItem = connectionOptions.shortcutItem {
            AppIconQuickActionChannel.store(shortcutItem.type)
        }
        
        window = UIWindow(windowScene: windowScene)
        
        FlutterCarPlaySceneDelegate.runApp()
        let controller = FlutterViewController.init(engine: flutterEngine, nibName: nil, bundle: nil)
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        
        for userActivity in connectionOptions.userActivities {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            AppLinks.shared.handleLink(url: context.url)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            AppLinks.shared.handleLink(url: url)
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        // Custom SceneDelegate receives warm-start shortcuts; the quick_actions plugin may not.
        AppIconQuickActionChannel.store(shortcutItem.type)
        completionHandler(true)
    }
}
