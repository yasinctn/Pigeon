//
//  ViewController.swift
//  Pigeon
//
//  Created by Yasin Cetin on 3.03.2023.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerButton.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20

    }


}

