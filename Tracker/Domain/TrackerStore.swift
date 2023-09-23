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
    private let uiCollorMarshalling = UIColorMarshalling()
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
            color: uiCollorMarshalling.color(from: color),
            emojie: emojie,
            timetable: weekdaysMarshalling.makeWeekDayArrayFromString(timetable)
        )
    }
    
    // MARK: - CRUD
    func createTracker(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiCollorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emojie = tracker.emojie
        trackerCoreData.timetable = weekdaysMarshalling.makeStringFromArray(tracker.timetable ?? [])
        return trackerCoreData
    }
    
    func deleteTracker(with id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), id.uuidString)
        let trackers = try context.fetch(request)
        if let trackerDelete = trackers.first {
            context.delete(trackerDelete)
            do {
                try context.save()
            } catch {
                print("Failed to save context after deleting tracker: \(error)")
                throw error
            }
        }
    }
}
