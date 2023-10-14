//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Руслан  on 15.10.2023.
//

import Foundation

protocol AnalyticsServiceProtocol: Any {
    func activateAnalytics()
    func openScreenReport(screen: ScreenName)
    func closeScreenReport(screen: ScreenName)
    func addTrackReport()
    func editTrackReport()
    func deleteTrackReport()
    func addFilterReport()
    func clickRecordTrackReport()
    func clickHabitReport()
    func clickIreggularEventReport()
    func clickCreateTrackerReport()
    func clickExitViewNewTracker()
}
