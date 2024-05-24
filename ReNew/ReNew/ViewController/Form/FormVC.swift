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
    var oTPTimer = Timer()

    @IBOutlet var vwHeader: AppLogoNavBarView!
    @IBOutlet var collectionFormGroup: UICollectionView!
    @IBOutlet var vwQuestionListContainer: UIView!
    @IBOutlet var tblQuestion: UITableView!
    @IBOutlet var btnNext: UIButton!
    
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
    @IBAction func btnNext(_ sender: UIButton) {
        if self.viewModel.isAllowCollectData {
            if self.viewModel.selectedFormsId == 2, self.viewModel.isVerificationSuccess == false && self.viewModel.isFromDraft == false{
                self.showAlert(with: "Please enter otp and verify it.")
                return
            }
            else if self.viewModel.selectedFormsId == 3, (self.viewModel.arrStaticQuestion.filter({$0.id == 32}).first?.strAnswer ?? "" != self.viewModel.modelAssignedSurvey?.deviceSerialNumber ?? "") && self.viewModel.isFromDraft == false{
                self.showAlert(with: "Please valid device serial number")
                return
            }
            else {
                self.viewModel.arrStaticQuestion = self.viewModel.arrStaticQuestion.filter({$0.id != 33})
            }
            if self.viewModel.selectedGrpIndex < self.viewModel.arrFormGroup.count-1{
                if self.viewModel.selectedGrpIndex == -1, let msg = self.viewModel.validationStaticQuestions() {
                    self.showAlert(with: msg)
                    return
                }
                else if self.viewModel.selectedGrpIndex > -1, let msg = self.viewModel.validationQuestionsGroup(index: self.viewModel.selectedGrpIndex) {
                    self.showAlert(with: msg)
                    return
                }
                else {
                    self.viewModel.saveDraft()
                    self.viewModel.selectedGrpIndex+=1
                    self.collectionFormGroup.reloadData()
                    if self.viewModel.selectedGrpIndex != -1 {
                        self.collectionFormGroup.scrollToItem(at: IndexPath(item: self.viewModel.selectedGrpIndex, section: 1), at: .right, animated: true)
                    }
                    self.tblQuestion.reloadData()
                    delay(seconds: 0.5) {
                        self.tblQuestion.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                }
            }
            else {
//                self.viewModel.saveDraft(isShowMsg: true)
                self.viewModel.saveToLocalDb()
            }
        }
        else {
            self.viewModel.saveToLocalDb()
        }
    }
    
    @IBAction func btnSavePrevoius(_ sender: UIButton) {
        if self.viewModel.selectedGrpIndex != -1{
            self.viewModel.selectedGrpIndex-=1
            self.collectionFormGroup.reloadData()
            if self.viewModel.selectedGrpIndex != -1 {
                self.collectionFormGroup.scrollToItem(at: IndexPath(item: self.viewModel.selectedGrpIndex, section: 1), at: .right, animated: true)
            }
            else {
                self.collectionFormGroup.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
            }
            self.tblQuestion.reloadData()
            delay(seconds: 0.5) {
                self.tblQuestion.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
}

//MARK: - Init Config
extension FormVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.imagePicker.viewController = self
        self.vwHeader.isRightButtonVisible = true
        self.vwHeader.completionRightButtonTap = {
            /*if self.vwHeader.btnRightOption.titleLabel?.text == "Save As Draft" {
                self.viewModel.saveDraft(isShowMsg: true)
            }
            else {
                self.viewModel.saveToLocalDb()
            }*/
            self.view.endEditing(true)
            self.viewModel.saveDraft(isShowMsg: true)
        }
        self.viewModel.registerController()
        
        self.imagePicker.pickerHandler = { (data, path, image, tag) in
            if let cell = self.tblQuestion.cellForRow(at: IndexPath(row: tag, section: 0)) as? TextBoxQuestionTCell {
                cell.txtAnswer.text = path.lastPathComponent
                let FileData :NSData = try! NSData(contentsOf: path)
                let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(self.viewModel.selectedTblProjectsId)_\(self.viewModel.selectedFormsId)_\(self.viewModel.selectedProjectPhaseId)_\(path.lastPathComponent)"
                duplicateFileToDouments(fileDate: FileData, fileName: fileName)
                self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[tag].strAnswer = fileName
                self.tblQuestion.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
            }
        }
    }
    
    func runOTPTimer() {
        self.oTPTimer.invalidate()
        self.oTPTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.otpTimerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func otpTimerUpdate() {
        // Something cool
        if self.viewModel.intOTPTimer == 0 {
            self.oTPTimer.invalidate()
            self.tblQuestion.reloadData()
        }
        else {
            self.viewModel.intOTPTimer-=1
            if let cell = self.tblQuestion.cellForRow(at: IndexPath(row: self.tblQuestion.numberOfRows(inSection: 0)-1, section: 0)) as? OTPVerifyTCell {
                cell.lblSendCode.text = "Resend OTP in \(self.viewModel.intOTPTimer) second"
            }
        }
    }
}

//MARK: - UICollectionView Delegate & DataSource Methods
extension FormVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.viewModel.isAllowCollectData {
            return 2
        }
        else {
            return 1
        }
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
            cell.lblGroupTitle.text = "Basic Information"
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
            if question.id == 33 {
                guard let otpCell = tableView.dequeueReusableCell(withIdentifier: "OTPVerifyTCell", for: indexPath) as? OTPVerifyTCell else { return UITableViewCell() }
                otpCell.lblQuestion.setQuestionTitleAttributedTextLable(index: question.indexNo, question: question.questiontitle(), isMantory: "YES")
                otpCell.lblSendCode.text = "Resend OTP in \(self.viewModel.intOTPTimer) second"
                if self.viewModel.intOTPTimer == 0 {
                    otpCell.btnVerifyOTP.isHidden = true
                    otpCell.btnSendOTP.isHidden = false
                    otpCell.lblSendCode.isHidden = true
                }
                else{
                    otpCell.btnVerifyOTP.isHidden = false
                    otpCell.btnSendOTP.isHidden = true
                    otpCell.lblSendCode.isHidden = false
                }
                if self.viewModel.isVerificationSuccess {
                    otpCell.vwButtons.isHidden = true
                    otpCell.lblSendCode.isHidden = true
                }
                otpCell.completionSendCodeTap = {
                    self.viewModel.sendOTPAPICall()
                }
                otpCell.completionVerifyTap = {
                    if (otpCell.txtAnswer.text ?? "") == self.viewModel.strOTP {
                        self.showAlert(with: "OTP verification success.", firstHandler:  { action in
                            self.viewModel.isVerificationSuccess = true
                            self.tblQuestion.reloadData()
                        })
                    }
                    else {
                        self.showAlert(with: "Please enter valid OTP")
                    }
                }
                otpCell.completionEditingComplete = { answer in
                    self.viewModel.arrStaticQuestion[indexPath.row].strAnswer = answer
                    cell.txtAnswer.text = answer
                }
                return otpCell
            }
            cell.completionEditingComplete = { answer in
                self.viewModel.arrStaticQuestion[indexPath.row].strAnswer = answer
                cell.txtAnswer.text = answer
                self.collectionFormGroup.reloadData()
                self.viewModel.checkValidationForSaveButton()
            }
            cell.isSelection = false
            
            cell.lblQuestion.setQuestionTitleAttributedTextLable(index: question.indexNo, question: question.questiontitle(), isMantory: "YES")
            cell.txtAnswer.text = question.strAnswer
            cell.imgCamera.isHidden = true
            if question.id > 2 {
                cell.vwTopBlur.isHidden = self.viewModel.isAllowCollectData
                if question.id == 19 || question.id == 20 {
                    cell.vwTopBlur.isHidden = ((self.viewModel.arrStaticQuestion.filter({$0.id == 18}).first?.strAnswer.lowercased() ?? "") == "yes")
                }
                if question.id == 7 || question.id == 8 || question.id == 9 {
                    cell.vwTopBlur.isHidden = ((self.viewModel.arrStaticQuestion.filter({$0.id == 6}).first?.strAnswer.lowercased() ?? "") == "yes")
                }
                if question.id == 25 || question.id == 26 || question.id == 27 {
                    cell.vwTopBlur.isHidden = ((self.viewModel.arrStaticQuestion.filter({$0.id == 24}).first?.strAnswer.lowercased() ?? "") == "yes")
                }
            }
            else {
                cell.vwTopBlur.isHidden = true
            }
            if question.remark == "Digit 10" {
                cell.maxChacaterLimit = 10
            }
            else if question.remark == "Digit 12" {
                cell.maxChacaterLimit = 12
            }
            
            if question.id == 32 {
                cell.isOnlyAcceptAlphanumeric = true
            }
            else {
                cell.isOnlyAcceptAlphanumeric = false
            }
            if self.viewModel.selectedFormsId != 1 && self.viewModel.selectedFormsId != 4{
                cell.vwTopBlur.isHidden = (question.id == 1 || question.id == 3 || question.id == 32 || question.id == 33)
            }
            
            if question.type == "TEXT" {
                cell.txtAnswer.keyboardType = .default
            }
            else if question.type == "NUMBER" {
                cell.txtAnswer.keyboardType = .numberPad
            }
            else if question.type == "DATETIME" {
                cell.isSelection = true
                cell.completionSelection = {
                    let datePicker = DatePickerDialog()
                    datePicker.show(question.questiontitle(),
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
                            self.viewModel.checkValidationForSaveButton()
                        }
                    }
                }
            }
            else if question.type == "GEO_LOCATION" {
                cell.isSelection = true
                cell.completionSelection = {
                    cell.txtAnswer.text = "\(kAppDelegate.latCurrent),\(kAppDelegate.longCurrent)"
                    question.strAnswer = "\(kAppDelegate.latCurrent),\(kAppDelegate.longCurrent)"
                    self.collectionFormGroup.reloadData()
                    self.viewModel.checkValidationForSaveButton()
                }
            }
            else if question.type == "CAPTURE" {
                cell.imgCamera.isHidden = false
                cell.isSelection = true
                cell.txtAnswer.text = "Capture Image"
                if question.strAnswer != "", let url = getFileFromDocuments(fileName: question.strAnswer) {
                    cell.imgCamera.sd_setImage(with: url)
                }
                else {
                    cell.imgCamera.image = UIImage(systemName: "camera")
                }
                cell.completionSelection = {
                    self.imagePicker.pickImageFromCamera(self) { img in
                        cell.imgCamera.image = img
                        question.imageAnswer = img
                        if let imageData:NSData = img.jpegData(compressionQuality: 0.6) as NSData?  {
                            let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(String(Date().timeIntervalSince1970)).jpeg"
                            duplicateFileToDouments(fileDate: imageData, fileName: fileName)
                            question.strAnswer = fileName
                        }
                        
                        self.collectionFormGroup.reloadData()
                        self.viewModel.checkValidationForSaveButton()
                    }
                }
            }
            else if question.type == "SINGLE_SELECT" || question.type == "Dropdown" {
                if question.strAnswer != "" && self.viewModel.selectedFormsId != 1 && self.viewModel.selectedFormsId != 4 {
                    cell.btnSelection.isEnabled = false
                }
                else {
                    cell.btnSelection.isEnabled = true
                }
                cell.isSelection = true
                cell.completionSelection = {
                    let itemsTitle = self.viewModel.getStaticQuestionOption(question: question)
                    let singleComponetPopupPickerView = AYPopupPickerView()
                    self.view.endEditing(true)
                    singleComponetPopupPickerView.display(itemTitles: itemsTitle.compactMap({$0.name}), doneHandler: {
                        let selectedIndex = singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
                        print("\(itemsTitle[selectedIndex])")
                        cell.txtAnswer.text = itemsTitle[selectedIndex].name
                        question.strAnswer = itemsTitle[selectedIndex].name
                        question.answerId = Int(itemsTitle[selectedIndex].id) ?? 0
                        if question.id == 6{
                            self.viewModel.selectedVillage = ModelVillage(fromDictionary: ["mst_villages_id": itemsTitle[selectedIndex].id,
                                                                                           "village_name": itemsTitle[selectedIndex].name])
                        }
                        if question.id == 2 {
                            self.viewModel.isAllowCollectData = itemsTitle[selectedIndex].name.lowercased() == "yes"
                        }
                        if question.id == 18{
                            self.viewModel.arrStaticQuestion.forEach { que in
                                if que.id == 19 || que.id == 20 {
                                    que.strAnswer = ""
                                }
                            }
                            self.tblQuestion.reloadData()
                        }
                        if question.id == 6 || question.id == 24{
                            self.tblQuestion.reloadData()
                        }
                        self.collectionFormGroup.reloadData()
                        self.viewModel.checkValidationForSaveButton()
                    })
                }
            }
        }
        else {
            cell.btnSelection.isEnabled = true
            cell.vwTopBlur.isHidden = true
            if self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.indices ~= indexPath.row {
                let question = self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row]
                cell.completionEditingComplete = { answer in
                    question.strAnswer = answer
                    cell.txtAnswer.text = answer
                    self.collectionFormGroup.reloadData()
                    self.viewModel.checkValidationForSaveButton()
                }
                
                cell.lblQuestion.setQuestionTitleAttributedTextLable(index: "\(indexPath.row+1)", question: question.title.capitalized, isMantory: question.ismandatory)
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
                        self.view.endEditing(true)
                        singleComponetPopupPickerView.display(itemTitles: itemsTitle, doneHandler: {
                            let selectedIndex = singleComponetPopupPickerView.pickerView.selectedRow(inComponent: 0)
                            print("\(itemsTitle[selectedIndex])")
                            cell.txtAnswer.text = itemsTitle[selectedIndex]
                            question.strAnswer = itemsTitle[selectedIndex]
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()
                        })
                    }
                }
                else if question.questionType == "MULTI_SELECT" || question.questionType == "CHECKBOX" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let vc = ListSelectionVC()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.viewModel.arrList = question.questionOption.compactMap({ ModelListSelection.init(id: String($0.tblFormQuestionsOptionId), name: $0.title)})
                        vc.viewModel.arrSelectedList = question.strAnswer.components(separatedBy: ", ")
                        vc.isMultpalSelection = true
                        vc.viewModel.strTitle = question.title
                        vc.completionMultipalSelection = { answers in
                            cell.txtAnswer.text = answers.compactMap({$0.name}).joined(separator: ", ")
                            question.strAnswer = answers.compactMap({$0.name}).joined(separator: ", ")
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()
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
                                cell.txtAnswer.text = dt.getFormattedString(format: question.format)
                                question.strAnswer = dt.getFormattedString(format: question.format)
                                self.collectionFormGroup.reloadData()
                                self.viewModel.checkValidationForSaveButton()
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
                                cell.txtAnswer.text = dt.getFormattedString(format: question.format)
                                question.strAnswer = dt.getFormattedString(format: question.format)
                                self.collectionFormGroup.reloadData()
                                self.viewModel.checkValidationForSaveButton()
                            }
                        }
                    }
                }
                else if question.questionType == "DATE" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        let datePicker = DatePickerDialog()
                        datePicker.show(question.title,
                                        doneButtonTitle: "Done",
                                        cancelButtonTitle: "Cancel",
                                        defaultDate: Date(),
                                        minimumDate: nil,
                                        maximumDate: nil,
                                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                cell.txtAnswer.text = dt.getFormattedString(format: question.format)
                                question.strAnswer = dt.getFormattedString(format: question.format)
                                self.collectionFormGroup.reloadData()
                                self.viewModel.checkValidationForSaveButton()
                            }
                        }
                    }
                }
                else if question.questionType == "CAPTURE" {
                    cell.imgCamera.isHidden = false
                    cell.isSelection = true
                    cell.txtAnswer.text = "Capture Image"
                    if question.strAnswer != "", let url = getFileFromDocuments(fileName: question.strAnswer) {
                        cell.imgCamera.sd_setImage(with: url)
                    }
                    else {
                        cell.imgCamera.image = UIImage(systemName: "camera")
                    }
                    cell.completionSelection = {
                        self.imagePicker.pickImageFromCamera(self) { img in
                            cell.imgCamera.image = img
                            question.imageAnswer = img
                            if let imageData:NSData = img.jpegData(compressionQuality: 0.6) as NSData?  {
                                let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(String(Date().timeIntervalSince1970)).jpeg"
                                duplicateFileToDouments(fileDate: imageData, fileName: fileName)
                                question.strAnswer = fileName
                            }
                            
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()
                            /*if let imageData:NSData = img.jpegData(compressionQuality: 0.6) as NSData?  {
                                question.strImageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                            }
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()*/
                        }
                    }
                    /*
                     if question.strAnswer != "", let url = getFileFromDocuments(fileName: question.strAnswer) {
                         cell.imgCamera.sd_setImage(with: url)
                     }
                     else {
                         cell.imgCamera.image = UIImage(systemName: "camera")
                     }
                     cell.completionSelection = {
                         self.imagePicker.pickImageFromGallary(self) { img in
                             cell.imgCamera.image = img
                             question.imageAnswer = img
                             if let imageData:NSData = img.jpegData(compressionQuality: 0.6) as NSData?  {
                                 let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(String(Date().timeIntervalSince1970)).jpeg"
                                 duplicateFileToDouments(fileDate: imageData, fileName: fileName)
                                 question.strAnswer = fileName
                             }
                             
                             self.collectionFormGroup.reloadData()
                             self.viewModel.checkValidationForSaveButton()
                         }
                     }
                     */
                }
                else if question.questionType == "FILE" {
                    cell.imgCamera.isHidden = false
                    cell.imgCamera.image = UIImage(systemName: "doc")
                    cell.isSelection = true
                    cell.txtAnswer.text = question.strAnswer == "" ? "Select File" : (question.strAnswer.components(separatedBy: "_").last ?? "")
                    
                    //"\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(path.lastPathComponent)"
                    cell.completionSelection = {
                        self.imagePicker.tag = indexPath.row
                        self.imagePicker.chooseDocument(docType: question.allowFileType.components(separatedBy: ","))
                        self.collectionFormGroup.reloadData()
                        self.viewModel.checkValidationForSaveButton()
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
                                self.viewModel.checkValidationForSaveButton()
                            }
                        }
                    }
                }
                else if question.questionType == "GEO_LOCATION" {
                    cell.isSelection = true
                    cell.completionSelection = {
                        cell.txtAnswer.text = "\(kAppDelegate.latCurrent),\(kAppDelegate.longCurrent)"
                        question.strAnswer = "\(kAppDelegate.latCurrent),\(kAppDelegate.longCurrent)"
                        self.collectionFormGroup.reloadData()
                        self.viewModel.checkValidationForSaveButton()
                    }
                }
                else if question.questionType == "RATING" {
                    guard let cellRating = tableView.dequeueReusableCell(withIdentifier: "RatingQuestionTCell", for: indexPath) as? RatingQuestionTCell else { return UITableViewCell() }
                    
                    cellRating.vwRating.isHidden = false
                    cellRating.vwRangeSiker.isHidden = true
                    if self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions.indices ~= indexPath.row {
//                        cellRating.lblQuestion.text = "\(indexPath.row+1). \(self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].title)"
                        cellRating.lblQuestion.setQuestionTitleAttributedTextLable(index: "\(indexPath.row+1)", question: self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].title, isMantory: question.ismandatory)
                        cellRating.vwRating.rating = Double(self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].strAnswer) ?? 0
                        cellRating.vwRating.didFinishTouchingCosmos = { rating in
                            self.viewModel.arrFormGroup[self.viewModel.selectedGrpIndex].questions[indexPath.row].strAnswer = "\(rating)"
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()
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
//                        cellRating.lblQuestion.text = "\(indexPath.row+1). \(ratingQuestion.title)"
                        cellRating.lblQuestion.setQuestionTitleAttributedTextLable(index: "\(indexPath.row+1)", question: ratingQuestion.title, isMantory: question.ismandatory)
                        cellRating.vwRangeSiker.minValue = CGFloat(ratingQuestion.minLength)
                        cellRating.vwRangeSiker.maxValue = CGFloat(ratingQuestion.maxLength)
                        if ratingQuestion.strAnswer != "" {
                            //                        cellRating.vwRangeSiker.min = CGFloat(ratingQuestion.strAnswer.components(separatedBy: ",").first ?? "") ?? 0.0
                            //                        cellRating.vwRangeSiker.selectedMaxValue = CGFloat(ratingQuestion.strAnswer.components(separatedBy: ",").last ?? "") ?? 0.0
                        }
                        
                        cellRating.completionRangeSelection = { minValue, maxValue in
                            ratingQuestion.strAnswer = "\(minValue),\(maxValue)"
                            self.collectionFormGroup.reloadData()
                            self.viewModel.checkValidationForSaveButton()
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
