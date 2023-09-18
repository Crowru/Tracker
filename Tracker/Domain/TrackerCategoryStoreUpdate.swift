//
//  TrackerCategoryStoreUpdate.swift
//  Tracker
//
//  Created by Руслан  on 17.09.2023.
//

import Foundation

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
