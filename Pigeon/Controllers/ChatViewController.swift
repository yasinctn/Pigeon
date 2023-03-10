//
//  ChatViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 3.03.2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class ChatViewController: UIViewController,UITableViewDelegate {
    
    var messages: [Message] = []
    let db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser?.email
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatsTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        chatsTableView.separatorStyle = .none
        chatsTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        getData()

        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "CHATS"
        
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let message = messageTextField.text,let user = Auth.auth().currentUser?.email{
            
            db.collection("AllMessages").addDocument(data: [
                "sender": user,
                "message": message,
                "date": Date().formatted(),
                "order": Date().timeIntervalSince1970
            ]) { error in
                if let error = error {
                    self.presentAllert("\(error)", "Error Writing Document")
                } else {
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
            }
        }
        
        
}
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            presentAllertWithAction()
            
        } catch let signOutError as NSError {
            
            presentAllert("\(signOutError)", "Sign Out Error")
            
        }
        
        
    }
    
    func getData (){
        
        let docRef = db.collection("AllMessages")

        docRef.order(by: "order").addSnapshotListener({ (querySnapshot, err) in
            
            self.messages = []
            if let err = err {
                self.presentAllert("\(err)", "Error Getting Documents")
            }
            else {
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String,
                            let messageBody = data["message"] as? String,
                            let messageDate = data["date"] as? String{
                            
                            let newMessage = Message(body: messageBody,
                                                     sender: messageSender,
                                                     date: messageDate)
                            
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.chatsTableView.reloadData()
                                let indexPath = IndexPath(row:self.messages.count - 1, section: 0)
                                self.chatsTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            }
                        }
                    }
                }
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        })
    }
    
    
    
    
    
    func presentAllert(_ message:String, _ title: String){
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func presentAllertWithAction(){
        let allert = UIAlertController(title: "Log out Successful", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        }
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    
    
    
    
}


extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]

        cell.messageLabel.text = message.body      
        
        if currentUser == message.sender{
            
            cell.messageLabel.textAlignment = .right
            cell.rightTopLabel.text = message.sender
            cell.rightTopLabel.textAlignment = .right
            cell.leftTopLabel.text = message.date
            cell.messageView.backgroundColor = UIColor(named: "BrandLightBlue")
            cell.rightImgView.isHidden = true
            

        }else{
            cell.messageLabel.textAlignment = .left
            cell.rightTopLabel.textAlignment = .right
            cell.leftTopLabel.text = message.sender
            cell.rightTopLabel.text = message.date
            cell.messageView.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.leftImgView.isHidden = true

        }
        
        
        return cell
        
    }
    

}
