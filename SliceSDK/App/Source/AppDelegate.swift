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
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.whiteColor()
        
        dispatchMain(1.0) {
            self.authorize()
        }
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func authorize() {
        let application = UIApplication.sharedApplication()
        sliceClient.authorize(application) { (result, error) in
            self.fetchOrders()
        }
    }
    
    func fetchOrders() {
        sliceClient.resources("orders", parameters: nil) { (resources, error) in
            if let resources = resources as? JSONArray {
                println(resources)
            }
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let handled = sliceClient.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
}
