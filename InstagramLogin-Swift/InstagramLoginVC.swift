//
//  InstagramLoginVC.swift
//  InstagramLogin-Swift
//
//  Created by Aman Aggarwal on 2/7/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit

class InstagramLoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let accessToken = defaults.string(forKey: "AccessToken")
        if accessToken == nil || accessToken?.isEmpty == true || accessToken == "" {
            print(" No TOKEN Stay in sign in ||||||  ")
            loginWebView.delegate = self
            unSignedRequest()
            loginIndicator.isHidden = false
        } else{
            print(" TOKEN is Already there ... so go directly to DASHBOARD ||||||  ")
            self.SwitchScreen()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
        self.defaults.set(authToken, forKey: "AccessToken")
        self.SwitchScreen()
    }
    
    func SwitchScreen() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
}
