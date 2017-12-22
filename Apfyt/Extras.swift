/////
////  SurveyFormViewController.swift
////  Apfyt
////
////  Created by Josh Payne on 2/18/17.
////  Copyright © 2017 Apfyt. All rights reserved.
////
//
//import AVFoundation
//import ResearchKit
//import Alamofire
//import SwiftyJSON
//import Cosmos
//
//class ViewController: UIViewController, ORKTaskViewControllerDelegate {
//    
//    /*******Survey question variables*******/
//    var questionsArray = [String]()
//    var style = [String]()
//    var questionID = [String]()
//    var questionOrder = [Int]()
//    var mcChoices = [String]()
//    var surveyName = String()
//    var companyID = String()
//    var surveyID = Int()
//    
//    
//    /*******Survey question variables*******/
//    
//    var questionNumber = 0
//    
//    let possibleRatings = [#imageLiteral(resourceName: "5stars"), #imageLiteral(resourceName: "4stars"), #imageLiteral(resourceName: "3stars"), #imageLiteral(resourceName: "2stars"), #imageLiteral(resourceName: "1star")]
//    
//    @IBOutlet weak var starPicker: CosmosView!
//    
//    var steps = [ORKStep]()
//    
//    
//    func getJson() {
//        surveyID = 1
//        Alamofire.request("http://127.0.0.1:8000/surveys/surveys_api/" + String(surveyID), method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//                self.surveyName = json["name"].stringValue
//                for item in json["questions"].arrayValue {
//                    
//                    
//                    self.questionsArray.append(item["question"].stringValue)
//                    self.style.append(item["style"].stringValue)
//                    self.questionID.append(item["id"].stringValue)
//                    self.questionOrder.append(item["order"].intValue)
//                }
//                self.surveyName = json["name"].stringValue
//                self.companyID = json["company"].stringValue
//                self.surveyID = json["id"].intValue
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getJson()
//        
//    }
//    
//    var audioPlayer: AVAudioPlayer?
//    var soundFileURL: URL?
//    
//    @IBAction func surveyTapped(_ sender : AnyObject) {
//        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
//        taskViewController.delegate = self
//        present(taskViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func microphoneTapped(_ sender : AnyObject) {
//        let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRun: nil)
//        taskViewController.delegate = self
//        taskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
//        present(taskViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func playMostRecentSound(_ sender: AnyObject) {
//        if let soundFileURL = soundFileURL {
//            do {
//                try audioPlayer = AVAudioPlayer(contentsOf: soundFileURL, fileTypeHint: AVFileTypeAppleM4A)
//                audioPlayer?.play()
//            } catch {}
//        }
//    }
//    
//    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//        
//        // check for a sound file
//        //soundFileURL = findSoundFile(taskViewController.result)
//        
//        taskViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func taskViewController(taskViewController: ORKTaskViewController,  didFinishWithReason reason: ORKTaskViewControllerFinishReason,  error: NSError?) {
//        if reason == .saved {
//            let restorationData = taskViewController.restorationData  // Save it for later
//            return
//        }
//        let taskResult = taskViewController.result
//        // Do stuff with the taskResult
//        taskViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    var SurveyTask: ORKOrderedTask {
//        // add instructions step
//        
//        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//        instructionStep.title = surveyName
//        instructionStep.text = companyID
//        steps += [instructionStep] ///////////////
//        
//        /*******Assigning steps*******/
//        for elem in questionOrder {
//            
//            // add text input question
//            
//            if style[elem] == "text" {
//                
//                let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 140)
//                nameAnswerFormat.multipleLines = true
//                let nameQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
//                let nameQuestionStep = ORKQuestionStep(
//                    identifier: questionID[elem],
//                    title: nameQuestionStepTitle,
//                    text: NSLocalizedString("Please share your thoughts below.", comment: ""),
//                    answer: nameAnswerFormat);
//                nameQuestionStep.isOptional = false
//                steps += [nameQuestionStep]
//                questionNumber += 1
//            }
//            // add MC question
//            //            if style[elem] == "multipleChoice" {
//            //            let questQuestionStepTitle = "What is your quest?"
////            let questQuestionStepTitle = "What is your quest?"
////            let textChoices = [
////                ORKTextChoice(text: "Create a ResearchKit App", valu as NSCoding & NSCopying & NSObjectProtocole: 0),
////                ORKTextChoice(text: "Seek the Holy Grail", value: 1),
////                ORKTextChoice(text: "Find a shrubbery", value: 2)
////            ]
////            let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
////            let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
////            steps += [questQuestionStep]
////            
//            
//            //}
//            // add color question step
//            if style[elem] == "rate" {
//                let colorQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
//                let colorTuples = [
//                    (UIImage(named: "happy-5")!, "Very dissatisfied"),
//                    (UIImage(named: "happy-4")!, "Somewhat dissatisfied"),
//                    (UIImage(named: "happy-3")!, "Neither satisfied nor dissatisfied"),
//                    (UIImage(named: "happy-2")!, "Somewhat satisfied"),
//                    (UIImage(named: "happy-1")!, "Very satisfied"),
//                    
//                    ]
//                let imageChoices : [ORKImageChoice] = colorTuples.map {
//                    return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: 1 as NSNumber)
//                }
//                let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
//                let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
//                
//                steps += [colorQuestionStep]
//            }
//        }
//        //TODO: add summary step
//        
//        
//        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
//        summaryStep.title = "Thank you for completing our survey!"
//        summaryStep.text = "Please enjoy a [reward] on us."
//        steps += [summaryStep]
//        
//        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
//    }
//    
//    
//    //  func findSoundFile(_ result: ORKTaskResult) -> URL? {
//    //
//    //    if let results = result.results {
//    //      if results.count > 3 {
//    //        if let stepResult = results[3] as? ORKStepResult, let subResults = stepResult.results, let fileResult = subResults[0] as? ORKFileResult {
//    //          
//    //          return fileResult.fileURL
//    //        }
//    //      }
//    //    }
//    //    
//    //    return nil
//    //  }
//}

//let questQuestionStepTitle = "Multiple choice?"
//let textChoices = [
//    ORKTextChoice(text: "I found out via Social Media.", value: 0 as NSNumber),
//    ORKTextChoice(text: "I found out via television.", value: 1 as NSNumber),
//    ORKTextChoice(text: "A friend told me.", value: 2 as NSNumber)
//]
//let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
//questQuestionStep.isOptional = false
//steps += [questQuestionStep]
