//
//  RedemptionsViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 2/13/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    let activatedDeals = [#imageLiteral(resourceName: "churchsicon"), #imageLiteral(resourceName: "tacobellicon"), #imageLiteral(resourceName: "oldnavyicon"), #imageLiteral(resourceName: "starbucksicon")]
    let activatedDealsLabels = ["5pc Legs & Thighs Meal - $6", "2wister Tacos - $1.29", "Women's Jeans - $12", "Buy one beverage, get one free"]

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activatedDeals.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTest = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cellTest.textLabel?.text = activatedDealsLabels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.myImage.image = activatedDeals[indexPath.row]
        cell.myLabel.text = activatedDealsLabels[indexPath.row]
//        Alamofire.request("http://127.0.0.1:8000/static/img/logo.png").downloadProgress(closure: { (progress) in print(progress.fractionCompleted)
//        }).responseData { (response) in
//            print(response.result)
//            print(response.result.value)
//            if let data = response.result.value {
//                cell.myImage.image = UIImage(data: data)
//            }
//        }
    

        return (cell)
    }
    let destination = DotdViewController()
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(destination, animated: true)
    }
     // Your destination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadJson() {
        Alamofire.request("http://127.0.0.1:8000/surveys/surveys_api/" + "1", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                for item in json["questions"].arrayValue {
                    print(item["question"].stringValue)
                }
//                print(survey.survey.questions[0])
            case .failure(let error):
                print(error)
            }
        }
    }
}
//create post survey response, get the response's id, use it to fill in each answer
