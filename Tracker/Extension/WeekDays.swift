//
//  WeekDays.swift
//  Tracker
//
//  Created by Руслан  on 10.10.2023.
//

import Foundation

extension WeekDays {
    // MARK: Short String day from Int
    static subscript(index: Int) -> String {
        switch index {
        case 1: "Sun".localised()
        case 2: "Mon".localised()
        case 3: "Tue".localised()
        case 4: "Wed".localised()
        case 5: "Thu".localised()
        case 6: "Fri".localised()
        case 7: "Sat".localised()
        default: "\(assert(indexIsValid(index: index), "Index out of range"))"
        }
    }
    
    // MARK: Short days from long
    static subscript(index: String) -> String {
        switch index {
        case WeekDays.monday.localize(): "Mon".localised()
        case WeekDays.tuesday.localize(): "Tue".localised()
        case WeekDays.wednesday.localize(): "Wed".localised()
        case WeekDays.thursday.localize(): "Thu".localised()
        case WeekDays.friday.localize(): "Fri".localised()
        case WeekDays.saturday.localize(): "Sat".localised()
        case WeekDays.sunday.localize(): "Sun".localised()
        default: "\(assert(indexIsValid(index: 0), "Index out of range"))"
        }
    }
    static func indexIsValid(index: Int) -> Bool {
        index > 0 && index <= 7
    }
}
