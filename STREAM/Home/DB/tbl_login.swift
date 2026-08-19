//
//  tbl_login.swift
//  STREAM
//
//  Created by Danxd on 8/10/26.
//

import Foundation
import SwiftData

@Model
final class tbl_login {
    var id: String
    var userid: Int
    var email: String
    var firstname: String
    var lastname: String
    var jobTitle: String
    var role: String
    
    init(id: String = UUID().uuidString, userid: Int, email: String, firstname: String, lastname: String, jobTitle: String, role: String) {
        self.id = id
        self.userid = userid
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.jobTitle = jobTitle
        self.role = role
    }
}
