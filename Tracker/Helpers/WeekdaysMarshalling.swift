//
//  WeekdaysMarshalling.swift
//  Tracker
//
//  Created by Руслан  on 16.09.2023.
//

import Foundation

final class WeekdaysMarshalling {
    private let weekdays: [String] = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
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
