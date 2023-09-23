//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Руслан  on 14.09.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    // MARK: Properties
    private let context: NSManagedObjectContext
    
    // MARK: FetchedResultController
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let sortDescriptor = NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        try? controller.performFetch()
        return controller
    }()
    
    var trackerRecords: [TrackerRecord] {
        guard let objects = fetchedResultController.fetchedObjects,
              let trackerRecords = try? objects.map({ try makeTrackerRecord(from: $0) })
        else { return [] }
        return trackerRecords
    }
    
    // MARK: Initialisation
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
    
    // MARK: Functions
    func makeTrackerRecord(from trackerRecordsCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        let days = trackerRecordsCoreData.days
        guard let id = trackerRecordsCoreData.trackerId,
              let date = trackerRecordsCoreData.date
        else { throw TrackerStoreError.decodingErrorInvalidItem }
        return TrackerRecord(id: id, date: date, days: Int(days))
    }
    private func contextSave() {
        do {
            try context.save()
        } catch {
            let error = error as NSError
            assertionFailure(error.localizedDescription)
        }
    }
    
    // MARK: CRUD
    func createTrackerRecord(from trackerRecord: TrackerRecord) throws -> TrackerRecordCoreData {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.days = Int32(trackerRecord.days)
        contextSave()
        return trackerRecordCoreData
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        guard let objects = fetchedResultController.fetchedObjects else { return }
        _ = objects.last { trackerRecordCoreData in
            if trackerRecordCoreData.trackerId == trackerRecord.id {
                context.delete(trackerRecordCoreData)
            }
            return true
        }
        contextSave()
    }
    
    func deleteTrackerRecord(with id: UUID) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), id.uuidString)
        guard let trackerRecords = try? context.fetch(request) else {
            assertionFailure("Enabled to fetch(request)")
            return
        }
        if let trackerRecordDelete = trackerRecords.first {
            context.delete(trackerRecordDelete)
            contextSave()
        }
    }
}






//import UIKit
//import CoreData
//
//enum TrackerRecordStoreError: Error {
//    case decodingErrorInvalidId
//    case decodingErrorInvalidDate
//}
//
//final class TrackerRecordStore: NSObject {
//    private let context: NSManagedObjectContext
//    
//    private lazy var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//        let sortDescriptor = NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        let controller = NSFetchedResultsController(
//            fetchRequest: request,
//            managedObjectContext: context,
//            sectionNameKeyPath: nil,
//            cacheName: nil
//        )
//        try? controller.performFetch()
//        return controller
//    }()
//    
//    var records: Set<TrackerRecord> {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//        request.returnsObjectsAsFaults = false
//        let objects = try? context.fetch(request)
//        var records: Set<TrackerRecord> = []
//        objects?.forEach({ trackerRecordCoreData in
//            do {
//                let record = try makeTrackerRecord(from: trackerRecordCoreData)
//                records.insert(record)
//            } catch {
//                print("Error creating a TrackerRecord from trackerRecordCoreData: \(error)")
//            }
//        })
//        return records
//    }
//    
//    convenience override init() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
//        self.init(context: context)
//    }
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    private func makeTrackerRecord(
//        from trackerRecordCoreData: TrackerRecordCoreData
//    ) throws -> TrackerRecord {
//        guard let id = trackerRecordCoreData.trackerId else {
//            throw TrackerRecordStoreError.decodingErrorInvalidId
//        }
//        
//        guard let date = trackerRecordCoreData.date else {
//            throw TrackerRecordStoreError.decodingErrorInvalidDate
//        }
//        
//        return TrackerRecord(
//            id: id,
//            date: date
//        )
//    }
//    // MARK: - CRUD
//    func addRecord(_ record: TrackerRecord) throws {
//        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
//        trackerRecordCoreData.trackerId = record.id
//        trackerRecordCoreData.date = record.date
//        var currentTracker: TrackerCoreData?
//        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
//        let trackers = try context.fetch(request)
//        trackers.forEach { tracker in
//            if tracker.trackerID == record.id {
//                currentTracker = tracker
//            }
//        }
//        trackerRecordCoreData.tracker = currentTracker
//        try context.save()
//    }
//    
//    func deleteRecord(_ record: TrackerRecord) throws {
//        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), record.id.uuidString)
//        let records = try context.fetch(request)
//        guard let deleteRecord = records.first else { return }
//        context.delete(deleteRecord)
//        try context.save()
//    }
//}
