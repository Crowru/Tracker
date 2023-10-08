//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Руслан  on 14.09.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
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
        guard let id = trackerRecordsCoreData.trackerId,
              let date = trackerRecordsCoreData.date
        else { throw TrackerStoreError.decodingErrorInvalidItem }
        return TrackerRecord(id: id, date: date)
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
    func createTrackerRecord(from trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        contextSave()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
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
