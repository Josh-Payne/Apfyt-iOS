//
//  SurveyTask.swift
//  Apfyt
//
//  Created by Josh Payne on 2/18/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import ResearchKit
import Alamofire
import SwiftyJSON

//
//var styleArray = [String]()
//var urlID = Int()
//var questionNumber = 0
//
//let possibleRatings = [#imageLiteral(resourceName: "5stars"), #imageLiteral(resourceName: "4stars"), #imageLiteral(resourceName: "3stars"), #imageLiteral(resourceName: "2stars"), #imageLiteral(resourceName: "1star")]
//

//public var SurveyTask: ORKOrderedTask {
//    var questionsArray = [String]()
//    urlID = 1
//    var steps = [ORKStep]()
//    
//    //TODO: add instructions step
//    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "Taco Bell Survey"
//    instructionStep.text = "Thank you for offering your feedback! We strive to improve in any way we can."
//    steps += [instructionStep]
//    
//    //TODO: add name question
//    
//    Alamofire.request("http://127.0.0.1:8000/surveys/surveys_api/" + String(urlID), method: .get).validate().responseJSON { response in
//        switch response.result {
//        case .success(let value):
//            let json = JSON(value)
//            print("JSON: \(json)")
//            var counter = 0
//            for item in json["questions"].arrayValue {
//                questionsArray.append(item["question"].stringValue)
//                counter+=1
//            }
//            print(counter)
//        print(questionsArray[0])
//        case .failure(let error):
//            print(error)
//        }
//    }
//    
//    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
//    nameAnswerFormat.multipleLines = false
//    print(questionsArray.count)
//    let nameQuestionStepTitle = "yoo"
//    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
//    steps += [nameQuestionStep]
//    questionNumber += 1
//    
//    //TODO: add 'what is your quest' question
//    
//    let questQuestionStepTitle = "Multiple choice?"
//    let textChoices = [
//        ORKTextChoice(text: "I found out via Social Media.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
//        ORKTextChoice(text: "I found out via television.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
//        ORKTextChoice(text: "A friend told me.", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
//    ]
//    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
//    steps += [questQuestionStep]
//    
//    //TODO: add color question step
//    
//    let colorQuestionStepTitle = "Possible rating choices?"
//    let colorTuples = [
//        (UIImage(named: "red")!, "Red"),
//        (UIImage(named: "orange")!, "Orange"),
//        (UIImage(named: "yellow")!, "Yellow"),
//        (UIImage(named: "green")!, "Green"),
//        (UIImage(named: "blue")!, "Blue"),
//        (UIImage(named: "purple")!, "Purple")
//    ]
//    let imageChoices : [ORKImageChoice] = colorTuples.map {
//        return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
//    }
//    let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
//    let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
//    steps += [colorQuestionStep]
//    
//    //TODO: add summary step
//    
//    
//    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
//    summaryStep.title = "Right. Off you go!"
//    summaryStep.text = "That was easy!"
//    steps += [summaryStep]
//    
//    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
//}
func downloadJson() {
    }
