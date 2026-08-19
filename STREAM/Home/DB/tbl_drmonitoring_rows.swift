//
//  tbl_drmonitoring_rows.swift
//  STREAM
//
//  Created by Danxd on 7/24/26.
//

import SwiftData
import Foundation

@Model
final class tbl_drmonitoring_rows {

    var dmid: String
    var dhid: String
    var noh: String
    var date: String
    var time: String
    var upper: String
    var lower: String
    var boiler: String
    var mc: String
    var status: String
    var remarks: String?

    init(dmid: String, dhid: String, noh: String, date: String, time: String, upper: String, lower: String, boiler: String, mc: String, status: String, remarks: String? = nil) {
        self.dmid = dmid
        self.dhid = dhid
        self.noh = noh
        self.date = date
        self.time = time
        self.upper = upper
        self.lower = lower
        self.boiler = boiler
        self.mc = mc
        self.status = status
        self.remarks = remarks
    }
}
