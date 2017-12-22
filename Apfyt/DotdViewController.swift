//
//  DotdViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 3/9/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit

class DotdViewController: UIViewController {

    @IBOutlet weak var dealImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dealImage.image = #imageLiteral(resourceName: "Deal-Church's")

        // Do any additional setup after loading the view.
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
