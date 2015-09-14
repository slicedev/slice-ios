//
//  AppDelegate.swift
//  SliceExampleApp
//

import UIKit
import SliceSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var sliceClient: SliceClient!
    let clientID = ""
    let clientSecret = ""
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let settings = SliceSettings(clientID: clientID, clientSecret: clientSecret)
        sliceClient = SliceClient(settings: settings)
        
        let logInViewController = LogInViewController()
        logInViewController.sliceClient = sliceClient
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = logInViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let handled = sliceClient.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
}
