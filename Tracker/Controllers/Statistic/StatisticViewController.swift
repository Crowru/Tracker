//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let errorImageView: UIImageView = {
        let image = UIImage(named: "statisticErrorImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupAllConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension StatisticViewController {
    func setupViews() {
        view.backgroundColor = .ypWhiteDay
        view.addSubviews(errorImageView, errorLabel)
    }
    
    func setupAllConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}
