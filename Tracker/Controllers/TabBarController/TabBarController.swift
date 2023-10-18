//
//  TabBarController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .yp_Blue
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticsViewController()
        let statisticViewModel = StatisticsViewModel()
        statisticViewController.initialize(viewModel: statisticViewModel)
        trackerViewController.delegate = statisticViewModel
        let mainViewController = UINavigationController(rootViewController: trackerViewController)
        let secondViewController = UINavigationController(rootViewController: statisticViewController)
        
        generateTabBar(mainViewController, secondViewController)
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    private func generateTabBar(_ main: UINavigationController, _ second: UINavigationController) {
        main.tabBarItem = UITabBarItem(
            title: LocalizableKeys.trackersTabBarItem,
            image: ImageAssets.tabBarTrackersIcon,
            selectedImage: nil
        )
        
        second.tabBarItem = UITabBarItem(
            title: LocalizableKeys.statisticsTabBarItem,
            image: ImageAssets.tabBarStatisticIcon,
            selectedImage: nil
        )
        
        self.viewControllers = [main, second]
    }
}
