//
//  LogInViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 3.03.2023.
//

import UIKit
import Firebase
import FirebaseCore

class LogInViewController:UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginMailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 15
        
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        
        if loginMailTextField.text != ""{
            if loginPasswordTextField.text == ""{
                presentAllert("password empty \nPlease type a pasword", "OK")
            }else{
                
                if let mail = loginMailTextField.text,
                   let password = loginPasswordTextField.text{
                    
                    Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
                        
                        if let error = error{
                            self.presentAllert(error.localizedDescription, "OK")
                            
                        }else{
                            self.presentAllertWithAction()
                        }
                    }
                }
            }
        }else{
            presentAllert("e mail empty \nPlease type an e mail", "OK")
        }
    }
    
    
    
    
    
    
    func presentAllert(_ message:String, _ buttonTitle:String){
        
        let allert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func presentAllertWithAction(){
        let allert = UIAlertController(title: "Login Successful", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Go to Chat", style: .default) { action in
            self.performSegue(withIdentifier: "loginToChat", sender: action)
        }
        allert.addAction(action)
        self.present(allert, animated: true)
    }
}
