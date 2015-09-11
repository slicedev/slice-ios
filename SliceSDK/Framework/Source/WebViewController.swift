//
//  WebViewController.swift
//  Unroll
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView = {
        let webView = WKWebView()
        webView.hidden = true
        return webView
    } ()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.color = UIColor.grayColor()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    } ()
    
    var webURL: NSURL! {
        set {
            webRequest = NSURLRequest(URL: newValue)
        }
        get {
            return webRequest.URL
        }
    }
    
    var webRequest: NSURLRequest! {
        didSet {
            reloadWebView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        reloadWebView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.bounds
        let center = CGPoint(x: floor(view.bounds.width * 0.5), y: floor(view.bounds.size.height * 0.4))
        activityIndicator.center = center
    }
    
    func reloadWebView() {
        webView.loadRequest(webRequest)
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        webView.hidden = false
        activityIndicator.stopAnimating()
    }
}
