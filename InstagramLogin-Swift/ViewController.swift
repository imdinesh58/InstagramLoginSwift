//
//  ViewController.swift
//  InstagramLogin-Swift
//
//  Created by Aman Aggarwal on 2/7/17.
//  Copyright © 2017 ClickApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var coin1: UIButton!
    @IBOutlet weak var coin2: UIButton!
    @IBOutlet weak var profImage_GetFollower: UIImageView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var FiveHunderedCoins: UIButton!
    @IBOutlet weak var initialCoin: UILabel!
    
    @IBAction func buyCoins1(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "popoverId")
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 1000, height: 550)
        let popover = vc.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender as? UIView
        popover.sourceRect = CGRect(x: 0, y: 30, width: 0, height: 0)
        present(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.coin1?.layer.masksToBounds = false
        self.coin1?.clipsToBounds = true
        self.coin1?.layer.cornerRadius = 15.0
        self.coin1?.layer.borderWidth = 0.1
        
        self.FiveHunderedCoins?.layer.masksToBounds = false
        self.FiveHunderedCoins?.clipsToBounds = true
        self.FiveHunderedCoins?.layer.cornerRadius = 5.0
        self.FiveHunderedCoins?.layer.borderWidth = 0.1
        
        self.coin2?.layer.masksToBounds = false
        self.coin2?.clipsToBounds = true
        self.coin2?.layer.cornerRadius = 13.0
        self.coin2?.layer.borderWidth = 0.1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.showLogoutDialog))
        profImgView?.addGestureRecognizer(tap)
        profImgView?.isUserInteractionEnabled = true
        self.GETUserDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.testObserver), name: NSNotification.Name(rawValue: "testObserver"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.testObserver2), name: NSNotification.Name(rawValue: "testObserver2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.createCircle), name: NSNotification.Name(rawValue: "createCircle"), object: nil)
        
        self.GETUserDetails()
        let COINS = defaults.string(forKey: "COINS")
        if COINS == nil || COINS?.isEmpty == true || COINS == "" || COINS == "0" {
            self.initialCoin?.text = "0"
        } else {
            self.initialCoin?.text = COINS
        }
    }

    @IBOutlet weak var circleView: UIView!
    func createCircle(){
        coin2?.isHidden = true
        let bounds = CGRect(x: 0, y: 0, width: 11, height: 11)
        // Create CAShapeLayer
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = circleView.center
        rectShape.cornerRadius = bounds.width / 2
        view.layer.addSublayer(rectShape)
        rectShape.path = UIBezierPath(ovalIn: rectShape.bounds).cgPath
        rectShape.lineWidth = 13 // chnage this to change line width
        let myColor: UIColor = UIColor(red:239.0/255.0, green: 179/255.0, blue:62/255.0, alpha: 1.0)
        rectShape.strokeColor = myColor.cgColor
        rectShape.fillColor = UIColor.clear.cgColor
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 0
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 1
        group.autoreverses = false // use true to bounce it back
        group.repeatCount = 1 // can use the keyword HUGE to repeat forver
        rectShape.add(group, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           self.coin2.isHidden = false
        }
    }
    
    var getText:Int = 0
    func testObserver() {
        getText = Int((self.initialCoin?.text)!)!
        getText += 1
        self.initialCoin?.text = String(getText)
        defaults.set(self.initialCoin?.text, forKey: "COINS")
    }
    
    var getText2:Int = 0
    func testObserver2() {
        getText2 = Int((self.initialCoin?.text)!)!
        getText2 += 4
        self.initialCoin?.text = String(getText2)
        defaults.set(self.initialCoin?.text, forKey: "COINS")
    }
    
    func GETUserDetails() {
        let AccessToken = defaults.string(forKey: "AccessToken")
        Alamofire.request("https://api.instagram.com/v1/users/self/?access_token=" + AccessToken!, method: .get, parameters: [:], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json"]).responseString {
            response in
            
            switch response.result {
            case .success(let value):
                //print("GETUserDetails Success")
                let strData = String(describing: value).data(using: String.Encoding.utf8)
                let jsonArray = JSON(strData!)
                let ImgData =  jsonArray["data"]["profile_picture"].stringValue
                self.profImgView?.image = nil
                
                let data = NSData(contentsOf: NSURL(string: ImgData)! as URL)
                if data != nil {
                    self.profImgView?.image = UIImage(data: data as! Data)
                    self.profImgView?.layer.masksToBounds = false
                    self.profImgView?.clipsToBounds = true
                    self.profImgView?.layer.cornerRadius = 25.0
                    self.profImgView?.layer.borderWidth = 0.1
                    
                    self.username?.text = jsonArray["data"]["full_name"].stringValue
                    self.followers?.text = String(jsonArray["data"]["counts"]["followed_by"].intValue)
                    self.followings?.text = String(jsonArray["data"]["counts"]["follows"].intValue)
                    
                    self.profImage_GetFollower?.image = UIImage(data: data! as Data)
                    self.profImage_GetFollower?.layer.masksToBounds = false
                    self.profImage_GetFollower?.clipsToBounds = true
                    self.profImage_GetFollower?.layer.cornerRadius = 49.0
                    self.profImage_GetFollower?.layer.borderWidth = 0.1
                }
                break
            case .failure(let error):
                print("GETUserDetails failure")
                print(error)
                SwiftSpinner.show(duration: 3.0, title: "Server Failed to load", animated: false)
                break
            }
        }
    }
    
    @IBAction func logoutSettings() {
        for cookie in HTTPCookieStorage.shared.cookies! {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        UserDefaults.standard.synchronize()
        // Removes cache for all responses
        URLCache.shared.removeAllCachedResponses()
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "AccessToken")
        defaults.set("", forKey: "COINS")
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showLogoutDialog() {
        let alert = UIAlertController(title: "", message: "Are you sure to Logout!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                for cookie in HTTPCookieStorage.shared.cookies! {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
                UserDefaults.standard.synchronize()
                // Removes cache for all responses
                URLCache.shared.removeAllCachedResponses()
                let defaults = UserDefaults.standard
                defaults.set("", forKey: "AccessToken")
                defaults.set("", forKey: "COINS")
                OperationQueue.main.addOperation {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                }
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

