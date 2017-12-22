//
//  HealthViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 4/3/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit

class HealthViewController: UIViewController {

    @IBOutlet weak var MainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "healthdata")
        imageView.frame = CGRect(x: 0, y: 0, width: self.MainScrollView.frame.width, height: self.MainScrollView.frame.height * 2)
        MainScrollView.contentSize.height = self.MainScrollView.frame.height * 2
        MainScrollView.addSubview(imageView)
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
