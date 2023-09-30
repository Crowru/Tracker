//
//  String + Extention.swift
//  Tracker
//
//  Created by Руслан  on 18.09.2023.
//

import Foundation

extension String {
    func shortStringDayForInt(_ weekDay: Int) -> String {
        switch weekDay {
        case 1: return "Вс"
        case 2: return "Пн"
        case 3: return "Вт"
        case 4: return "Ср"
        case 5: return "Чт"
        case 6: return "Пт"
        case 7: return "Сб"
        default: break
        }
        return ""
    }
    func shortDaysFromLong(for day: String) -> String {
        switch day {
        case "Понедельник": return "Пн"
        case "Вторник": return "Вт"
        case "Среда": return "Ср"
        case "Четверг": return "Чт"
        case "Пятница": return "Пт"
        case "Суббота": return "Сб"
        case "Воскресенье": return "Вс"
        default: return ""
        }
    }
}
