//
//  FormVM.swift
//  ReNew
//
//  Created by Shiyani on 14/12/23.
//

import UIKit



class FormVM: NSObject {

    var viewController: FormVC?
    var arrFormGroup = [ModelFormGroup]()
    var arrStaticQuestion = [ModelStaticQuestion]()
    var selectedGrpIndex = -1
    
    func registerController() {
        self.viewController?.collectionFormGroup.registerCell(withNib: "FormGroupTitleCCell")
        self.viewController?.collectionFormGroup.delegate = self.viewController
        self.viewController?.collectionFormGroup.dataSource = self.viewController
        
        self.viewController?.tblQuestion.registerCell(withNib: "TextBoxQuestionTCell")
        self.viewController?.tblQuestion.registerCell(withNib: "RatingQuestionTCell")
        self.viewController?.tblQuestion.delegate = self.viewController
        self.viewController?.tblQuestion.dataSource = self.viewController
        self.viewController?.tblQuestion.separatorStyle = .none
        
        self.getStaticQuestions()
        self.getFormGroup()
    }
    
    func getFormGroup() {
        arrFormGroup = DataManager.getFormGroupList()
        self.getQuestions()
    }
    
    func getStaticQuestions() {
        self.arrStaticQuestion = DataManager.getStaticQuestionList()
        self.viewController?.collectionFormGroup.reloadData()
    }
    
    func getQuestions() {
        arrFormGroup.forEach { questionGroup in
            questionGroup.questions = DataManager.getQuestionList(grpId: questionGroup.mstQuestionGroupId)
        }
        self.getQuestionOption()
    }
    
    func getQuestionOption() {
        arrFormGroup.forEach { questiongrp in
            questiongrp.questions.forEach { question in
                question.questionOption = DataManager.getQuestionOptionList(questionId: question.tblFormQuestionsId)
            }
        }
        self.viewController?.collectionFormGroup.reloadData()
        self.viewController?.tblQuestion.reloadData()
//        self.viewController?.addController()
    }
    
    func saveDraft() {
        
    }
}
