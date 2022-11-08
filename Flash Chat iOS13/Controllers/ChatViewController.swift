//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let dataBaseRef = Firestore.firestore()
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = Constants.appName
        tableView.dataSource = self
        tableView.register(.init(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        dataBaseRef.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener({
            [weak self] snapShot, error in
            
            guard let self = self else {return}
            
            if let error = error {
                print("Error retreavig data: \(error.localizedDescription)")
                
            } else if let snapShot = snapShot {
                let documents = snapShot.documents
                self.messages.removeAll()
                for doc in documents {
                    let data = doc.data()
                    guard let sender = data[Constants.FStore.senderField] as? String else {return}
                    guard let body = data[Constants.FStore.bodyField] as? String else {return}
                    let message = Message(sender: sender, body: body)
                    self.messages.append(message)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    self.tableView.scrollToRow(at: index, at: .top, animated: true)
                }
            }
        })
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let sender = Auth.auth().currentUser?.email, let message = messageTextfield.text {
            dataBaseRef.collection(Constants.FStore.collectionName).addDocument(data: [
            
                Constants.FStore.senderField: sender,
                Constants.FStore.bodyField: message,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ], completion: {
                error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Success")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            })
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as! MessageCell
        cell.bodyTextLabel.text = message.body
        if message.sender == Auth.auth().currentUser?.email {
            cell.avatarImageView.isHidden = false
            cell.youAvatarImageView.isHidden = true
            cell.bubbleView.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.bodyTextLabel.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            cell.avatarImageView.isHidden = true
            cell.youAvatarImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.bodyTextLabel.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        return cell
          
    }
}
