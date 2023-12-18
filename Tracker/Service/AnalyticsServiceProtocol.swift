//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Руслан  on 15.10.2023.
//

import Foundation

protocol AnalyticsServiceProtocol: Any {
    static func activateAnalytics()
    static func openScreenReport(screen: ScreenName)
    static func closeScreenReport(screen: ScreenName)
    static func addTrackReport()
    static func editTrackReport()
    static func deleteTrackReport()
    static func addFilterReport()
    static func clickRecordTrackReport()
    static func clickHabitReport()
    static func clickIreggularEventReport()
    static func clickCreateTrackerReport()
    static func clickExitViewNewTracker()
}
