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

final class TrackerViewController: UIViewController {
    
    private let params = GeometryParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private let noFoundImage = UIImage(named: "noFound")
    private let errorImage = UIImage(named: "errorImage")
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
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
        picker.date = Date()
        picker.addTarget(self, action: #selector(datePickerValueChanges), for: .valueChanged)
        return picker
    }()
    
    private var pinTracker = false
    
    private lazy var weekDay = {
        datePicker.calendar.component(.weekday, from: currentDate)
    }()
    
    private var searchController: UISearchController?
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var filteredCategoriesByDate: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupSearch()
        filteredByDate(weekDay: weekDay, chooseMethod: true)
    }
    
    private func showBackgroundView(forCollection: Bool) {
        if visibleCategories.isEmpty {
            let emptyView = EmptyView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: view.bounds.width,
                                                    height: view.bounds.height),
                                      image: forCollection ? errorImage : noFoundImage,
                                      text: forCollection ? "Что будем отслеживать?" : "Ничего не найдено")
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
        weekDay = sender.calendar.component(.weekday, from: sender.date)
        filteredByDate(weekDay: weekDay, chooseMethod: false)
    }
    
    // MARK: Filtered by date
    private func filteredByDate(weekDay: Int, chooseMethod: Bool) {
        let day = "".shortStringDayForInt(weekDay)
        
        filteredCategoriesByDate = categories
        for category in categories {
            var filterTrackers: [Tracker] = []
            for tracker in category.trackers {
                if let timetable = tracker.timetable {
                    if timetable.contains(where: { $0 == day }) {
                        filterTrackers.append(tracker)
                    }
                    if timetable.isEmpty {
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
        visibleCategories = categories
        chooseMethod ? categories = filteredCategoriesByDate : (dismiss(animated: true) {
                self.categories = self.filteredCategoriesByDate
            })
        showBackgroundView(forCollection: true)
    }
}

// MARK: - TrackerViewControllerDelegate
extension TrackerViewController: TrackerViewControllerDelegate {
    func createTracker(_ tracker: Tracker?, titleCategory: String?) {
        guard let newTracker = tracker, let newTitleCategory = titleCategory else { return }
        do {
            try trackerCategoryStore.createTrackerWithCategory(tracker: newTracker, with: newTitleCategory)
        } catch {
            print("failed create tracker")
        }
        categories = trackerCategoryStore.categories
        filteredByDate(weekDay: weekDay, chooseMethod: true)
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

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: Context menu configuration
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfiguration configuration: UIContextMenuConfiguration,
                        highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let targetView = configurationTargetView(indexPath: indexPath)
        return UITargetedPreview(view: targetView.0, parameters: targetView.1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfiguration configuration: UIContextMenuConfiguration,
                        dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        let targetView = configurationTargetView(indexPath: indexPath)
        return UITargetedPreview(view: targetView.0, parameters: targetView.1)
    }
    private func configurationTargetView(indexPath: IndexPath) -> (UIView, UIPreviewParameters) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return (UIView(), UIPreviewParameters())}
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        let targetView = cell.colorView
        return (targetView, parameters)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        let menu = UIMenu(
            children: [
                UIAction(title: pinTracker ? "Открепить" : "Закрепить") { [weak self] _ in
                    guard let self else { return }
                    if self.pinTracker {
                        self.makeUnpin(indexPath: indexPath)
                    } else {
                        self.makePin(indexPath: indexPath)
                    }
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    guard let self else { return }
                    self.makeEdit(indexPath: indexPath)
                },
                UIAction(title: "Удалить", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive) {[weak self] _ in
                    guard let self else { return }
                    self.makeDelete(indexPath: indexPath)}
            ])
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return menu
        }
        
        return configuration
    }
    private func makePin(indexPath: IndexPath) {
        pinTracker = true
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        cell?.pinnedImageEnabled(yes: pinTracker)
    }
    private func makeUnpin(indexPath: IndexPath) {
        pinTracker = false
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        cell?.pinnedImageEnabled(yes: pinTracker)
    }
    private func makeEdit(indexPath: IndexPath) {
        let _ = collectionView.cellForItem(at: indexPath) as? TrackerCell
        //cell?.backgroundColor = .red
    }
    private func makeDelete(indexPath: IndexPath) {
        let _ = collectionView.cellForItem(at: indexPath) as? TrackerCell
        //cell?.backgroundColor = .systemBackground
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
        filterCategories(with: searchText)
    }

    private func filterCategories(with searchText: String) {
        if searchText.isEmpty {
            filteredByDate(weekDay: weekDay, chooseMethod: true)
        } else {
            visibleCategories = categories.map { category -> TrackerCategory in
                let filteredTrackers = category.trackers.filter { tracker -> Bool in
                    let isNameMatching = tracker.name.lowercased().contains(searchText.lowercased())

                    if let timetable = tracker.timetable, !timetable.isEmpty {
                        return isNameMatching && timetable.contains { $0 == "".shortStringDayForInt(weekDay) }
                    } else {
                        return isNameMatching
                    }
                }

                let filteredCategory = TrackerCategory(title: category.title, trackers: filteredTrackers)

                return filteredCategory
            }.filter { $0.trackers.count > 0 }
        }
        showBackgroundView(forCollection: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredByDate(weekDay: weekDay, chooseMethod: true)
    }
    
    private func filterCategoriesByDay(_ categories: [TrackerCategory], forDay day: String) -> [TrackerCategory] {
        return categories.compactMap { category in
            let filterTrackers = category.trackers.filter { tracker in
                if let timetable = tracker.timetable {
                    return timetable.contains(where: { $0 == day })
                } else {
                    return true
                }
            }
            if !filterTrackers.isEmpty {
                return TrackerCategory(title: category.title, trackers: filterTrackers)
            }
            return nil
        }
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
        
        categories = trackerCategoryStore.categories
        visibleCategories = categories
        filteredCategoriesByDate = categories
        
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
