/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Empty application delegate class.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
	var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        let layout = UICollectionViewFlowLayout()
//        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        return true
    }
}

