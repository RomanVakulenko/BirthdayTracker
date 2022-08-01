//
//  Birthday.swift
//  Birthdays
//
//  Created by Roman Vakulenko on 01.08.2022.
//

import Foundation

class Birthday {
    let firstName, lastName: String
    let birthdate: Date
    
    init(firstName: String, lastName: String, birthdate: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
    }
}
