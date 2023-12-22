//
//  FormVC.swift
//  ReNew
//
//  Created by Shiyani on 14/12/23.
//

import UIKit
import Cosmos

class FormVC: UIViewController {

    var viewModel = FormVM()
    var imagePicker = ImagePicker()
    
    @IBOutlet var collectionFormGroup: UICollectionView!
    @IBOutlet var vwQuestionListContainer: UIView!
    @IBOutlet var tblQuestion: UITableView!
    
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
extension FormVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.imagePicker.viewController = self
        self.viewModel.registerController()
        
        self.imagePicker.pickerHandler = { (data, path, image, tag) in
            if let cell = self.tblQuestion.cellForRow(at: IndexPath(row: tag, section: 0)) as? TextBoxQuestionTCell {
                cell.txtAnswer.text = path.lastPathComponent
                self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[tag].strAnswer = path.lastPathComponent
                self.tblQuestion.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
            }
        }
    }
    
}

//MARK: - UICollectionView Delegate & DataSource Methods
extension FormVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.viewModel.arrFormGroup.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormGroupTitleCCell", for: indexPath) as? FormGroupTitleCCell else { return UICollectionViewCell() }
        
        cell.vwBg.backgroundColor = UIColor(hex: "#78D47D")
        if indexPath.section == 0 {
            cell.lblGroupTitle.text = "Static Questions"
            cell.lblQuestionCount.text = "\(self.viewModel.arrStaticQuestion.filter({$0.strAnswer != ""}).count)/\(self.viewModel.arrStaticQuestion.count)"
            cell.vwProgress.progress = Float(Float(self.viewModel.arrStaticQuestion.filter({$0.strAnswer != ""}).count)/Float(self.viewModel.arrStaticQuestion.count))
            if self.viewModel.selectedGrpIndex == -1 {
                cell.vwBg.backgroundColor = UIColor(hex: "#33A873")
            }
        }
        else {
            if self.viewModel.arrFormGroup.indices ~= indexPath.row {
                cell.dataBind(obj: self.viewModel.arrFormGroup[indexPath.row])
            }
            if self.viewModel.selectedGrpIndex == indexPath.row {
                cell.vwBg.backgroundColor = UIColor(hex: "#33A873")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.viewModel.selectedGrpIndex = indexPath.row
            self.tblQuestion.reloadData()
        }
        else {
            self.viewModel.selectedGrpIndex = -1
            self.tblQuestion.reloadData()
        }
        self.collectionFormGroup.reloadData()
    }
}

