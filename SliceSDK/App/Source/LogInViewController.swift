//
//  LogInViewController.swift
//  SliceExampleApp
//

import UIKit
import SliceSDK

class LogInViewController: UIViewController {

    var sliceClient: SliceClient!
    
    @IBOutlet var logInButton: UIButton!

    convenience init() {
        self.init(nibName: "LogInViewController", bundle: NSBundle.mainBundle())
    }
    
    override func viewDidLoad() {
        logInButton.addTarget(self, action: "logInButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    func logInButtonTapped(button: UIButton) {
        authorize()
    }
    
    func authorize() {
        let application = UIApplication.sharedApplication()
        sliceClient.authorize(application) { (accessToken, error) in
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
}
