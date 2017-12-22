//
//  ResponseViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 3/3/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResponseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var questionName: UILabel!
//    var collectionView: UICollectionView!
    var questionsArray = [String]()
    var styleArray = [String]()
    var urlID = Int()
    var questionNumber = 0
    let possibleRatings = [#imageLiteral(resourceName: "5stars"), #imageLiteral(resourceName: "4stars"), #imageLiteral(resourceName: "3stars"), #imageLiteral(resourceName: "2stars"), #imageLiteral(resourceName: "1star")]
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleRatings.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        questionNumber+=1
//    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingTableViewCell
        ratingCell.starImages.image = possibleRatings[indexPath.row]
        ratingCell.backgroundColor = UIColor.clear
        
//        ratingCell.ratingLabel.text = String(indexPath.row)
        
        
        
        
        
        //        Alamofire.request("http://127.0.0.1:8000/static/img/logo.png").downloadProgress(closure: { (progress) in print(progress.fractionCompleted)
        //        }).responseData { (response) in
        //            print(response.result)
        //            print(response.result.value)
        //            if let data = response.result.value {
        //                cell.myImage.image = UIImage(data: data)
        //            }
        //        }
        
        
        return (ratingCell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        setupCollectionView()
        //downloadJson()
        assignLabel()
    }

    func assignLabel() {
//        questionName.text = questionsArray[questionNumber]
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
    
//    func setupCollectionView(){
//        let layout = UICollectionViewFlowLayout()
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * 0.1, width: view.frame.width, height: view.frame.height * 0.9), collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.gray
//        view.addSubview(collectionView)
//    }
    }
