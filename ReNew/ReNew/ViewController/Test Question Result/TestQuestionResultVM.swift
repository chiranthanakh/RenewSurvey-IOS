//
//  TestQuestionResultVM.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit

class TestQuestionResultVM: NSObject {

    var viewController: TestQuestionResultVC?
    var modelTest: ModelTest?
    
    func getTestDetails() {
        if let test = DataManager.getTestDetail(formId: kAppDelegate.selectedFormID, languageId: kAppDelegate.selectedLanguageID) {
            self.viewController?.lblTestName.text = "Test name: \(test.title)"
            self.viewController?.lblPassingMark.text = "Passing Marks: \(test.passingMarks)"
            test.question = DataManager.getTestQuestionList(languageId: kAppDelegate.selectedLanguageID, testId: test.tblTestsId)
            self.viewController?.lblTotalQuestion.text = "Total Questions: \(test.question.count)"
            test.question.forEach { question in
                question.questionOption = DataManager.getTestQuestionOptionList(languageId: kAppDelegate.selectedLanguageID, questionId: question.tblTestQuestionsId)
            }
            self.modelTest = test
        }
    }
}
