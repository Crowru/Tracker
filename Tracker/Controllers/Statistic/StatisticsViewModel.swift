//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Руслан  on 18.10.2023.
//

import Foundation

protocol StatisticViewControllerProtocol: AnyObject {
    var completedTrackers: [TrackerRecord] { get set }
}

final class StatisticsViewModel: StatisticViewControllerProtocol {
    // MARK: Public Properties
    @Observable var completedTrackers: [TrackerRecord] = []
    
    // MARK: Private properties
    private let trackerRecordStore = TrackerRecordStore()
    private let statisticsKey = "statisticsTrackersCompleted"
    
    // MARK: Initialisation
    init() {
        completedTrackers = trackerRecordStore.trackerRecords
    }
    
    // MARK: Methods
    func trackersCompletedText() -> String {
        String.localizedStringWithFormat(
            NSLocalizedString(statisticsKey, comment: "Localization for text"), completedTrackers.count)
    }
    func bestPeriod() -> String {
        let ids = completedTrackers.map { $0.id }
        var countDict = [UUID: Int]()
        var maxCount = 0
        ids.forEach { id in
            countDict[id] == nil ? (countDict[id] = 1) : (countDict[id]! += 1)

        }
        for (_, value) in countDict where value > maxCount {
                maxCount = value
        }
        return maxCount.description
    }
}
