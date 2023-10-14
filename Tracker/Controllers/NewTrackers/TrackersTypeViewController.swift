//
//  TrackersTypeViewController.swift
//  Tracker
//
//  Created by Руслан  on 01.09.2023.
//

import UIKit

final class TrackersTypeViewController: UIViewController {
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableKeys.chooseTrackerButton, for: .normal)
        button.addTarget(self, action: #selector(addNewHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizableKeys.showIrregularEventButton, for: .normal)
        button.addTarget(self, action: #selector(addIreggularEvent), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func showTrackers(_ isIreggularEvent: Bool, _ title: String) {
        UserDefaultsManager.showIrregularEvent = isIreggularEvent
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.title = title
        newTrackerVC.onTrackerCreated = { [weak self] tracker, titleCotegory in
            guard let self else { return }
            self.delegate?.createTracker(tracker, titleCategory: titleCotegory)
        }
        let navigationController = UINavigationController(rootViewController: newTrackerVC)
        navigationController.navigationBar.barTintColor = ColoursTheme.blackDayWhiteDay
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
    
    // MARK: Selectors
    @objc
    private func addNewHabit() {
        showTrackers(false, LocalizableKeys.showTrackerButton)
        UserDefaultsManager.timetableArray = []
    }
    
    @objc
    private func addIreggularEvent() {
        showTrackers(true, LocalizableKeys.showIrregularEventButton)
    }
}

// MARK: - SetupViews
private extension TrackersTypeViewController {
    func setupViews() {
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.addSubviews(habitButton, irregularEventButton)
        [habitButton, irregularEventButton].forEach {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = ColoursTheme.whiteDayBlackDay
            $0.setTitleColor(ColoursTheme.blackDayWhiteDay, for: .normal)
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            habitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            irregularEventButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
