//
//  ChatViewController.swift
//  Flash Chat iOS13
//  Created by JPL-ST-SPRING2022 on 5/4/22.

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    // fire store database instance
    let db = Firestore.firestore()
    
    var messages: [Message] = [
//        Message(sender: "1@2.com", body: "Hey!"),
//        Message(sender: "a@b.com", body: "Hello!"),
//        Message(sender: "1@2.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // self as data source
        tableView.dataSource = self
        //        tableView.delegate = self --> no needed
        // register custom cell
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //        pull out the data from firebase
        loadMessages()
    }
    
    func loadMessages(){

        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{(querySnapshot, error  ) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                }else {
                    self.messages = []
                    // query documents from FireBase
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                // create new instance of Message struct
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                // update view
                                DispatchQueue.main.async {
                                    // reload date from Internet
                                    self.tableView.reloadData()
                                    // move to last item in table view
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0) // we don't have section yet
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{ // get current user's email
            // add one to database
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print ("there was an issue saving data to firestore, \(e)")
                }else {
                    print("succesfully saved data.")
                    // clean out the message field
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    // log out pressed
    @IBAction func logOPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            // move to root VC
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError { //up cast to
            print("Error signing out: %@", signOutError)
        }
    }
}

// in the duty of cell's data
extension ChatViewController : UITableViewDataSource {
    // define number of rows, in our case, it equals the count of messages
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    // define a row of a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        // get cell from customized MessageCell
        // index path contains both row number and session
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCell
        // down cast to our customized Nib or Cell
        cell.label.text = messages[indexPath.row].body
        
        // this is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messsageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else {
            // mes grom another user.
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messsageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}
