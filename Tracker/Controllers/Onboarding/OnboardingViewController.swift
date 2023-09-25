//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Руслан  on 24.09.2023.
//

import UIKit

protocol OnboardingPageDelegate: AnyObject {
    func didTapNextButton()
}

final class OnboardingViewController: UIPageViewController {
        
    private let pageControl = UIPageControl()
    
    lazy var pages: [UIViewController] = {
        let pageOne = OnboardingFirst()
        pageOne.delegate = self
        
        let pageTwo = OnboardingSecond()
        
        return [pageOne, pageTwo]
    }()
    
    init(transitionStyle: UIPageViewController.TransitionStyle) {
        super.init(transitionStyle: transitionStyle, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupPageControl()
    }
    
    // MARK: Functions
    private func setupPageControl() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        delegate = self
        dataSource = self
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .ypGray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
    }
    
    // MARK: Selectors
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let tappedPageIndex = sender.currentPage
        if tappedPageIndex >= 0 && tappedPageIndex < pages.count {
            let targetPage = pages[tappedPageIndex]
            guard let currentViewController = viewControllers?.first else {
                return
            }
            if let currentIndex = pages.firstIndex(of: currentViewController) {
                let direction: UIPageViewController.NavigationDirection = tappedPageIndex > currentIndex ? .forward : .reverse
                setViewControllers([targetPage], direction: direction, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - OnboardingPageDelegate
extension OnboardingViewController: OnboardingPageDelegate {
    func didTapNextButton() {
        goToNextPage()
    }
    
    private func goToNextPage() {
        guard let currentViewController = viewControllers?.first else {
            return
        }
        if let currentIndex = pages.firstIndex(of: currentViewController) {
            let nextIndex = currentIndex + 1
            
            if nextIndex < pages.count {
                let nextViewController = pages[nextIndex]
                setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                pageControl.currentPage = nextIndex
            }
        }
    }
}

// MARK: - Setup Views and Constraints
private extension OnboardingViewController {
    func setupViews() {
        view.addSubviews(pageControl)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
