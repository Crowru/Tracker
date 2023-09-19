//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Руслан  on 01.09.2023.
//

import UIKit

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    var days: Int
}
