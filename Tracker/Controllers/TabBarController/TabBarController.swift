//
//  TabBarController.swift
//  Tracker
//
//  Created by Руслан  on 26.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let mainTrackerViewController = MainTrackerViewController()
        mainTrackerViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "trackersIcon"),
            selectedImage: nil
        )
        
//        let statisticsViewController = StatisticsViewController()
//        statisticsViewController.tabBarItem = UITabBarItem(
//            title: nil,
//            image: UIImage(named: "tab_profile_active"),
//            selectedImage: nil
//        )
        self.viewControllers = [mainTrackerViewController]
    }
}
