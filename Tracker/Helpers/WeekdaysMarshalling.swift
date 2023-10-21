//
//  WeekdaysMarshalling.swift
//  Tracker
//
//  Created by Руслан  on 16.09.2023.
//

import Foundation

final class WeekdaysMarshalling {
    private let weekdays: [String] = [
        "Mon".localised(),
        "Tue".localised(),
        "Wed".localised(),
        "Thu".localised(),
        "Fri".localised(),
        "Sat".localised(),
        "Sun".localised()
    ]
    
    func makeStringFromArray(_ timetable: [String]) -> String {
        var string = ""
        for day in weekdays {
            if timetable.contains(day) {
                string += "1"
            } else {
                string += "0"
            }
        }
        return string
    }
    
    func makeWeekDayArrayFromString(_ timetable: String?) -> [String] {
        var array: [String] = []
        if let timetable = timetable {
            timetable.enumerated().forEach { index, character in
                if character == "1" {
                    array.append(weekdays[index])
                }
            }
        }
        
        return array
    }
}
