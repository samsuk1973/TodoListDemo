//
//  Task.swift
//  Task Demo
//
//  Created by mac_5 
//  Copyright © 2019 Mac_mojave-2k19(2). All rights reserved.
//

import Foundation

class Task {
    let id: String
    var name: String
    var school: String
    var standard: String
    
    init(id: String) {
        self.id = id
        name = ""
        school = ""
        standard = ""
    }
    
    init(id: String, name: String, school: String, standard: String) {
        self.id = id
        self.name = name
        self.school = school
        self.standard = standard
    }
}
