//
//  AppDelegate.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var selectedLanguageID = Int()
    var selectedProjectID = Int()
    var selectedFormID = Int()
    var selectedForm: ModelUserRole?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        DataManager.createcopy()
        SVProgressHUD.setDefaultMaskType(.custom)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func setSyncScreen() {
        var nav = UINavigationController()
        if UserDefaults.kLastAsyncDate == "" || UserDefaults.kLastAsyncDate != Date().getFormattedString(format: "dd-MM-yyyy"){
            if DataManager.getAllAsyncFromList().count == 0 {
                nav = UINavigationController(rootViewController: SyncServerVC())
            }
            else {
                nav = UINavigationController(rootViewController: PendingSyncFormScreenVC())
            }
        }
        else {
            nav = UINavigationController(rootViewController: LanguageSelectionVC())
        }
//        nav = UINavigationController(rootViewController: SyncServerVC())
        nav.isToolbarHidden = true
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func setLogInScreen() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogInVC") as? LogInVC {
            let nav = UINavigationController(rootViewController: vc)
            nav.isToolbarHidden = true
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
    }
}
//9925036660
