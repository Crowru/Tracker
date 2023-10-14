//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Руслан  on 27.09.2023.
//

import Foundation

@propertyWrapper
struct Defaults<T> {
    let key: String
    var storage: UserDefaults = .standard
    
    var wrappedValue: T? {
        get {
            return storage.value(forKey: key) as? T
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}
final class UserDefaultsManager {
    @Defaults<Bool>(key: "showIrregularEvent") static var showIrregularEvent
    @Defaults<Bool>(key: "totalTimesLaunching") static var totalTimesLaunching
    @Defaults<[String]>(key: "categoriesArray") static var categoriesArray
    @Defaults<[String]>(key: "timetableArray") static var timetableArray
    @Defaults<Int>(key: "editingIndexPath") static var editingIndexPath
    @Defaults<Int>(key: "completedTrackers") static var completedTrackers
}
