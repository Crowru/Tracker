//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Руслан  on 24.08.2023.
//

import UIKit

private enum SizeCollectionView: CGFloat {
    case distanceBetweenCells = 16
    case betweenHeaderAndCell = 12
}

protocol TrackerViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker?, titleCategory: String?)
}

final class TrackerViewController: UIViewController & TrackerViewControllerDelegate {
    
    private let params = GeometryParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private let noFoundImage = UIImage(named: "noFound")
    private let errorImage = UIImage(named: "errorImage")
    
    var currentDate: Date { return datePicker.date }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(HeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
        return collectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.tintColor = .systemBlue
        picker.addTarget(self, action: #selector(datePickerValueChanges), for: .valueChanged)
        return picker
    }()
        
    private var searchController: UISearchController?
    
    private var categories: [TrackerCategory] = []
        
    private var filteredCategoriesByDate: [TrackerCategory] = []
    
    private var completedTrackers: Set<TrackerRecord> = []
    
    private var visibleCategories: [TrackerCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupSearch()
        updateCollectionView()
    }
    
    func createTracker(_ tracker: Tracker?, titleCategory: String?) {
        guard let newTracker = tracker, let newTitleCategory = titleCategory else { return }
        let newCategory = TrackerCategory(title: newTitleCategory, trackers: [newTracker])
        if categories.contains(where: { $0.title == newCategory.title }) {
            guard let index = categories.firstIndex(where: { $0.title == newCategory.title }) else { return }
            let oldCategory = categories[index]
            let updatedTrackers = oldCategory.trackers + newCategory.trackers
            let updatedTrackerCategory = TrackerCategory(title: newCategory.title, trackers: updatedTrackers)
            categories[index] = updatedTrackerCategory
        } else {
            categories.append(newCategory)
        }
        let weekDay = datePicker.calendar.component(.weekday, from: currentDate)
        filteredByDate(weekDay: weekDay, chooseMethod: true)
    }
    
    private func updateCollectionView() {
        if categories.isEmpty {
            let emptyView = EmptyView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), 
                                      image: errorImage,
                                      text: "Что будем отслеживать?")
            collectionView.backgroundView = emptyView
        } else {
            collectionView.backgroundView = nil
        }
        collectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            
            let leftButton = UIBarButtonItem(image: UIImage(named: "addButton"), style: .plain, target: self, action: #selector(addNewTracker))
            leftButton.tintColor = .ypBlackDay
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            
            let dateButton = UIBarButtonItem(customView: datePicker)
            
            navBar.topItem?.setRightBarButton(dateButton, animated: true)
        }
    }
    
    // MARK: Actions
    @objc
    private func addNewTracker() {
        let trackersTypeViewController = TrackersTypeViewController()
        trackersTypeViewController.title = "Создание трекера"
        trackersTypeViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackersTypeViewController)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
    
    @objc
    private func datePickerValueChanges(_ sender: UIDatePicker) {
        let weekDay = sender.calendar.component(.weekday, from: sender.date)
        filteredByDate(weekDay: weekDay, chooseMethod: false)
    }
    
    private func filteredByDate(weekDay: Int, chooseMethod: Bool) {
        let weekDay = weekDay
        var day = ""
        switch weekDay {
        case 1: day = "Вс"
        case 2: day = "Пн"
        case 3: day = "Вт"
        case 4: day = "Ср"
        case 5: day = "Чт"
        case 6: day = "Пт"
        case 7: day = "Сб"
        default: break
        }
        filteredCategoriesByDate = categories
        for category in categories {
            var filterTrackers: [Tracker] = []
            for tracker in category.trackers {
                if let timetable = tracker.timetable {
                    if timetable.contains(where: { $0 == day }) {
                        filterTrackers.append(tracker)
                    }
                } else {
                    filterTrackers.append(tracker)
                }
            }
            let newCategory = TrackerCategory(title: category.title, trackers: filterTrackers)
            if newCategory.title == category.title {
                guard let index = categories.firstIndex(where: { $0.title == newCategory.title }) else { return }
                categories[index] = newCategory
            }
        }
        for category in categories where category.trackers.isEmpty {
            guard let index = categories.firstIndex(where: { $0.trackers.isEmpty }) else { return }
            categories.remove(at: index)
        }
        updateCollectionView()
        visibleCategories = categories
        chooseMethod ? categories = filteredCategoriesByDate : (dismiss(animated: true) {
                self.categories = self.filteredCategoriesByDate
            })
        datePicker.date = currentDate
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else { return UICollectionViewCell()}
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.id == tracker.id }.count
        let isToday = completedTrackers.contains {
            $0.id == tracker.id &&
            areDatesEqualIgnoringTime(date1: $0.date, date2: currentDate
            ) } ? true : false
        cell.setupCell(tracker: tracker)
        cell.completeTracker(days: daysCount, isToday: isToday)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderViewCell else { return UICollectionReusableView()}
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
}

// MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func plusButtonTapped(on cell: TrackerCell) {
        let indexPath: IndexPath = collectionView.indexPath(for: cell) ?? IndexPath()
        let id = visibleCategories[indexPath.section].trackers[indexPath.row].id
        var daysCount = completedTrackers.filter { $0.id == id }.count
        let isToday = completedTrackers.contains(where: { $0.id == id && areDatesEqualIgnoringTime(date1: $0.date, date2: currentDate) })
        if !isToday {
            completedTrackers.insert(TrackerRecord(id: id, date: currentDate))
            daysCount += 1
        } else {
            completedTrackers.remove(TrackerRecord(id: id, date: currentDate))
            daysCount -= 1
        }
        cell.completeTracker(days: daysCount, isToday: !isToday)
    }
    
    private func areDatesEqualIgnoringTime(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth , height: cellWidth * 148/167)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SizeCollectionView.betweenHeaderAndCell.rawValue, left: params.leftInset, bottom: SizeCollectionView.distanceBetweenCells.rawValue, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SizeCollectionView.distanceBetweenCells.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

//MARK: - UISearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let weekDay = datePicker.calendar.component(.weekday, from: currentDate)
        var day = ""
        switch weekDay {
        case 1: day = "Вс"
        case 2: day = "Пн"
        case 3: day = "Вт"
        case 4: day = "Ср"
        case 5: day = "Чт"
        case 6: day = "Пт"
        case 7: day = "Сб"
        default: break
        }
        
        var filteredTrackers: [Tracker] = []
        
        for category in categories {
            let matchingTrackers = category.trackers.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
            filteredTrackers.append(contentsOf: matchingTrackers)
        }
        
        filteredCategoriesByDate = categories.map { category in
            let filterTrackers = category.trackers.filter { tracker in
                if let timetable = tracker.timetable {
                    return timetable.contains(where: { $0 == day })
                } else {
                    return true
                }
            }
            return TrackerCategory(title: category.title, trackers: filterTrackers)
        }
        
        
        visibleCategories = filteredCategoriesByDate.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return filteredTrackers.contains { $0.id == tracker.id }
            }
            if !filteredTrackers.isEmpty {
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            return nil
        }
        
        updateCollectionView()
        if visibleCategories.isEmpty {
            let trackerViewStub = EmptyView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), image: noFoundImage,
                                            text: "Ничего не найдено")
            collectionView.backgroundView = trackerViewStub
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        visibleCategories = filteredCategoriesByDate
        updateCollectionView()
    }
    
    private func setupSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Поиск"
        
        navigationItem.searchController = searchController
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlackDay,
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        
        definesPresentationContext = true
    }
}

//MARK: - SetupViews
private extension TrackerViewController {
    func setupViews() {
        view.addSubviews(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
