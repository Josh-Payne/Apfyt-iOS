//
//  NotificationsViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 3/4/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import ResearchKit

class NotificationsViewController: UIViewController, ORKTaskViewControllerDelegate {

    func taskViewController(_ taskViewController: ORKTaskViewController,
                            didFinishWith reason: ORKTaskViewControllerFinishReason,
                            error: Error?) {
//        let taskResult = taskViewController.result
        // You could do something with the result here.
        
        // Then, dismiss the task view controller.
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myStep = ORKInstructionStep(identifier: "intro")
        myStep.title = "Welcome to ResearchKit"
        let task = ORKOrderedTask(identifier: "task", steps: [myStep])
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
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
