//
//  MockTrackers.swift
//  Tracker
//
//  Created by Руслан  on 01.09.2023.
//

import UIKit

let mockTrackers: [TrackerCategory] = [
    TrackerCategory(
        title: "Домашний Уют",
        trackers: [Tracker(
            id: UUID(uuidString: "94E3C0C2-EE00-49EA-B117-8AC36ACBE800")!,
            name: "Поливать растения",
            color: UIColor(named: "Color selection 18") ?? .green,
            emojie: "👑",
            timetable: Optional(["Пн"])
        ), Tracker(
            id: UUID(uuidString: "F323F0BF-D4FF-4156-A853-1EE65B71B4FC")!,
            name: "без расписания",
            color: UIColor(named: "Color selection 16") ?? .green,
            emojie: "❤️",
            timetable: nil)]
    ), TrackerCategory(
        title: "Радостные мелочи",
        trackers: [Tracker(
            id: UUID(uuidString: "CC4CE49C-3F66-437C-D4FF-ECA55DCCA758")!,
            name: "Кошка заслонила камеру на созвоне",
            color: UIColor(named: "Color selection 2") ?? .green,
            emojie: "🌎",
            timetable: Optional(["Вт"])
        ), Tracker(
            id: UUID(uuidString: "F523F0BF-D4FF-4156-3F66-1EE65B71B4FC")!,
            name: "Бабушка прислала открытку в вотсапе",
            color: UIColor(named: "Color selection 3") ?? .green,
            emojie: "☘️",
            timetable: Optional(["Ср"])
        ), Tracker(
            id: UUID(uuidString: "F523F0BF-D4FF-4456-B117-1EE65B71B4FC")!,
            name: "четверг",
            color: UIColor(named: "Color selection 6") ?? .green,
            emojie: "🍄",
            timetable: Optional(["Пн", "Чт"])
        )
        ]
    ), TrackerCategory(
        title: "Самочувствие",
        trackers: [Tracker(
            id: UUID(uuidString: "CC4CE49C-3F66-137C-D4FF-ECA55DCCA758")!,
            name: "Хорошее настроение",
            color: UIColor(named: "Color selection 10") ?? .green,
            emojie: "🌺",
            timetable: Optional(["Сб"])
        ), Tracker(
            id: UUID(uuidString: "F523F0BF-D4FF-4556-137C-1EE65B71B4FC")!,
            name: "тревожность",
            color: UIColor(named: "Color selection 13") ?? .green,
            emojie: "🌞",
            timetable: nil
        ), Tracker(
            id: UUID(uuidString: "F523F0BF-D4FF-4156-D5FF-1EE65B71B4FC")!,
            name: "Свидание в апреле",
            color: UIColor(named: "Color selection 12") ?? .green,
            emojie: "🌈",
            timetable: Optional(["Пн", "Чт"])
        )
        ]
    )
]
