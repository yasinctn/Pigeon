//
//  Messages.swift
//  Pigeon
//
//  Created by Yasin Cetin on 4.03.2023.
//

import Foundation

struct Message {
    let sender : String
    let body : String
    let date : String
    
    
    init(body: String, sender: String, date: String) {
        self.sender = sender
        self.body = body
        self.date = date
        
    }
}
