//
//  EditTaskController.swift
//  Clipboard
//
//  Created by Xavier La Rosa on 1/4/20.
//  Copyright © 2020 Xavier La Rosa. All rights reserved.
//

import UIKit

class EditTaskController: UIViewController {
    static var task = Task(title: "Default", status: "Default", difficulty: "Default")
    static var backupTask = Task(title: "Default", status: "Default", difficulty: "Default")
    private var pickerData = [Constants.statuses, Constants.difficulties]
    private var datePickerView: UIDatePicker?
    private var pickerView: UIPickerView?
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var assignedToTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    static func setTask(task:Task){
        self.task = task
        self.backupTask = task
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Task"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditTaskController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        guard let memberNames = Constants.getMemberNames() else {return}
        pickerData.append(memberNames)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        datePickerView = UIDatePicker()
        dueDateTextField.inputView = datePickerView
        datePickerView?.datePickerMode = .date
        datePickerView?.addTarget(self, action: #selector(EditTaskController.dateChanged(datePicker: )), for: .valueChanged)
        
        displayOriginalTask()
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        statusTextField.inputView = pickerView
        difficultyTextField.inputView = pickerView
        assignedToTextField.inputView = pickerView
        
        resetButton.createStandardHollowButton(color: UIColor.purple, backColor: UIColor.white)
        editButton.createStandardFullButton(color: UIColor.purple, fontColor: UIColor.white)
        deleteButton.createStandardFullButton(color: UIColor.red, fontColor: UIColor.white)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        displayOriginalTask()
    }
    
    func displayOriginalTask(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatShort
        startDateLabel.text = dateFormatter.string(from: EditTaskController.backupTask.getStartDate())
        titleTextField.text = EditTaskController.backupTask.getTitle()
        statusTextField.text = EditTaskController.backupTask.getStatus()
        difficultyTextField.text = EditTaskController.backupTask.getDifficulty()
        assignedToTextField.text = EditTaskController.backupTask.getAssignedTo()?.getName()
        descriptionTextField.text = EditTaskController.backupTask.getDescription()
        commentTextField.text = ""
        guard let date = EditTaskController.backupTask.getDueDate() else {return}
        dueDateTextField.text = dateFormatter.string(from: date)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        guard let tasks = Constants.currProject.getTeam()?.getTasks() else {return}
        for task in tasks {
            if(task.getTitle() == EditTaskController.backupTask.getTitle()){
                task.setTitle(title: titleTextField.text ?? "")
                task.setStatus(status: statusTextField.text!)
                task.setDifficulty(difficulty: difficultyTextField.text!)
                if(assignedToTextField.hasText){
                    for mem in (Constants.currProject.getTeam()?.getMembers())! {
                        if(mem.getName() == assignedToTextField.text){
                            task.setAssignedTo(member: mem)
                            break
                        } else if(assignedToTextField.text == "none"){
                            task.resetAssignedTo()
                            break
                        }
                    }
                }
                guard let date = datePickerView?.date else {return}
                task.setDueDate(date: date)
                task.setDescription(description: descriptionTextField.text ?? "")
                
                if(commentTextField.hasText){
                    task.addComment(comment: Comment(comment: commentTextField.text!))
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatShort
        dueDateTextField.text = dateFormatter.string(from: datePickerView!.date)
        view.endEditing(true)
    }
}

extension EditTaskController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(Constants.statuses.contains(pickerData[component][row]) ){
            statusTextField.text = pickerData[component][row]
        } else if (Constants.difficulties.contains(pickerData[component][row])){
            difficultyTextField.text = pickerData[component][row]
        } else if ((Constants.getMemberNames()?.contains(pickerData[component][row]))!){
            assignedToTextField.text = pickerData[component][row]
        }
    }
    
}

extension EditTaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditTaskController.task.getComments().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "commentCell")

        guard let comment = EditTaskController.task.getComments()[indexPath.row].getComment() else {return cell}
        guard let date = EditTaskController.task.getComments()[indexPath.row].getDate() else {return cell}
        cell.textLabel?.text = comment
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatLong

        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        view.endEditing(true)
        
        return cell
    }
    
    
}
