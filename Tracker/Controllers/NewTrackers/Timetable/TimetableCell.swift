//
//  TimetableCell.swift
//  Tracker
//
//  Created by Руслан  on 05.09.2023.
//

import UIKit

protocol TimetableCellDelegate: AnyObject {
    func didToogleSwitch(for day: String, isOn: Bool)
}

final class TimetableCell: UITableViewCell {
    
    weak var delegateCell: TimetableCellDelegate?
    
    lazy var switchDay: UISwitch = {
        let switchDay = UISwitch()
        switchDay.onTintColor = .systemBlue
        switchDay.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        return switchDay
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc
    private func switchTapped(_ sender: UISwitch) {
        if let daysOfWeek = textLabel?.text {
            let shortDay = shortDays(for: daysOfWeek)
            delegateCell?.didToogleSwitch(for: shortDay, isOn: sender.isOn)
        }
    }
    
    // MARK: Shorten the Days
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

private extension TimetableCell {
    func setupCell() {
        contentView.addSubviews(switchDay)
        
        NSLayoutConstraint.activate([
            switchDay.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
