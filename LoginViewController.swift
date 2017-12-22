//
//  LoginViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 3/16/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if true {
//            self.performSegue(withIdentifier: "showNew", sender: self)
//            
//        }

        
        //        let loginButton = FBSDKLoginButton(readPermissions: [ .PublicProfile ])
        //        loginButton.center = view.center
        //        view.addSubview(loginButton)
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
        let token = FBSDKAccessToken.current()
        
        //let token = FBSDKAccessToken.current().tokenString
//        print(token! as String)
//                let parameters: Parameters = [
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

        // Do any additional setup after loading the view.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Whoops, something went wrong...\(error)")
            return
        }
        print("Login successful!")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout successful!")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
