//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

// MARK: - StatisticViewControllerDelegate
protocol StatisticViewControllerDelegate: AnyObject {
    func showCompletedTrackers(_ completeTrackers: Int)
}

final class StatisticViewController: UIViewController {
    
    private let statisticsKey = "statisticsTrackersCompleted"
    private let completeTrackersKey = "completeTrackers"
    
    private var completeTrackers: Int {
        get {
            UserDefaults.standard.integer(forKey: completeTrackersKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: completeTrackersKey)
            updateCompleteTrackers()
        }
    }
    
    private lazy var statisticView: UIView = {
        let view = UIView()
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.layer.cornerRadius = 16
        view.addSubview(countTrackersLabel)
        view.addSubview(trackersCompletedLabel)
        return view
    }()
    
    private lazy var countTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = completeTrackers.description
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
            UIColor.ypGradientRed.cgColor,
            UIColor.ypGradientGreen.cgColor,
            UIColor.ypGradientBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBackgroundView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        setupGradientBorder(to: statisticView)
    }
}

// MARK: - Private Func
private extension StatisticViewController {
    func updateCompleteTrackers() {
        countTrackersLabel.text = completeTrackers.description
        trackersCompletedLabel.text = String.localizedStringWithFormat(
            NSLocalizedString(statisticsKey, comment: ""), completeTrackers)
    }
    
    func showBackgroundView() {
        if completeTrackers == 0 {
            let emptyView = EmptyView(
                frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height),
                image: ImageAssets.statisticErrorImage,
                text: LocalizableKeys.statisticsErrorLabel
            )
            self.view = emptyView
        } else {
            view = UIView()
            setupUI()
            updateCompleteTrackers()
        }
    }
    
    // MARK: Setup Gradient
    func setupGradientBorder(to view: UIView, cornerRadius: CGFloat = 16, borderWidth: CGFloat = 1.0) {
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

// MARK: - StatisticViewControllerDelegate
extension StatisticViewController: StatisticViewControllerDelegate {
    func showCompletedTrackers(_ completedTrackers: Int) {
        self.completeTrackers = completedTrackers
    }
}

// MARK: - Setup Navigation Bar
private extension StatisticViewController {
    func setupNavigationBar() {
        navigationItem.title = LocalizableKeys.statisticsTabBarItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - SetupUI
private extension StatisticViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = ColoursTheme.blackDayWhiteDay
        view.addSubviews(statisticView)
        statisticView.addSubviews(countTrackersLabel, trackersCompletedLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            statisticView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            statisticView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticView.heightAnchor.constraint(equalToConstant: view.bounds.width * 90/343),
            
            countTrackersLabel.topAnchor.constraint(equalTo: statisticView.topAnchor, constant: 15),
            countTrackersLabel.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 12),
            
            trackersCompletedLabel.topAnchor.constraint(equalTo: countTrackersLabel.bottomAnchor, constant: 15),
            trackersCompletedLabel.leadingAnchor.constraint(equalTo: statisticView.leadingAnchor, constant: 12),
        ])
    }
}
