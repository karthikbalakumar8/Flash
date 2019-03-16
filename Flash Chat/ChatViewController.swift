//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var keyboardHeight : CGFloat = 0.0
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.separatorStyle = .none
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageTableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()

        
    }
    

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatGreen()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func messageTableViewTapped() {
        
        messageTextfield.endEditing(true)
        
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        
        messageTableView.rowHeight = UITableView.automaticDimension
        
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 321
            self.view.layoutIfNeeded()
        }
        
    }

    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //TODO: Send the message to Firebase and save it in our database
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["sendor": Auth.auth().currentUser?.email, "messageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print("kb1 error occured : \(error!)")
            } else {
                self.messageTextfield.text = ""
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let sendor = snapshotValue["sendor"]
            let messageBody = snapshotValue["messageBody"]
            
            let message = Message()
            
            message.messageBody = messageBody!
            message.sender = sendor!
            
            self.messageArray.append(message)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        }
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
        } catch {
            print("error signing out")
        }
        
        guard (navigationController?.popViewController(animated: true)) != nil
            else {
                print("No View Controller to pop off")
                return
        }
        
    }
    
}
