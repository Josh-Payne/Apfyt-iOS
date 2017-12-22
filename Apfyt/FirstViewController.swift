//
//  FirstViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 2/13/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit




class FirstViewController: UIViewController, UIScrollViewDelegate /*FBSDKLoginButtonDelegate*/ {

    var dict : NSDictionary!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var Redeem: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
  
    var imageNamesArray = [#imageLiteral(resourceName: "Deal-Church's"), #imageLiteral(resourceName: "Deal-Taco-Bell"), #imageLiteral(resourceName: "Deal-Old-Navy"), #imageLiteral(resourceName: "Deal-Starbucks")]
    
    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var imageOtd = UIImage()
    var imageIndex: NSInteger = 0
    let maxImages = 3
    var dotdID = "ccpng.png"
    
//    @IBAction func btnFBLoginPressed(sender: AnyObject) {
//        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager .logIn(withReadPermissions: ["email"], handler: { (result, error) -> Void in
//            if (error == nil){
//                var fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if(fbloginresult.grantedPermissions.containsObject("email"))
//                {
//                    self.getFBUserData()
//                    fbLoginManager.logOut()
//                }
//            }
//        })
//    }
//    
//    func getFBUserData(){
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    self.dict = result as! NSDictionary
//                    print(result)
//                    print(self.dict)
//                    NSLog(((self.dict.object(forKey: "picture") as AnyObject).object(forKey: "data")? as AnyObject).objectForKey("url") as String)
//                }
//            })
//        }
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
////        let loginButton = FBSDKLoginButton(readPermissions: [ .PublicProfile ])
////        loginButton.center = view.center
////        view.addSubview(loginButton)
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        view.addSubview(loginButton)
//        loginButton.delegate = self
//        
//
//       let token = FBSDKAccessToken.current().tokenString
//        print(token! as String)
//                Alamofire.request("http://www.dev.apfyt.business/media/images/dotd/" + dotdID).downloadProgress(closure: { (progress) in print(progress.fractionCompleted)
//                }).responseData { (response) in
//                    print(response.result)
//
//                    if let data = response.result.value {
////                        self.img.image = UIImage(data: data)!
//                    }
//                    self.img.image = #imageLiteral(resourceName: "Deal-Church's")
//                }
//        let parameters: Parameters = [
//            "access_token": token,
//            ]
//
//
//        Alamofire.request("http://www.dev.apfyt.business/api/rest-auth/facebook/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
//            print(response.result)
//            print("AAAAaaaa")
//
//            if let data = response.result.value {
//                let json = JSON(data)
//                print("JSON: \(json)")
//            }
//        }
//
//
//
//        img.isUserInteractionEnabled = true
//        img.image = imageOtd
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.swiped(_:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        self.view.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(FirstViewController.swiped(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
//        self.view.addGestureRecognizer(swipeLeft)
////
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    func isComplete(request:NSURLRequest, response:HTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
//
//    }
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print("Whoops, something went wrong...\(error)")
//            return
//        }
//        print("Login successful!")
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Logout successful!")
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//
//
//
//
//
//    func swiped(_ gesture: UIGestureRecognizer) {
//
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.right :
//                print("User swiped right")
//                // decrease index first
//                imageIndex -= 1
//                if imageIndex < 0 {
//                    imageIndex = maxImages
//                }
//                img.image = imageNamesArray[imageIndex]
//
//            case UISwipeGestureRecognizerDirection.left:
//                print("User swiped Left")
//                // increase index first
//                imageIndex += 1
//                // check if index is in range
//                if imageIndex > maxImages {
//                    imageIndex = 0
//                }
//                img.image = imageNamesArray[imageIndex]
//            default:
//                break //stops the code/codes nothing.
//            }
//        }
//
//    }
    }
}

