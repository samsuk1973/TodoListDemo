//
//  AddTaskViewController.swift
//  TaskApp
//
//  Created by Mac_mojave-2k19(2) 
//  Copyright © 2019 Mac_mojave-2k19(2). All rights reserved.

import UIKit
import FirebaseFirestore
import RxSwift
import SQLite3
import ActionSheetPicker_3_0
import SwiftMessages

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var standardTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    private var tasks = [Task]()
    
    var isUpdate : Bool = false
    var updateName : String = ""
    var updateSchool : String = ""
    var updateStandard : String = ""
    var updateID : String = ""
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure UI properties for better experience
        nameTextField.delegate = self
        nameTextField.layer.borderWidth = 1.5
        nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        nameTextField.layer.cornerRadius = 8
        
        standardTextField.delegate = self
        standardTextField.layer.borderWidth = 1.5
        standardTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        standardTextField.layer.cornerRadius = 8
        
        schoolTextField.delegate = self
        schoolTextField.layer.borderWidth = 1.5
        schoolTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        schoolTextField.layer.cornerRadius = 8
        
        addTaskButton.layer.cornerRadius = 8
        
        // below method will open database and will be used for data insertion and updation.
        openDatabase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //configure UI
        mainBackView.layer.shadowColor = UIColor.gray.cgColor
        mainBackView.layer.shadowOpacity = 0.7
        mainBackView.layer.shadowOffset = CGSize.zero
        mainBackView.layer.shadowRadius = 4.5
        mainBackView.layer.cornerRadius = 8.0
        
        if isUpdate
        {
            nameTextField.text = updateName
            schoolTextField.text = updateSchool
            standardTextField.text = updateStandard
            addTaskButton.setTitle("Update Task", for: .normal)
            self.title = "Update Task"
        }else
        {
            addTaskButton.setTitle("Add Task", for: .normal)
            self.title = "Add Task"
            print(self.title)
        }
    }
    
    // MARK:- OpenDatabase
    
    func openDatabase()
    {
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Student.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
        }else
        {
            print("successfully opened database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Student (id TEXT, name TEXT, standard INTEGER, school TEXT)", nil, nil, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }else
        {
            print("successfully created table")
            
        }
        
    }
    
    //MARK:- Insert data
    
    let insertStatementString = "INSERT INTO Student (name, standard ,school) VALUES (?,?,?);"
    
    func insert()
    {
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            let name: NSString = nameTextField.text! as NSString
            let standard : Int32 = Int32(standardTextField!.text!)!
            let school: NSString = schoolTextField.text! as NSString
            
            sqlite3_bind_int(insertStatement, 3, Int32(standard))
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, school.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
            } else
            {
                print("Could not insert row.")
            }
        } else
        {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK:- Update data
    func update(id: String,name: String, standard: Int32, school: String) {
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, "UPDATE Student SET name = '\(name)',school = '\(school)', standard = \(standard) WHERE id = '\(id)';", -1, &updateStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("Successfully updated row.")
            } else
            {
                print("Could not update row.")
            }
        } else
        {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    //MARK:- Button Action
    @IBAction func addTaskButton(_ sender: Any)
    {
        if isUpdate == false
        {
            addTaskButton.setTitle("Add Task", for: .normal)
            if(nameTextField.text == ""){
                messageBar.MessageShow(title: "Please enter name", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else if(schoolTextField.text == "")
            {
                messageBar.MessageShow(title: "Please enter school", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else if(standardTextField.text == "")
            {
                messageBar.MessageShow(title: "Please enter standard", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else
            {
                
                if Reachability.isConnectedToNetwork()
                {
                    let db = Firestore.firestore()
                    db.collection("students").rx.base
                        .addDocument(data: [
                            "name": nameTextField.text!,
                            "school": schoolTextField.text!,
                            "standard": standardTextField.text!,
                        ]) { (err) in
                            if let err = err {
                                messageBar.MessageShow(title: err.localizedDescription as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
                            } else {
                                messageBar.MessageShow(title: "Successfully added Task", alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
                            }
                    }
                    //insert into local database
                    insert()
                    self.navigationController?.popViewController(animated: true)
                }else
                {
                    //if internet is not connected
                    messageBar.MessageShow(title: "Please connect to internet", alertType: MessageView.Layout.cardView, alertTheme: .warning, TopBottom: true)
                }
            }
        }else if isUpdate
        {
            addTaskButton.setTitle("Update Task", for: .normal)
            
            //if any field is empty messegeBar will show an alert
            if(nameTextField.text == "")
            {
                messageBar.MessageShow(title: "Please enter name", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else if(schoolTextField.text == "")
            {
                messageBar.MessageShow(title: "Please enter school", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else if(standardTextField.text == "")
            {
                messageBar.MessageShow(title: "Please enter standard", alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
            }else
            {
                if Reachability.isConnectedToNetwork()
                {
                    let db = Firestore.firestore()
                    db.collection("students").rx.base
                        .whereField("name", isEqualTo: updateName)
                        .getDocuments() { (querySnapshot, err) in
                            if err != nil {
                                // Some error occured
                            } else if querySnapshot!.documents.count != 1 {
                                // Perhaps this is an error for you?
                            } else {
                                let document = querySnapshot!.documents.first
                                document?.reference.updateData([
                                    "name": self.nameTextField.text!,
                                    "school": self.schoolTextField.text!,
                                    "standard": self.standardTextField.text!,
                                ]){ (err) in
                                    if let err = err {
                                        messageBar.MessageShow(title: err.localizedDescription as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
                                    } else {
                                        messageBar.MessageShow(title: "Successfully updated task", alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
                                    }
                                }
                            }
                    }
                    
                    
                    //update in local
                    update(id: updateID, name: nameTextField.text!, standard: Int32(standardTextField.text!)!, school: schoolTextField.text!)
                    isUpdate = false
                    self.navigationController?.popViewController(animated: true)
                    
                }else
                {
                    
                    //if internet is not connected
                    messageBar.MessageShow(title: "Please connect to internet", alertType: MessageView.Layout.cardView, alertTheme: .warning, TopBottom: true)
                    
                }
            }
        }
    }
}


