//
//  SceneDelegate.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import Firebase
import AppTrackingTransparency

import GoogleMobileAds
import AdSupport

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appOpenAd: GADAppOpenAd?
    var loadTime: Date?
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                if status == .authorized {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    #if DEBUG
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["6099f9a9bb8c55c6764fd3ca18560d50"]
                    #else
                    #endif
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        requestIDFA()
        //谷歌统计
        FirebaseApp.configure()
        
        let isSaveiCloud = UserDefaults.standard.value(forKey: iCloudSwitchKey)
        if isSaveiCloud == nil {
            UserDefaults.standard.setValue(true, forKey: iCloudSwitchKey)
            UserDefaults.standard.synchronize()
        }
        
        let storageObjectLocal = UserDefaults.standard.array(forKey: MyToolSaveKey)
        if storageObjectLocal == nil {
            UserDefaults.standard.setValue([], forKey: MyToolSaveKey)
        }
        
        let tabBarC = TabBarController()
        window?.rootViewController = tabBarC
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
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
