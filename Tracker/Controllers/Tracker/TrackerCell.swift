//
//  TrackerCell.swift
//  Tracker
//
//  Created by Руслан  on 24.08.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompletedTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    private var isCompletedToday = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = colorView.backgroundColor
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pinnedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAssets.pinned
        imageView.isHidden = true
        return imageView
    }()
    
    private func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubviews(colorView, counterLabel, plusButton)
        colorView.addSubviews(emojiLabel, textLabel, pinnedImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 90/167),
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            counterLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            plusButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            
            pinnedImage.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            pinnedImage.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            pinnedImage.heightAnchor.constraint(equalToConstant: 24),
            pinnedImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func pinnedImageEnabled(yes: Bool) {
        yes ? pinnedImage.isHidden = false : (pinnedImage.isHidden = true)
    }
    
    func setupCell(tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.isCompletedToday = isCompletedToday
        self.trackerId = tracker.id
        self.indexPath = indexPath
        
        updateCounterText(days: completedDays)
        updatePlusButton(trackerCompleted: isCompletedToday)
        
        colorView.backgroundColor = tracker.color
        textLabel.text = tracker.name
        emojiLabel.text = tracker.emojie
        plusButton.backgroundColor = tracker.color
    }
    
    private func updateCounterText(days: Int) {
        let tasksString = String.localizedStringWithFormat(
            NSLocalizedString("numberOfTasks", comment: "Number of remaining tasks"), days)
        counterLabel.text = tasksString
    }
    
    private func updatePlusButton(trackerCompleted: Bool) {
        let image: UIImage = (trackerCompleted ? ImageAssets.systemCheckmark : ImageAssets.systemPlus)!
        plusButton.setImage(image, for: .normal)
        let buttonOpacity: Float = trackerCompleted ? 0.3 : 1
        plusButton.layer.opacity = buttonOpacity
    }
    
    // MARK: - Action
    @objc
    private func buttonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else { return }
        if isCompletedToday {
            delegate?.uncompletedTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completedTracker(id: trackerId, at: indexPath)
        }
    }
}
