//
//  GetCoins.swift
//  InstagramLogin-Swift
//
//  Created by Apple-1 on 8/22/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit
import LIHAlert
import Alamofire
import SwiftyJSON

class GetCoins: UIViewController {
    
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var segControlChange: UISegmentedControl!
    @IBOutlet weak var alert1: UILabel!
    @IBOutlet weak var alert2: UILabel!
    @IBOutlet weak var RandomPersons: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var textAlert: LIHAlert?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skip?.layer.masksToBounds = false
        self.skip?.clipsToBounds = true
        self.skip?.layer.cornerRadius = 7.0
        self.skip?.layer.borderWidth = 0.1
        self.like?.layer.masksToBounds = false
        self.like?.clipsToBounds = true
        self.like?.layer.cornerRadius = 7.0
        self.like?.layer.borderWidth = 0.1
        alert1.isHidden = true
        alert2.isHidden = true
        // Do any additional setup after loading the view.
        self.textAlert = LIHAlertManager.getTextAlert(message: "Reported Successfully")
        self.textAlert?.initAlert(self.view)
        
        var array = ["Nir","anand.23.91"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        GETRandomUsers(sendString: array[randomIndex])
    }
    
    @IBAction func SKIP() {
        var array = ["Nir","anand.23.91"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        GETRandomUsers(sendString: array[randomIndex])
    }
    
    @IBAction func LIKEClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createCircle"), object: nil)
        var array = ["Nir","anand.23.91"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        GETRandomUsers(sendString: array[randomIndex])
        switch(self.segControlChange.selectedSegmentIndex){
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "testObserver"), object: nil)
            break
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "testObserver2"), object: nil)
            break
        default:
            break
        }
    }
    
    func GETRandomUsers(sendString: String) {
        let defaults = UserDefaults.standard
        let AccessToken = defaults.string(forKey: "AccessToken")
        self.RandomPersons?.image = nil
        self.username?.text = nil
        Alamofire.request("https://api.instagram.com/v1/users/search?q=\(sendString)&access_token=" + AccessToken!, method: .get, parameters: [:], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json"]).responseString {
            response in
            switch response.result {
            case .success(let value):
                //print(" Success " , value)
                let strData = String(describing: value).data(using: String.Encoding.utf8)
                let jsonArray = JSON(strData!)
                
                for (_, dict) in jsonArray["data"] {
                    let thisObject = dict["username"].stringValue
                    self.username?.text = thisObject
                    let thisObject2 = dict["profile_picture"].stringValue
                    let data = NSData(contentsOf: NSURL(string: thisObject2)! as URL)
                    if data != nil {
                        self.RandomPersons?.image = UIImage(data: data as! Data)
                        self.RandomPersons?.contentMode = UIViewContentMode.scaleAspectFit
                    }
                }
                
                break
            case .failure(let error):
                print(" failure")
                print(error)
                break
            }
        }
    }
    
    
    @IBAction func reporting() {
        self.textAlert?.show(nil, hidden: nil)
    }
    
    @IBAction func segValueChange() {
        if(segControlChange.selectedSegmentIndex == 0){
            alert1.isHidden = true
            alert2.isHidden = true
            like.setTitle("LIKE +1 Coins", for: .normal)
            var array = ["Nir","anand.23.91"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            GETRandomUsers(sendString: array[randomIndex])
        } else if(segControlChange.selectedSegmentIndex == 1){
            alert1.isHidden = false
            alert2.isHidden = false
            like.setTitle("FOLLOW +4 Coins", for: .normal)
            var array = ["Nir","anand.23.91"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            GETRandomUsers(sendString: array[randomIndex])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
