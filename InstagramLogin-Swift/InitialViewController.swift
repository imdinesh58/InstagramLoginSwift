//
//  InitialViewController.swift
//  InstagramLogin-Swift
//
//  Created by Apple-1 on 8/11/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "AccessToken")
        if accessToken == nil || accessToken?.isEmpty == true || accessToken == "" {
            print(" No TOKEN Stay in sign in ||||||  ")
        } else{
            print(" TOKEN is Already there ... so go directly to DASHBOARD ||||||  ")
            self.SwitchScreen()
        }
        // Do any additional setup after loading the view.
    }
    
    func SwitchScreen() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
