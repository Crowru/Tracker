//
//  TimetableViewController.swift
//  Tracker
//
//  Created by Руслан  on 05.09.2023.
//

import UIKit

private enum WeekDays: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    static let numberOfDays = WeekDays.allCases.count
}

final class TimetableViewController: UIViewController {
    
    weak var delegate: HabitDelegate?
    
    private var timetableSavedArray = UserDefaults.standard.array(forKey: "timetable") as? [String] ?? []
    
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
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveWeekDays), for: .touchUpInside)
        return button
    }()
    
    private var timetable: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: Action
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
        cell.textLabel?.text = WeekDays.allCases[indexPath.row].rawValue
        cell.backgroundColor = .ypBackgroundDay
        cell.delegateCell = self
        timetableSavedArray.forEach { day in
            if day == shortDays(for: (cell.textLabel?.text) ?? "") {
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
        UserDefaults.standard.set(timetable, forKey: "timetable")
    }
    
    private func shortDays(for day: String) -> String {
        switch day {
        case "Понедельник": return "Пн"
        case "Вторник": return "Вт"
        case "Среда": return "Ср"
        case "Четверг": return "Чт"
        case "Пятница": return "Пт"
        case "Суббота": return "Сб"
        case "Воскресенье": return "Вс"
        default: return ""
        }
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
