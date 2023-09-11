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
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(addNewHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.addTarget(self, action: #selector(addIreggularEvent), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: Actions
    @objc
    private func addNewHabit() {
        let habitViewController = NewTrackerViewController()
        habitViewController.title = "Новая привычка"
        habitViewController.onTrackerCreated = { [weak self] tracker, titleCategory in
            guard let self = self else { return }
            self.delegate?.createTracker(tracker, titleCategory: titleCategory)
        }
        
        UserDefaults.standard.removeObject(forKey: "timetable")
        let navigationController = UINavigationController(rootViewController: habitViewController)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
    
    @objc
    private func addIreggularEvent() {
        let eventViewController = NewTrackerViewController()
        eventViewController.title = "Новое нерегулярное событие"
        eventViewController.chooseIrregularEvent = true
        eventViewController.onTrackerCreated = { [weak self] (tracker, titleCategory) in
            guard let self else { return }
            self.delegate?.createTracker(tracker, titleCategory: titleCategory)
        }
        
        let navigationController = UINavigationController(rootViewController: eventViewController)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
}

// MARK: - SetupViews
private extension TrackersTypeViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(habitButton, irregularEventButton)
        [habitButton, irregularEventButton].forEach {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = .ypBlackDay
            $0.tintColor = .white
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
