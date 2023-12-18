//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var trackersCompletedView: UIView = {
        let view = UIView()
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.layer.cornerRadius = 16
        countTrackersLabel.text = viewModel?.completedTrackers.count.description
        trackersCompletedLabel.text = viewModel?.trackersCompletedText()
        view.addSubviews(countTrackersLabel, trackersCompletedLabel)
        return view
    }()
    private lazy var countTrackersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = ColoursTheme.whiteDayBlackDay
        return label
    }()
    private lazy var trackersCompletedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = ColoursTheme.whiteDayBlackDay
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.gradientRed.cgColor,
            UIColor.gradientGreen.cgColor,
            UIColor.gradientBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    // MARK: ViewModel
    var viewModel: StatisticsViewModel?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        showBackgroundView()
    }
    func initialize(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    // MARK: Binding
    private func bind() {
        viewModel?.$completedTrackers.bind(action: { [weak self] _ in
            self?.showBackgroundView()
        })
    }
    
    // MARK: Update completed trackers
    private func updateCompletedTrackers() {
        countTrackersLabel.text = viewModel?.completedTrackers.count.description
        trackersCompletedLabel.text = viewModel?.trackersCompletedText()
    }
    
    private func showBackgroundView() {
        guard let completedTrackers = viewModel?.completedTrackers else { return }
        if completedTrackers.isEmpty {
            emptyView(ImageAssets.statisticErrorImage, LocalizableKeys.statisticsErrorLabel)
        } else {
            emptyView(nil, "")
            setupViewsConstraints()
            updateCompletedTrackers()
        }
    }
    private func emptyView(_ image: UIImage?, _ text: String) {
        let emptyViewStub = EmptyView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), image: image, text: text)
        view = emptyViewStub
    }
    
    // MARK: GradientLayer methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientBorder(to: trackersCompletedView, gradientLayer: gradientLayer)
    }
    private func setupGradientBorder(to view: UIView, cornerRadius: CGFloat = 16, borderWidth: CGFloat = 2.0, gradientLayer: CAGradientLayer) {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shapeLayer
        view.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Setup views and constraints
private extension StatisticsViewController {
    func setupNavigationBar() {
        navigationItem.title = LocalizableKeys.statisticsTabBarItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupViewsConstraints() {
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.addSubviews(trackersCompletedView)
        trackersCompletedView.addSubviews(countTrackersLabel, trackersCompletedLabel)
        
        NSLayoutConstraint.activate([
            trackersCompletedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            trackersCompletedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCompletedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCompletedView.heightAnchor.constraint(equalToConstant: view.bounds.width * 90/343),
            
            countTrackersLabel.topAnchor.constraint(equalTo: trackersCompletedView.topAnchor, constant: 15),
            countTrackersLabel.leadingAnchor.constraint(equalTo: trackersCompletedView.leadingAnchor, constant: 12),
            
            trackersCompletedLabel.topAnchor.constraint(equalTo: countTrackersLabel.bottomAnchor, constant: 15),
            trackersCompletedLabel.leadingAnchor.constraint(equalTo: trackersCompletedView.leadingAnchor, constant: 12)
        ])
    }
}