//MARK: - UITablview Delegate & Datasource Methods
extension FormVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.selectedGrpIndex == -1 {
            return self.viewModel.arrStaticQuestion.count
        }
        else {
            return self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextBoxQuestionTCell", for: indexPath) as? TextBoxQuestionTCell else { return UITableViewCell() }
        
        if self.viewModel.selectedGrpIndex == -1 {
            let question = self.viewModel.arrStaticQuestion[indexPath.row]
            cell.completionEditingComplete = { answer in
                self.viewModel.arrStaticQuestion[indexPath.row].strAnswer = answer
                cell.txtAnswer.text = answer
                self.collectionFormGroup.reloadData()
            }
            cell.lblQuestion.text = "\(indexPath.row+1). \(question.questiontitle())"
            cell.txtAnswer.text = question.strAnswer
            cell.isSelection = false
            cell.imgCamera.isHidden = true
            
            if question.type == "TEXT" {
                cell.txtAnswer.keyboardType = .default
            }
            else if question.type == "NUMBER" {
                cell.txtAnswer.keyboardType = .numberPad
            }
            else if question.type == "SINGLE_SELECT" {
                cell.isSelection = true
                cell.completionSelection = {
                    let itemsTitle = question.option.components(separatedBy: "/")
                    let singleComponetPopupPickerView = AYPopupPickerView()
                    singleComponetPopupPickerView.display(itemTitles: itemsTitle, doneHandler: {
                        let selectedIndex = singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
                        print("\(itemsTitle[selectedIndex])")
                        cell.txtAnswer.text = itemsTitle[selectedIndex]
                        question.strAnswer = itemsTitle[selectedIndex]
                        self.collectionFormGroup.reloadData()
                    })
                }
            }
            
        }
        else {
            if self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.indices ~= indexPath.row {
                let question = self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row]
                cell.completionEditingComplete = { answer in
                    question.strAnswer = answer
                    cell.txtAnswer.text = answer
                    self.collectionFormGroup.reloadData()
                }
                
                cell.lblQuestion.text = "\(indexPath.row+1). \(question.title.capitalized)"
                cell.txtAnswer.text = question.strAnswer
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
                        singleComponetPopupPickerView.display(itemTitles: itemsTitle, doneHandler: {
                            let selectedIndex = singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
                            print("\(itemsTitle[selectedIndex])")
                            cell.txtAnswer.text = itemsTitle[selectedIndex]
                            question.strAnswer = itemsTitle[selectedIndex]
                            self.collectionFormGroup.reloadData()
                        })
                    }
                }
                else if question.questionType == "MULTI_SELECT" || question.questionType == "CHECKBOX" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let vc = ListSelectionVC()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.viewModel.arrList = question.questionOption.compactMap({ ModelListSelection.init(id: String($0.tblFormQuestionsOptionId), name: $0.title)})
                        vc.isMultpalSelection = true
                        vc.viewModel.strTitle = question.title
                        vc.completionMultipalSelection = { answers in
                            cell.txtAnswer.text = answers.compactMap({$0.name}).joined(separator: ", ")
                            question.strAnswer = answers.compactMap({$0.name}).joined(separator: ", ")
                            self.collectionFormGroup.reloadData()
                        }
                        self.present(vc, animated: true)
                    }
                }
                else if question.questionType == "TIME" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let datePicker = DatePickerDialog()
                        datePicker.show(question.title,
                                        doneButtonTitle: "Done",
                                        cancelButtonTitle: "Cancel",
                                        defaultDate: Date(),
                                        minimumDate: nil,
                                        maximumDate: nil,
                                        datePickerMode: .time) { (date) in
                            if let dt = date {
                                cell.txtAnswer.text = dt.getFormattedString(format: "HH:mm")
                                question.strAnswer = dt.getFormattedString(format: "HH:mm")
                                self.collectionFormGroup.reloadData()
                            }
                        }
                    }
                }
                else if question.questionType == "DATETIME" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let datePicker = DatePickerDialog()
                        datePicker.show(question.title,
                                        doneButtonTitle: "Done",
                                        cancelButtonTitle: "Cancel",
                                        defaultDate: Date(),
                                        minimumDate: nil,
                                        maximumDate: nil,
                                        datePickerMode: .dateAndTime) { (date) in
                            if let dt = date {
                                cell.txtAnswer.text = dt.getFormattedString(format: "dd-MM-yyyy HH:mm")
                                question.strAnswer = dt.getFormattedString(format: "dd-MM-yyyy HH:mm")
                                self.collectionFormGroup.reloadData()
                            }
                        }
                    }
                }
                else if question.questionType == "CAPTURE" {
                    cell.imgCamera.isHidden = false
                    cell.imgCamera.image = UIImage(systemName: "camera")
                    cell.isSelection = true
                    cell.txtAnswer.text = "Capture Image"
                    cell.completionSelection = {
                        self.imagePicker.pickImageFromGallary(self) { img in
                            cell.imgCamera.image = img
                            self.collectionFormGroup.reloadData()
                        }
                    }
                }
                else if question.questionType == "FILE" {
                    cell.imgCamera.isHidden = false
                    cell.imgCamera.image = UIImage(systemName: "doc")
                    cell.isSelection = true
                    cell.txtAnswer.text = question.strAnswer == "" ? "Select File" : question.strAnswer
                    
                    cell.completionSelection = {
                        self.imagePicker.tag = indexPath.row
                        self.imagePicker.chooseDocument(docType: question.allowFileType.components(separatedBy: ","))
                        self.collectionFormGroup.reloadData()
                    }
                }
                else if question.questionType == "DATETIME" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let datePicker = DatePickerDialog()
                        datePicker.show(question.title,
                                        doneButtonTitle: "Done",
                                        cancelButtonTitle: "Cancel",
                                        defaultDate: Date(),
                                        minimumDate: nil,
                                        maximumDate: nil,
                                        datePickerMode: .dateAndTime) { (date) in
                            if let dt = date {
                                cell.txtAnswer.text = dt.getFormattedString(format: "dd-MM-yyyy HH:mm")
                                question.strAnswer = dt.getFormattedString(format: "dd-MM-yyyy HH:mm")
                                self.collectionFormGroup.reloadData()
                            }
                        }
                    }
                }
                else if question.questionType == "GEO_LOCATION" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        LocationHandler.shared.getLocationUpdates { (locationManger, location) -> (Bool) in
                            cell.txtAnswer.text = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                            question.strAnswer = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                            self.collectionFormGroup.reloadData()
                            return true
                        }
                    }
                }
                else if question.questionType == "RATING" {
                    guard let cellRating = tableView.dequeueReusableCell(withIdentifier: "RatingQuestionTCell", for: indexPath) as? RatingQuestionTCell else { return UITableViewCell() }
                    
                    cellRating.vwRating.isHidden = false
                    cellRating.vwRangeSiker.isHidden = true
                    if self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.indices ~= indexPath.row {
                        cellRating.lblQuestion.text = "\(indexPath.row+1). \(self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].title)"
                        cellRating.vwRating.rating = Double(self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].strAnswer) ?? 0
                        cellRating.vwRating.didFinishTouchingCosmos = { rating in
                            self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].strAnswer = "\(rating)"
                            self.collectionFormGroup.reloadData()
                        }
                    }
                    
                    return cellRating
                }
                else if question.questionType == "RANGE" {
                    guard let cellRating = tableView.dequeueReusableCell(withIdentifier: "RatingQuestionTCell", for: indexPath) as? RatingQuestionTCell else { return UITableViewCell() }
                    
                    cellRating.vwRating.isHidden = true
                    cellRating.vwRangeSiker.isHidden = false
                    if self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.indices ~= indexPath.row {
                        let ratingQuestion = self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row]
                        cellRating.lblQuestion.text = "\(indexPath.row+1). \(ratingQuestion.title)"
                        cellRating.vwRangeSiker.minValue = CGFloat(ratingQuestion.minLength)
                        cellRating.vwRangeSiker.maxValue = CGFloat(ratingQuestion.maxLength)
                        if ratingQuestion.strAnswer != "" {
                            //                        cellRating.vwRangeSiker.min = CGFloat(ratingQuestion.strAnswer.components(separatedBy: ",").first ?? "") ?? 0.0
                            //                        cellRating.vwRangeSiker.selectedMaxValue = CGFloat(ratingQuestion.strAnswer.components(separatedBy: ",").last ?? "") ?? 0.0
                        }
                        
                        cellRating.completionRangeSelection = { minValue, maxValue in
                            ratingQuestion.strAnswer = "\(minValue),\(maxValue)"
                            self.collectionFormGroup.reloadData()
                        }
                    }
                    
                    return cellRating
                }
            }
            else {
                
            }
        }
        return cell
    }
}
