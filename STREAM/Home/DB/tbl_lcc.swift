//
//  tbl_lcc.swift
//  STREAM APP
//
//  Created by Danxd on 7/21/26.
//

import Foundation
import SwiftData

@Model
final class tbl_lcc {
    var id: String
    var rhid: String
    var step: String
    var opname: String
    var slname: String
    
    init(id: String = UUID().uuidString, rhid: String, step: String, opname: String, slname: String) {
        self.id = id
        self.rhid = rhid
        self.step = step
        self.opname = opname
        self.slname = slname
    }
}
