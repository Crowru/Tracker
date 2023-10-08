//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Руслан  on 30.09.2023.
//

import Foundation

protocol AddNewСategoryViewControllerDelegate: AnyObject {
    func editCategory(_ editText: String)
    func addCategory(_ text: String)
}

final class CategoriesViewModel {
    var editingIndexPath: IndexPath? {
        didSet {
            UserDefaultsManager.editingIndexPath = editingIndexPath?.row
        }
    }
    
    weak var delegate: NewTrackerViewControllerProtocol?
    
    @Observable private(set) var categories: [TrackerCategory] = []
    private var categoryStore: TrackerCategoryStore = TrackerCategoryStore()
    
    // MARK: Functions
    func dataIndexesCategories() {
        guard let row = UserDefaultsManager.editingIndexPath else { return }
        editingIndexPath = IndexPath(row: row, section: 0)
        categories = categoryStore.categories
    }
    func addNewCategory(isEdit: Bool = false, text: String? = nil) -> AddNewCategoryViewController {
        let addNewCategoryViewController = AddNewCategoryViewController()
        addNewCategoryViewController.delegate = self
        addNewCategoryViewController.editText = text
        addNewCategoryViewController.isEdit = isEdit
        return addNewCategoryViewController
    }
    
    func changeCategoryText() -> String? {
        if let editingIndexPath = editingIndexPath {
            let editText = categories[editingIndexPath.row].title
            return editText
        }
        return nil
    }
    func deleteCategories(indexPath: IndexPath) {
        deleteCategory(at: indexPath)
    }
    func addDetailCategory(_ text: String) {
        delegate?.addDetailCategory(text)
    }
}

// MARK: - AddNewСategoryDelegate
extension CategoriesViewModel: AddNewСategoryViewControllerDelegate {
    func editCategory(_ editText: String) {
        if let editingIndexPath = editingIndexPath {
            editCategory(at: editingIndexPath, with: editText)
        }
    }
    func addCategory(_ text: String) {
        addNewCategory(text)
    }
}

// MARK: - CoreData
private extension CategoriesViewModel {
    func addNewCategory(_ text: String) {
        do {
            let newCategory = TrackerCategory(title: text, trackers: [])
            try categoryStore.createCategory(newCategory)
            categories = categoryStore.categories
        } catch {
            assertionFailure("Error of adding category: \(error.localizedDescription)")
        }
    }
    func editCategory(at indexPath: IndexPath, with newText: String) {
        let oldCategory = categories[indexPath.row]
        do {
            let newCategory = TrackerCategory(title: newText, trackers: oldCategory.trackers)
            try categoryStore.updateCategory(oldCategory, with: newText)
            categories[indexPath.row] = newCategory
            categories = categoryStore.categories
        } catch {
            assertionFailure("Error of editing category: \(error.localizedDescription)")
        }
    }
    func deleteCategory(at indexPath: IndexPath) {
        do {
            let category = categories[indexPath.row]
            try categoryStore.deleteCategory(with: category.title)
            categories.remove(at: indexPath.row)
        } catch {
            assertionFailure("Error of deleting category: \(error.localizedDescription)")
        }
    }
}
