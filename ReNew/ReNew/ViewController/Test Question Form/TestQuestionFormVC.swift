//
//  TestQuestionFormVC.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit

class TestQuestionFormVC: UIViewController {

    @IBOutlet var tblQuestion: UITableView!

    var viewModel = TestQuestionFormVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Init Config
extension TestQuestionFormVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.registerController()
    }
    
}

//MARK: - UiButton Action
extension TestQuestionFormVC {
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.viewModel.checkAnswer()
    }
    
}
//MARK: - UITablview Delegate & Datasource Methods
extension TestQuestionFormVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextBoxQuestionTCell", for: indexPath) as? TextBoxQuestionTCell else { return UITableViewCell() }
        
        cell.btnSelection.isEnabled = true
        if self.viewModel.arrQuestionList.indices ~= indexPath.row {
            let question = self.viewModel.arrQuestionList[indexPath.row]
            cell.completionEditingComplete = { answer in
                question.userAnswer = answer
                cell.txtAnswer.text = answer
            }
            
            cell.lblQuestion.setQuestionTitleAttributedTextLable(index: indexPath.row+1, question: question.title.capitalized, isMantory: question.isMandatory)
            cell.txtAnswer.text = question.userAnswer
            cell.isSelection = false
            cell.imgCamera.isHidden = true
            cell.maxChacaterLimit = question.maxLength
            if question.questionType == "TEXT" {
                cell.txtAnswer.keyboardType = .default
            }
            else if question.questionType == "NUMBER" {
                cell.txtAnswer.keyboardType = .numberPad
            }
            else if question.questionType == "EMAIL" {
                cell.txtAnswer.keyboardType = .emailAddress
            }
            else if question.questionType == "RADIO" || question.questionType == "SINGLE_SELECT" {
                cell.isSelection = true
                cell.completionSelection = {
                    let itemsTitle = question.questionOption.compactMap({$0.title})
                    let singleComponetPopupPickerView = AYPopupPickerView()
                    self.view.endEditing(true)
                    singleComponetPopupPickerView.display(itemTitles: itemsTitle, doneHandler: {
                        let selectedIndex = singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
                        print("\(itemsTitle[selectedIndex])")
                        cell.txtAnswer.text = itemsTitle[selectedIndex]
                        question.userAnswer = itemsTitle[selectedIndex]
                    })
                }
            }
            else if question.questionType == "MULTI_SELECT" || question.questionType == "CHECKBOX" {
                cell.isSelection = true
                cell.completionSelection = {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = question.questionOption.compactMap({ ModelListSelection.init(id: String($0.tblTestQuestionsOptionId), name: $0.title)})
                    vc.isMultpalSelection = true
                    vc.viewModel.strTitle = question.title
                    vc.completionMultipalSelection = { answers in
                        cell.txtAnswer.text = answers.compactMap({$0.name}).joined(separator: ", ")
                        question.userAnswer = answers.compactMap({$0.name}).joined(separator: ", ")
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        return cell
    }
}
