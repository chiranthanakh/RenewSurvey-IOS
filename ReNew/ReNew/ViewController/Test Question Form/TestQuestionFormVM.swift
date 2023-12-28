//
//  TestQuestionFormVM.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit

class TestQuestionFormVM: NSObject {

    var viewController: TestQuestionFormVC?
    var arrQuestionList = [ModelTestQuestion]()
    var modelTest: ModelTest?
    
    func registerController() {
        self.viewController?.tblQuestion.registerCell(withNib: "TextBoxQuestionTCell")
        self.viewController?.tblQuestion.registerCell(withNib: "RatingQuestionTCell")
        self.viewController?.tblQuestion.delegate = self.viewController
        self.viewController?.tblQuestion.dataSource = self.viewController
        self.viewController?.tblQuestion.separatorStyle = .none
        if let test = self.modelTest {
            self.arrQuestionList = test.question
            self.viewController?.tblQuestion.reloadData()
        }
    }
    
    
    func checkAnswer() {
        var numberOfcorrect = 0
        self.arrQuestionList.forEach { question in
            if question.answer != "" {
                if question.userAnswer.trimWhiteSpace  == question.answer.trimWhiteSpace {
                    numberOfcorrect+=1
                }
            }
            else if question.questionType == "RADIO" || question.questionType == "SINGLE_SELECT" {
                if let rightAnswer = question.questionOption.filter({$0.isAnswer == "Y"}).first {
                    if rightAnswer.title == question.userAnswer {
                        numberOfcorrect+=1
                    }
                }
            }
            else if question.questionType == "CHECKBOX" {
                let rightAnswer = question.questionOption.filter({$0.isAnswer == "Y"}).compactMap({$0.title})
                let userAnswer = question.userAnswer.components(separatedBy: ", ")
                if rightAnswer.containsSameElements(as: userAnswer) {
                    numberOfcorrect+=1
                }
            }
        }
        
        if let test = self.modelTest, numberOfcorrect >= (Int(test.passingMarks) ?? 0) {
            //Pass
            self.viewController?.showAlert(withTitle: "Test passed!!",with: "Your obtained Marks :\(numberOfcorrect)", firstButton: "Okay", firstHandler: { action in
                UserDefaults.passedTestFromIds.append(self.modelTest?.tblFormsId ?? 0)
                self.viewController?.navigationController?.pushViewController(DashboardVC(), animated: true)
            })
        }
        else {
            self.viewController?.showAlert(withTitle: "Test Failed!!",with: "Your obtained Marks :\(numberOfcorrect)", firstButton: "Retry", firstHandler: { action in
                self.arrQuestionList.forEach { question in
                    question.userAnswer = ""
                }
                self.viewController?.tblQuestion.reloadData()
            })
        }
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
