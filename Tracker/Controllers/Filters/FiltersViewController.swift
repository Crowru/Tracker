//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Руслан  on 19.10.2023.
//

import UIKit

protocol FiltersViewControllerProtocol: AnyObject {
    func filterAllTrackers()
    func filterTrackersForToday()
    func filterCompletedTrackers()
    func filterUnCompletedTrackers()
}

final class FiltersViewController: UIViewController {
    private let namesRows = [
        LocalizableKeys.filterLabelOne,
        LocalizableKeys.filterLabelTwo,
        LocalizableKeys.filterLabelThree,
        LocalizableKeys.filterLabelFour
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColoursTheme.blackDayWhiteDay
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var editingIndexFilter: IndexPath? {
        didSet {
            UserDefaultsManager.editingIndexFilter = editingIndexFilter?.row
        }
    }
    
    weak var delegate: FiltersViewControllerProtocol?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        dataIndexesCategories()
    }
    
    // MARK: Analytics
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.openScreenReport(screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.closeScreenReport(screen: .main)
    }
    
    // MARK: Methods
    private func dataIndexesCategories() {
        guard let row = UserDefaultsManager.editingIndexFilter else { return }
        editingIndexFilter = IndexPath(row: row, section: 0)
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesRows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = namesRows[indexPath.row]
        cell.backgroundColor = ColoursTheme.backgroundNightDay
        cell.accessoryType = indexPath == editingIndexFilter ? .checkmark : .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editingIndexPath = editingIndexFilter {
            let previousSelectedCell = tableView.cellForRow(at: editingIndexPath)
            previousSelectedCell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        editingIndexFilter = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
        
        switch indexPath.row {
        case 0: delegate?.filterAllTrackers()
        case 1: delegate?.filterTrackersForToday()
        case 2: delegate?.filterCompletedTrackers()
        case 3: delegate?.filterUnCompletedTrackers()
        default: return
        }
    }
}
