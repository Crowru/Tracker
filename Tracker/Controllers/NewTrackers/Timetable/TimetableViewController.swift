//
//  TimetableViewController.swift
//  Tracker
//
//  Created by Руслан  on 05.09.2023.
//

import UIKit

final class TimetableViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerProtocol?
    private var timetable: [String] = []
    private var timetableArray = UserDefaultsManager.timetableArray ?? []
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200), style: .insetGrouped)
        tableView.register(TimetableCell.self, forCellReuseIdentifier: TimetableCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableKeys.addNewCategoryDoneButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveWeekDays), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: Selectors
    @objc
    private func saveWeekDays() {
        delegate?.addDetailDays(timetable)
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDays.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else { return UITableViewCell() }
        cell.textLabel?.text = WeekDays.localize(WeekDays.allCases[indexPath.row])()
        cell.backgroundColor = .ypBackgroundDay
        cell.delegateCell = self
        timetableArray.forEach { day in
            if day == WeekDays[cell.textLabel?.text ?? ""] {
                cell.switchDay.isOn = true
                didToogleSwitch(for: day, isOn: true)
            }
        }
        return cell
    }
}

//MARK: - TimetableCellDelegate
extension TimetableViewController: TimetableCellDelegate {
    func didToogleSwitch(for day: String, isOn: Bool) {
        isOn ? timetable.append(day) : (timetable.removeAll { $0 == day })
        UserDefaultsManager.timetableArray = timetable
    }
}

private extension TimetableViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(tableView, doneButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * 8),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
