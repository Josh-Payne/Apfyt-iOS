////
////  ProfileViewController.swift
//
//
//
//import UIKit
//import Eureka
//import ResearchKit
//import CoreLocation
//
//class ProfileViewController: FormViewController {
//    
////    @IBAction func surveyTapped(sender : AnyObject) {
////        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
////        taskViewController.delegate = self
////        present(taskViewController, animated: true, completion: nil)
////    }
//    func taskViewController(taskViewController: ORKTaskViewController,
//                            didFinishWithReason reason: ORKTaskViewControllerFinishReason,
//                            error: NSError?) {
////        let taskResult = taskViewController.result
//        // You could do something with the result here.
//        
//        // Then, dismiss the task view controller.
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                form +++ Section("Section1")
//            <<< TextRow(){ row in
//                row.title = "Name"
//                row.placeholder = "The one and only..."
//            }
//            <<< EmailRow(){
//                $0.title = "Email"
//                $0.placeholder = "How can we reach you?"
//            }
//            +++ Section("Section2")
//            <<< DateRow(){
//                $0.title = "Birthday"
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
//        }
//            +++ Section("Section3")
//            <<< LocationRow(){
//            $0.title = "Location"
//            $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
//        }
//        
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
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//
//
