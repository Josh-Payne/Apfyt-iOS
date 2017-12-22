//
//  SurveyFormViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 2/18/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import AVFoundation
import ResearchKit
import Alamofire
import SwiftyJSON

protocol DestinationViewDelegate {
    func setColor(colorName: String)
}

class SurveyViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    @IBOutlet weak var surveyButton: UIButton!
    @IBOutlet weak var destinationOutletLabel: UILabel!
    /*******Survey question variables*******/
    var questionsArray = [String]()
    var style = [String]()
    var questionID = [Int]()
    var questionOrder = [Int]()
    var surveyName = String()
    var companyID = String()
    var surveyID = Int()
    var reward = String()
    var companyName = String()
    
    var colorLabelText = String()
    var delegate : DestinationViewDelegate! = nil
    /*******Survey question variables*******/
    
    var questionNumber = 0
    
    let possibleRatings = [#imageLiteral(resourceName: "5stars"), #imageLiteral(resourceName: "4stars"), #imageLiteral(resourceName: "3stars"), #imageLiteral(resourceName: "2stars"), #imageLiteral(resourceName: "1star")]
    
    let mcChoices = ["I found out through Apfyt", "I found out through social media", "I found out through television", "A friend told me"]
    
    var steps = [ORKStep]()
    var punchStep = [ORKStep]()
    
    func getJson() {
        let headers = [
            
            "Content-Type": "application/json"
            
        ]
        
        let parameters: [String: AnyObject] = [
            
            "client_id" : "1" as AnyObject,
            "access_token" : "5" as AnyObject
            
        ]
        surveyID = 3
        print("hi")
        Alamofire.request("http://www.dev.apfyt.business/surveys/surveys_api/" + String(surveyID), method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("there")
                print("JSON: \(json)")
                self.surveyName = json["name"].stringValue
                self.reward = json["reward"].stringValue
                self.companyName = json["company"]["name"].stringValue
                for item in json["questions"].arrayValue {
                    self.questionsArray.append(item["question"].stringValue)
                    self.style.append(item["style"].stringValue)
                    self.questionID.append(item["id"].intValue)
                    self.questionOrder.append(item["order"].intValue)
                    
                }
                print(self.questionOrder.count)
                self.surveyName = json["name"].stringValue
                self.companyID = json["company"].stringValue
                self.surveyID = json["id"].intValue
            
            case .failure(let error):
            print(error)
            
            }
        }
        questionOrder = [1, 0, 2, 3, 4]
        style = ["rate", "text", "mc", "number", "bool"]
        questionsArray = ["How satisfied were you with the taste of food?", "Can you tell us about the best part of your experience?", "How satisfied were you with the cleanliness of the restaurant?", "How satisfied were you with the speed of service?", "Were you greeted upon arrival?"]
        questionID = [1, 0, 2, 3, 4]
        surveyName = "Welcome to our quality experience survey!"
        companyName = "Taco Bell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationOutletLabel.text = colorLabelText
        getJson()
        
    }
    
  var audioPlayer: AVAudioPlayer?
  var soundFileURL: URL?
  
  @IBAction func surveyTapped(_ sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
    taskViewController.delegate = self
    present(taskViewController, animated: true, completion: nil)
  }
    @IBAction func punchTapped(_ sender : AnyObject) {
        let punchViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
        punchViewController.delegate = self
        present(punchViewController, animated: true, completion: nil)
    }
  
