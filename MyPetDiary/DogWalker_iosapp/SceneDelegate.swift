//
//  SceneDelegate.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2020/12/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var isLogged: Bool = false
    
    // 처음 앱에 접근할 때 최초로 1번 실행하게 됨
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Main.storyboard 가져오기

        if UserDefaults.standard.string(forKey: "token") != nil { // 기록이 있을 때
            isLogged = true
        } else { // 기록이 없을 때
            isLogged = false
        }
        
                
        if isLogged == false {
            // 로그인 안된 상태
            guard let pageVC = storyboard.instantiateViewController(withIdentifier: "PageView") as? PageViewController else { return }
            window?.rootViewController = pageVC
        } else {
            // 로그인 된 상태
            guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainView") as? MPMainViewController else { return }
            window?.rootViewController = mainVC
        }
    }
    
    func changeRootViewController (_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
        
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is#imageLiteral(resourceName: "simulator_screenshot_BB2368D6-57BD-4A81-888D-C44584861E94.png") discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

