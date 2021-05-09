//
//  SceneDelegate.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit
import Firebase
import AppTrackingTransparency

//#warning("如果需要使用广告打开注释if isAd 的注释")
//if isAd
import GoogleMobileAds
import AdSupport
//import BUAdSDK


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
//    if isAd
    var appOpenAd: GADAppOpenAd?
    var loadTime: Date?
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                if status == .authorized {
                    isAd = true
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["4c2021a391e40ebff7169876972939a7"]
                }else {
                    isAd = false
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

        //7天后会显示启动广告
        let beginTime = UserDefaults.standard.object(forKey: AdShowOrNotKey)
        if beginTime == nil {
            UserDefaults.standard.set(Date(), forKey: AdShowOrNotKey)
            UserDefaults.standard.synchronize()
        }
        
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
        tryToPresentAd()
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
    
//    if isAd
    func requestAppOpenAd(){
        appOpenAd = nil
        GADAppOpenAd.load(withAdUnitID: AdMobAdOpenID, request: GADRequest(), orientation: .portrait) { (openAd, error) in
            if error != nil{
                return
            }
            self.appOpenAd = openAd
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
        }
    }

    func tryToPresentAd(){
        if appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(n: 4) {
            let rootVC = window?.rootViewController
            appOpenAd?.present(fromRootViewController: rootVC!)
        }else{
            requestAppOpenAd()
        }
    }

    func wasLoadTimeLessThanNHoursAgo(n: Int) -> Bool{
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(loadTime ?? Date())
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return Int(intervalInHours) < n
    }


}

//if isAd
extension SceneDelegate : GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        requestAppOpenAd()
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
    }
}

