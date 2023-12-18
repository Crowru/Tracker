//
//  TrackerStore.swift
//  Tracker
//
//  Created by Руслан  on 14.09.2023.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidItem
}

final class TrackerStore: NSObject {
    private let uiColorMarshalling = UIColorMarshalling()
    private let weekdaysMarshalling = WeekdaysMarshalling()
    
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let sortDescriptor = NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        return controller
    }()

    var trackers: [Tracker] {
        guard
            let objects = fetchedResultController.fetchedObjects,
            let trackers = try? objects.map({ try makeTracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistantContainer.viewContext
            self.init(context: context)
        } else {
            fatalError("Unable to access the AppDelegate")
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func makeTracker(from trackersCoreData: TrackerCoreData) throws -> Tracker {
        guard 
            let id = trackersCoreData.trackerID,
            let name = trackersCoreData.name,
            let color = trackersCoreData.color,
            let emojie = trackersCoreData.emojie,
            let timetable = trackersCoreData.timetable
        else {
            throw TrackerStoreError.decodingErrorInvalidItem
        }
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: color),
            emojie: emojie,
            timetable: weekdaysMarshalling.makeWeekDayArrayFromString(timetable)
        )
    }
    
    private func contextSave() {
        do {
            try context.save()
        } catch {
            let error = error as NSError
            assertionFailure(error.localizedDescription)
        }
    }
    
    // MARK: - CRUD
    func createTracker(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emojie = tracker.emojie
        trackerCoreData.timetable = weekdaysMarshalling.makeStringFromArray(tracker.timetable ?? [])
        return trackerCoreData
    }
    
    func updateTracker(with tracker: Tracker) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), tracker.id.uuidString)
        
        do {
            let fetchedTrackers = try context.fetch(request)
            if let trackerToUpdate = fetchedTrackers.first {
                trackerToUpdate.name = tracker.name
                trackerToUpdate.color = uiColorMarshalling.hexString(from: tracker.color)
                trackerToUpdate.emojie = tracker.emojie
                trackerToUpdate.timetable = weekdaysMarshalling.makeStringFromArray(tracker.timetable ?? [])
                
                try context.save()
            } else {
                assertionFailure("Failed to find tracker with UUID: \(tracker.id)")
            }
        } catch {
            assertionFailure("Failed to fetch and update tracker: \(error)")
            throw error
        }
    }
    
    func deleteTracker(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), tracker.id.uuidString)
        guard let trackerRecords = try? context.fetch(request) else {
            assertionFailure("Enabled to fetch(request)")
            return
        }
        context.delete(trackerRecords.first!)
        contextSave()
    }
}
