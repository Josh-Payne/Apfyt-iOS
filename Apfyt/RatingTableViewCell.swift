//
//  RatingTableViewCell.swift
//  Apfyt
//
//  Created by Josh Payne on 3/3/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var starImages: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//if true { //style[elem] == "multipleChoice" {
//    let formStepMC = ORKFormStep(identifier: "MCForm", title: "Multiple choice question", text: "")
//    let choiceFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice,
//                                                 textChoices: [
//                                                    ORKTextChoice(text: NSLocalizedString("I found out via Social Media.", comment: ""), detailText: NSLocalizedString("Yes", comment: ""), value: 0 as NSNumber, exclusive: false),
//                                                    ORKTextChoice(text: NSLocalizedString("I found out via Television.", comment: ""), detailText: NSLocalizedString("Yes", comment: ""), value: 0 as NSNumber, exclusive: false),
//                                                    ORKTextChoice(text: NSLocalizedString("I found out via Social Media.", comment: ""), detailText: NSLocalizedString("Yes", comment: ""), value: 0 as NSNumber, exclusive: false)
//        ])
//    let mcItem = ORKFormItem(identifier: "choicesChoice", text: "Choices", answerFormat: choiceFormat)
//    //                let textFormat = ORKTextAnswerFormat(maximumLength: 140)
//    //                let inputItem = ORKFormItem(identifier: "textChoice", text: "Elaborate if you wish.", answerFormat: textFormat)
//    formStepMC.formItems = [mcItem]
//    steps += [formStepMC]
//}
