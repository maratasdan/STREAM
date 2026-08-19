//
//  tbl_drying_header.swift
//  STREAM
//
//  Created by Danxd on 7/24/26.
//

import Foundation
import SwiftData

@Model
final class tbl_drying_header {
    var dhid: String
    var rhid: String
    var initial_mc: String
    var drying_start: String
    var est_drying_end: String
    var reversal: String
    var blower: String
    var bin_id: String
    var hybrid: String
    var statis: String
    var topup_new_mc: String?
    
    init(dhid: String, rhid: String, initial_mc: String, drying_start: String, est_drying_end: String, reversal: String, blower: String, bin_id: String, hybrid: String, statis: String, topup_new_mc: String? = nil) {
        self.dhid = dhid
        self.rhid = rhid
        self.initial_mc = initial_mc
        self.drying_start = drying_start
        self.est_drying_end = est_drying_end
        self.reversal = reversal
        self.blower = blower
        self.bin_id = bin_id
        self.hybrid = hybrid
        self.statis = statis
        self.topup_new_mc = topup_new_mc
    }
}
