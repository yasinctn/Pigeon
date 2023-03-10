//
//  RegisterViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 3.03.2023.
//

import UIKit
import Firebase
import FirebaseCore


class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerMailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 15
        
    }
    
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        
        if registerMailTextField.text != ""{
            if registerPasswordTextField.text == ""{
                presentAllert("password empty \nPlease type a pasword")
            }else{
                
                if let mail = registerMailTextField.text,
                   let password = registerPasswordTextField.text{
                    
                    Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                        if let error = error{
                            self.presentAllert(error.localizedDescription)
                            
                        }else{
                            self.presentAllertWithAction()
                        }
                    }
                }
            }
        }else{
            presentAllert("e mail empty \nPlease type an e mail")
            
        }
    }
    
    
    
    func presentAllert(_ message:String){
        
        let allert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func presentAllertWithAction(){
        let allert = UIAlertController(title: "Register Successful", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Go To Chat", style: .default) { action in
            self.performSegue(withIdentifier: "registerToChat", sender: action)
        }
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    
    
    
}
