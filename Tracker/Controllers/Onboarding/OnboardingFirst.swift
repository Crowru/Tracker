//
//  OnboardingFirst.swift
//  Tracker
//
//  Created by Руслан  on 25.09.2023.
//

import UIKit

final class OnboardingFirst: UIViewController {
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firstBackground")
        return imageView
    }()
    private let labelOnboarding: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.labelOnboardingFirst
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypBlackDay
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private lazy var tapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlackDay
        button.setTitle(LocalizableKeys.buttonOnboarding, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        return button
    }()
    
    weak var delegate: OnboardingPageDelegate?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: Functions
    private func animateButton(completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.1, animations: {
                self.tapButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.tapButton.transform = CGAffineTransform.identity
                }, completion: { _ in
                    completion()
                })
            }
        }
    }
    
    // MARK: Selectors
    @objc func showNextScreen() {
        animateButton {
            self.delegate?.didTapNextButton()
        }
    }
    
    @objc func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.tapButton.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
        }
    }
    
    @objc func touchUpOutside() {
        UIView.animate(withDuration: 0.1) {
            self.tapButton.transform = .identity
        }
    }
}

// MARK: - Setup Views and Constraints
private extension OnboardingFirst {
    func setupViews() {
        view.addSubviews(backgroundImage, labelOnboarding, tapButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelOnboarding.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            labelOnboarding.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            labelOnboarding.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelOnboarding.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
        
            tapButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            tapButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