//    func punchViewController(_ punchViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//            if reason == .completed {
//                print("Done")
//                let result = punchViewController.result
//            
//                let jsonData = try! ORKESerializer.jsonData(for: result)
//                let json = JSON(data: jsonData)
//                if let string = json.rawString() {
//                    print(string)
//                }
//                if let userName = json[][].string {
//                    print(userName)
//                }
//            //if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
//            //let json = JSON(data: dataFromString)
//            //}
//        }
//        if reason == .saved {
//            let restorationData = punchViewController.restorationData  // Save it for later
//            return
//        }
//        let taskResult = punchViewController.result
//        // Do stuff with the taskResult
//        print("Done")
//        punchViewController.dismiss(animated: true, completion: nil)
//
//    }
    
  func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
    if reason == .completed {
        print("Done")
//        let result = taskViewController.result
//
//        let jsonData = try! ORKESerializer.jsonData(for: result)
//        let json = JSON(data: jsonData)
//        if let string = json.rawString() {
//            print(string)
//        }
//        if let userName = json[][].string {
//            print(userName)
//        }
            //if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                //let json = JSON(data: dataFromString)
            //}
        }
    
        
        
    
    if reason == .saved {
        let restorationData = taskViewController.restorationData  // Save it for later
        return
    }
    let taskResult = taskViewController.result
    // Do stuff with the taskResult
    print("Done")
    taskViewController.dismiss(animated: true, completion: nil)
    taskViewController.dismiss(animated: true, completion: nil)
  }
    
    var PunchTask: ORKOrderedTask {
        let summaryStep = ORKCompletionStep(identifier: "PunchSummaryStep")
        summaryStep.title = "You now have 6 punches. Only 4 to go!"
        summaryStep.text = "Thank you for checking in! Stop by again soon!"
        punchStep += [summaryStep]
        return ORKOrderedTask(identifier: "SurveyTask", steps: punchStep)
    }
   
    
    var SurveyTask: ORKOrderedTask {
        
        // add instructions step
        
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = surveyName
        instructionStep.text = companyName
        steps += [instructionStep] ///////////////
        questionNumber+=1
        
        /******* *******/
         for elem in questionOrder {
        
        // add text input question
         if style[elem] == "text" {
        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 140)
        nameAnswerFormat.multipleLines = true
        let nameQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
        let nameQuestionStep = ORKQuestionStep(
            identifier: "Question " + String(questionNumber),
            title: nameQuestionStepTitle,
            text: NSLocalizedString("Please share your thoughts below.", comment: ""),
            answer: nameAnswerFormat);
        nameQuestionStep.isOptional = false
        steps += [nameQuestionStep]
        questionNumber += 1
            }
        
        // add MC question
        
        // add color question step
            if style[elem] == "rate" {
                let formStepImage = ORKFormStep(identifier: "Question " + String(questionNumber), title: questionsArray[elem], text: "")
                // let colorQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
                
                let dissatisfied = UIImage(named: "happy-5")!
                let dissatisfiedText = NSLocalizedString("Very dissatisfied", comment: "")
                
                let somewhatDissatisfied = UIImage(named: "happy-4")!
                let somewhatDissatisfiedText = NSLocalizedString("Somewhat dissatisfied", comment: "")
                
                let neitherNor = UIImage(named: "happy-3")!
                let neitherNorText = NSLocalizedString("Neither satisfied nor dissatisfied", comment: "")
                
                let somewhatSatisfied = UIImage(named: "happy-2")!
                let somewhatSatisfiedText = NSLocalizedString("Somewhat satisfied", comment: "")
                
                let Satisfied = UIImage(named: "happy-1")!
                let SatisfiedText = NSLocalizedString("Very satisfied", comment: "")
                
                let imageChoices = [
                    ORKImageChoice(normalImage: dissatisfied, selectedImage: nil, text: dissatisfiedText, value: dissatisfiedText as NSCoding & NSCopying & NSObjectProtocol),
                    ORKImageChoice(normalImage: somewhatDissatisfied, selectedImage: nil, text: somewhatDissatisfiedText, value: somewhatDissatisfiedText as NSCoding & NSCopying & NSObjectProtocol),
                    ORKImageChoice(normalImage: neitherNor, selectedImage: nil, text: neitherNorText, value: neitherNorText as NSCoding & NSCopying & NSObjectProtocol),
                    ORKImageChoice(normalImage: somewhatSatisfied, selectedImage: nil, text: somewhatSatisfiedText, value: somewhatSatisfiedText as NSCoding & NSCopying & NSObjectProtocol),
                    ORKImageChoice(normalImage: Satisfied, selectedImage: nil, text: SatisfiedText, value: SatisfiedText as NSCoding & NSCopying & NSObjectProtocol),
                    ]
                
                let imageAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
                let imageItem = ORKFormItem(identifier: "imageChoice", text: "Choices", answerFormat: imageAnswerFormat)
                //let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
                let textFormat = ORKTextAnswerFormat(maximumLength: 140)
                let inputItem = ORKFormItem(identifier: "textChoice", text: "Elaborate if you wish.", answerFormat: textFormat)
                formStepImage.formItems = [imageItem, inputItem]
                steps += [formStepImage]
                questionNumber+=1
            }
            
                    if style[elem] == "number" {
                        let formStepImage = ORKFormStep(identifier: "Question " + String(questionNumber), title: questionsArray[elem], text: "")
                       // let colorQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
                        
                        let imageAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10, minimumValue: 1, defaultValue: NSIntegerMax, step: 1, vertical: false, maximumValueDescription: "Very Likely", minimumValueDescription: "Very Unlikely")
                        let imageItem = ORKFormItem(identifier: "imageChoice", text: "Choices", answerFormat: imageAnswerFormat)
                        //let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
                        let textFormat = ORKTextAnswerFormat(maximumLength: 140)
                        let inputItem = ORKFormItem(identifier: "textChoice", text: "Elaborate if you wish.", answerFormat: textFormat)
                        formStepImage.formItems = [imageItem, inputItem]
                        steps += [formStepImage]
                        questionNumber+=1
        }
        
        //TODO: add summary step
        
        
        if style[elem] == "mc" {
            let formStepMC = ORKFormStep(identifier: "Question " + String(questionNumber), title: questionsArray[elem], text: "")
            
            var multipleChoices = [ORKTextChoice]()
            //input text saying 'please select one' or 'choose all that apply'
            for textChoice in mcChoices {
                multipleChoices.append(ORKTextChoice(text: NSLocalizedString(textChoice, comment: ""), detailText: NSLocalizedString("", comment: ""), value: textChoice as NSCoding & NSCopying & NSObjectProtocol, exclusive: false))
            }
            
            let choiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice,
                                                         textChoices: multipleChoices)
            let mcItem = ORKFormItem(identifier: "Question "+String(questionNumber)+": multipleChoice", text: "Choices", answerFormat: choiceFormat)
                            let textFormat = ORKTextAnswerFormat(maximumLength: 50)
                            textFormat.multipleLines = false
                            let inputItem = ORKFormItem(identifier: "Question "+String(questionNumber)+": textChoice", text: "Other", answerFormat: textFormat)
            formStepMC.formItems = [mcItem, inputItem]
            steps += [formStepMC]
            questionNumber+=1
        }
            
            if style[elem] == "bool" {
                let formStepImage = ORKFormStep(identifier: "Question " + String(questionNumber), title: questionsArray[elem], text: "")
                // let colorQuestionStepTitle = NSLocalizedString(questionsArray[elem], comment: "")
                
                let yep = UIImage(named: "yep")!
                let yepText = NSLocalizedString("Yes", comment: "")
                
                let nope = UIImage(named: "nope")!
                let nopeText = NSLocalizedString("No", comment: "")
                
                let imageChoices = [
                    ORKImageChoice(normalImage: yep, selectedImage: nil, text: yepText, value: yepText as NSCoding & NSCopying & NSObjectProtocol),
                    ORKImageChoice(normalImage: nope, selectedImage: nil, text: nopeText, value: nopeText as NSCoding & NSCopying & NSObjectProtocol),
                    
                    ]
                
                let imageAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
                let imageItem = ORKFormItem(identifier: "imageChoice", text: "Choices", answerFormat: imageAnswerFormat)
                //let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
                let textFormat = ORKTextAnswerFormat(maximumLength: 140)
                let inputItem = ORKFormItem(identifier: "textChoice", text: "Elaborate if you wish.", answerFormat: textFormat)
                formStepImage.formItems = [imageItem, inputItem]
                steps += [formStepImage]
                questionNumber+=1
            }
        
        }
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you and congratulations!"
        summaryStep.text = "You've earned a free small fries!"
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }

///use for voice feedback?
    
//  func findSoundFile(_ result: ORKTaskResult) -> URL? {
//    
//    if let results = result.results {
//      if results.count > 3 {
//        if let stepResult = results[3] as? ORKStepResult, let subResults = stepResult.results, let fileResult = subResults[0] as? ORKFileResult {
//          
//          return fileResult.fileURL
//        }
//      }
//    }
//    
//    return nil
//  }
}
