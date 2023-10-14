//
//  TabBarController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let mainTrackerViewController = UINavigationController(rootViewController: TrackerViewController())
    let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .yp_Blue
        generateTabBar()
        if let trackersVC = mainTrackerViewController.viewControllers.first as? TrackerViewController,
           let statisticVC = statisticViewController.viewControllers.first as? StatisticViewController {
            trackersVC.delegate = statisticVC
        }
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .ypWhiteDay
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    private func generateTabBar() {
        mainTrackerViewController.tabBarItem = UITabBarItem(
            title: LocalizableKeys.trackersTabBarItem,
            image: ImageAssets.tabBarTrackersIcon,
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: LocalizableKeys.statisticsTabBarItem,
            image: ImageAssets.tabBarStatisticIcon,
            selectedImage: nil
        )
        
        self.viewControllers = [mainTrackerViewController, statisticViewController]
    }
}
